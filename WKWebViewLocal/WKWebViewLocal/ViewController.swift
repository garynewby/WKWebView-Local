//
//  ViewController.swift
//  WKWebViewLocal
//
//  Created by Gary Newby on 2/17/18.
//

import UIKit
import WebKit

// Wrap the WKWebView webview to allow IB use

class MyWebView : WKWebView {
    required init?(coder: NSCoder) {
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        configuration.userContentController = controller;
        super.init(frame: CGRect.zero, configuration: configuration)
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var webView: MyWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "WKWebView"
        webView.navigationDelegate = self;

        // Add addScriptMessageHandler in javascript: window.webkit.messageHandlers.MyObserver.postMessage()
        webView.configuration.userContentController.add(self, name: "MyObserver")
        
        // Choose to load a file or a string
        let loadFile = false
        
        if let filePath = Bundle.main.path(forResource:"index", ofType:"html", inDirectory: "Web_Assets") {
            if (loadFile) {
                // load file
                let filePathURL = URL.init(fileURLWithPath: filePath)
                let fileDirectoryURL = filePathURL.deletingLastPathComponent()
                webView.loadFileURL(filePathURL, allowingReadAccessTo: fileDirectoryURL)
            } else {
                do {
                    // load html string - baseURL needs to be set for local files to load correctly
                    let html = try String(contentsOfFile: filePath, encoding: .utf8)
                    webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL?.appendingPathComponent("Web_Assets"))
                } catch {
                    print("Error loading html")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func callJavascriptTapped(_ sender: UIButton) {
        let script = "testJS()"
        webView.evaluateJavaScript(script) { (result: Any?, error: Error?) in
            if let error = error {
                print("evaluateJavaScript error: \(error.localizedDescription)")
            } else {
                print("evaluateJavaScript result: \(result ?? "")")
            }
        }
    }
}

extension ViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Callback from javascript: window.webkit.messageHandlers.MyObserver.postMessage(message)
        let text = message.body as! String;
        let alertController = UIAlertController(title: "Javascript said:", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("OK")
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish navigation:");
    }
}




