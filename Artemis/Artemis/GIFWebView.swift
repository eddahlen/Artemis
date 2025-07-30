//
//  GIFWebView.swift
//  Artemis
//
//  Created by Eric Dahlen on 7/29/25.
//
import SwiftUI
import WebKit

struct GIFWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.scrollView.isScrollEnabled = false
        webview.scrollView.bounces = false
        webview.backgroundColor = .clear
        webview.isOpaque = false
        webview.contentMode = .scaleAspectFit
        return webview
    }

    func updateUIView(_ webview: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webview.load(request)
    }
}

