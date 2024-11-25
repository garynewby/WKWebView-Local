//
//  ContentView.swift
//  WKWebViewLocal
//
//  Created by Gary Newby on 25/11/2024.
//

import SwiftUI

struct ContentView: View {
    let webViewModel = WebViewModel()
    let actions = ["changeText('hello from Swift')", "goBack()"]

    static var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack {
            WebViewRepresentable(viewModel: webViewModel)
                .cornerRadius(10)

            ForEach(actions, id: \.self) { action in
                if webViewModel.isButtonVisible(action) {
                    Button {
                        webViewModel.callJavascriptFunction(named: action)
                    } label: {
                        Text("Call \(action)")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    ContentView()
}
