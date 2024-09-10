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
    let url = URL(string: "https://youtu.be/Wlf1T5nrO50&autoplay=1")!
    @Binding var ytLink: String

    var body: some View {
      let isValidYt = self.ytLink.isValidYouTubeLink()
      if(isValidYt) {
        VStack{
            WebView(url: URL(string: ytLink+"&autoplay=1")!)
                  .frame(height: 300) // Adjust the height as needed
        }
      } else {
        WebView(url: url)
          .frame(height: 300).opacity(0.0) // Adjust the height as needed
      }
    }
}

class ObservableSlider: ObservableObject {
    @Published public var value: Double = 0.0
}

struct VideoPlayerView: View {
    @Binding var ytLink: String
    @ObservedObject var observableSlider: ObservableSlider = ObservableSlider()

    var body: some View {
      VideoPlayerContent(ytLink: $ytLink)
    }
 
}

