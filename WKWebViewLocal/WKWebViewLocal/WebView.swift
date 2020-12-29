//
//  WebView.swift
//  WKWebViewLocal
//
//  Created by Gary Newby on 29/12/2020.
//  Copyright © 2020 Mellowmuse. All rights reserved.
//

import WebKit

// Wrap the WKWebView webview to allow IB use

class WebView: WKWebView {
    required init?(coder: NSCoder) {
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        configuration.userContentController = controller
        super.init(frame: CGRect.zero, configuration: configuration)
    }
}
