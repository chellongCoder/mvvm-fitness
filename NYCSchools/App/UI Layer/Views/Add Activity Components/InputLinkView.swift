//
//  InputLinkView.swift
//  NYCSchools
//
//  Created by Longnn on 8/9/24.
//

import Foundation

import SwiftUI

struct InputLinkView: View {
  @State private var link: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Youtube link")
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.48))

          TextField("", text: $link)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04))
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 9)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 0.89, green: 0.90, blue: 0.90), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibility(label: Text("Email input"))
    }
}
