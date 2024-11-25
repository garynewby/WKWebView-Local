//
//  WebViewModel.swift
//  WKWebViewLocal
//
//  Created by Gary Newby on 25/11/2024.
//

import SwiftUI
import WebKit

@Observable
class WebViewModel {

    var url: URL?
    var error: Error?
    var isLoading = false
    var backButtonIsEnabled = false

    /// Load a file or a HTML string
    let loadFile = false

    weak var webView: WKWebView?

    func assignWebView(webView: WKWebView) {
        self.webView = webView
        
        if loadFile {
            loadFile(name: "index")
        } else {
            loadString(name: "index")
        }
    }

    func loadFile(name: String) {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "html", inDirectory: "Web_Assets") else {
            print("file not found:", name)
            return
        }
        let filePathURL = URL.init(fileURLWithPath: filePath)
        let fileDirectoryURL = filePathURL.deletingLastPathComponent()
        webView?.loadFileURL(filePathURL, allowingReadAccessTo: fileDirectoryURL)
    }

    func loadString(name: String) {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "html", inDirectory: "Web_Assets") else {
            print("file not found:", name)
            return
        }
        do {
            let html = try String(contentsOfFile: filePath, encoding: .utf8)
            /// baseURL needs to be set for local files to load correctly
            webView?.loadHTMLString(html, baseURL: Bundle.main.resourceURL?.appendingPathComponent("Web_Assets"))
        } catch {
            print("Error loading html")
        }
    }

    func callJavascriptFunction(named: String) {
        let script = named
        webView?.evaluateJavaScript(script) { (result: Any?, error: Error?) in
            if let error = error {
                print("evaluateJavaScript error: \(error)")
            } else {
                print("evaluateJavaScript result: \(result ?? "")")
            }
        }
    }

    func isButtonVisible(_ action: String) -> Bool {
        switch action {
        case "goBack()":
            return backButtonIsEnabled
        case "changeText('hello from Swift')":
            return !backButtonIsEnabled
        default:
            return false
        }
    }
}
