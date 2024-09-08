//
//  CustomButtonView.swift
//  NYCSchools
//
//  Created by Longnn on 9/9/24.
//

import Foundation
import SwiftUI

struct CustomButtonView: View {
    var onClick: () -> Void

    var body: some View {
      Button(action: {
            onClick()
        }) {
            HStack {
              Spacer()
              Text("Add Activity")
                  .font(.system(size: 16, weight: .medium))
                  .foregroundColor(.white)
              Spacer()

            if #available(iOS 16.0, *) {
              let uiImage = UIImage(named: "plus-icon")!.withRenderingMode(.alwaysTemplate).withTintColor(.white)
              Image(uiImage: uiImage) // Replace "X" with the actual name of your image asset
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)

            } else {
              // Fallback on earlier versions
            }
          }
          .padding(.vertical, 12)
          .padding(.horizontal, 16)
          .background(Color(red: 0.42, green: 0.31, blue: 1.0))
          .cornerRadius(48)
          .frame(maxWidth: .infinity, maxHeight: 50)
        }
    }
}
