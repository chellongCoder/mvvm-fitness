//
//  NavigationBarView.swift
//  NYCSchools
//
//  Created by Longnn on 8/9/24.
//

import Foundation
import SwiftUI

struct NavigationBarView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Button(action: {
                // Handle back action
                self.presentationMode.wrappedValue.dismiss()
            }) {
              Image("x-icon") // Replace "X" with the actual name of your image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }

            Spacer()

            Text("Add Activity")
                .font(Font.custom("HelveticaNeue-Bold", size: 18))
                .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04))

            Spacer()

            Text("")
              .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}
