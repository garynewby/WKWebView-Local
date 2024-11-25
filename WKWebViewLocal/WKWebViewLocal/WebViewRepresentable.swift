//
//  WebView.swift
//  WKWebViewLocal
//
//  Created by Gary Newby on 25/11/2024.
//

import SwiftUI
@preconcurrency
import WebKit

struct WebViewRepresentable: UIViewRepresentable {

    let viewModel: WebViewModel
    let webView = WKWebView()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView  {
        webView.navigationDelegate = context.coordinator
        if let url = viewModel.url {
            webView.load(URLRequest(url: url))
        }
        viewModel.assignWebView(webView: webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebViewRepresentable

        var webView: WKWebView {
            parent.webView
        }
        var viewModel: WebViewModel {
            parent.viewModel
        }

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
            super.init()

            // Add addScriptMessageHandler in javascript: window.webkit.messageHandlers.MyObserver.postMessage()
            webView.configuration.userContentController.add(self, name: "MyObserver")
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                if let url = navigationAction.request.url {
                    webView.load(URLRequest(url: url))
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            viewModel.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewModel.isLoading = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            viewModel.isLoading = false
            viewModel.error = error
            print("loading error: \(error)")
        }

        /// Callback from javascript: window.webkit.messageHandlers.MyObserver.postMessage(message)
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            let messageFromWebPage = message.body as! String

            if messageFromWebPage == "index" {
                viewModel.backButtonIsEnabled = false
                viewModel.loadFile(name: messageFromWebPage)
                return
            }
            if messageFromWebPage == "goPage" {
                viewModel.backButtonIsEnabled = true
                return
            }

            let alertController = UIAlertController(title: "Javascript said:", message: messageFromWebPage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                print("OK")
            }
            alertController.addAction(okAction)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            rootViewController.present(alertController, animated: true)
        }
    }
}
