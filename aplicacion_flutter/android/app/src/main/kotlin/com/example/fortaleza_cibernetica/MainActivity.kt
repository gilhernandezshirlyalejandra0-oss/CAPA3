
package com.example.fortaleza_cibernetica

import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {

    private val canalVoz = "fortaleza/voz"
    private var lector: TextToSpeech? = null
    private var vozDisponible = false
    private var textoPendiente: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        lector = TextToSpeech(this) { estado ->
            if (estado == TextToSpeech.SUCCESS) {
                var resultado = lector?.setLanguage(Locale("es", "CO"))
                    ?: TextToSpeech.LANG_NOT_SUPPORTED

                if (resultado == TextToSpeech.LANG_MISSING_DATA ||
                    resultado == TextToSpeech.LANG_NOT_SUPPORTED
                ) {
                    resultado = lector?.setLanguage(Locale("es", "ES"))
                        ?: TextToSpeech.LANG_NOT_SUPPORTED
                }

                vozDisponible =
                    resultado != TextToSpeech.LANG_MISSING_DATA &&
                    resultado != TextToSpeech.LANG_NOT_SUPPORTED

                if (vozDisponible) {
                    textoPendiente?.let { texto ->
                        reproducirTexto(texto)
                        textoPendiente = null
                    }
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            canalVoz
        ).setMethodCallHandler { llamada, respuesta ->

            when (llamada.method) {
                "saludar", "leer" -> {
                    val texto = llamada.argument<String>("texto")

                    if (texto.isNullOrBlank()) {
                        respuesta.error(
                            "TEXTO_VACIO",
                            "No se recibio ningun texto.",
                            null
                        )
                    } else if (vozDisponible) {
                        reproducirTexto(texto)
                        respuesta.success(true)
                    } else {
                        textoPendiente = texto
                        respuesta.success(true)
                    }
                }

                "detener" -> {
                    lector?.stop()
                    textoPendiente = null
                    respuesta.success(true)
                }

                else -> respuesta.notImplemented()
            }
        }
    }

    private fun reproducirTexto(texto: String) {
        lector?.speak(
            texto,
            TextToSpeech.QUEUE_FLUSH,
            null,
            "fortaleza_lectura"
        )
    }

    override fun onDestroy() {
        lector?.stop()
        lector?.shutdown()
        lector = null
        super.onDestroy()
    }
}
