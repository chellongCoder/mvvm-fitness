//
//  VideoView.swift
//  NYCSchools
//
//  Created by Longnn on 8/9/24.
//

import Foundation
import SwiftUI
import AVKit
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct VideoPlayerContent: View {
    let url = URL(string: "https://youtu.be/Wlf1T5nrO50")!

    var body: some View {
      VStack{
          WebView(url: url)
                .frame(height: 300) // Adjust the height as needed


      }
    }
}

struct VideoPlayerView: View {
    var body: some View {
      VideoPlayerContent()
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}
