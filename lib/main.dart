import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:webview_flutter/webview_flutter.dart";
import "dart:async";
void main() {
  runApp(MyApp());
}

class WebViewWithOverlay extends StatefulWidget {
  const WebViewWithOverlay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WebViewWithOverlayState createState() => _WebViewWithOverlayState();
}

class _WebViewWithOverlayState extends State<WebViewWithOverlay> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // No es necesario configurar SurfaceAndroidWebView en la nueva versión
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView with Overlay'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),  // Usamos WebViewWidget con el controlador
          // Overlay con un menú flotante
          Positioned(
            top: 50,
            right: 10,
            child: GestureDetector(
              onTap: () {
                // Mostrar el menú al hacer clic en el ícono
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Menu'),
                      content: Text('Aquí puedes añadir funciones extra'),
                    );
                  },
                );
              },
              child: Icon(Icons.menu, size: 40, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/home");  // Aquí pones tu ruta
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(seconds: 1),
          child: SvgPicture.asset(
            "assets/csplus.png",
            width: 100,
            height: 100,
            color: Colors.primaries.first,
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(
            JavaScriptMode.unrestricted,
          ) // Habilitar JavaScript
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                _controller.runJavaScript("""
                  const observer = new MutationObserver(mutations => {
                    let btn = document.querySelector("button[aria-label="menu"]");
                    if (btn) {
                      btn.style.display = "none";
                      console.log("Botón ocultado");
                      observer.disconnect(); // Detener la observación
                    }
                  });

                  observer.observe(document.body, { childList: true, subtree: true });
                """);
              },
            ),
          )
          ..loadRequest(
            Uri.parse("https://play.games.dmm.co.jp/game/cravesagax"),
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WebViewWidget(controller: _controller)),
    );
  }
}
