//
//  EmailInputView.swift
//  NYCSchools
//
//  Created by Longnn on 8/9/24.
//

import Foundation

import SwiftUI

struct EmailInputView: View {
  @Binding var email: String

  public func getEmail() -> String {
    return email
  }
    var body: some View {
       
        VStack(alignment: .leading, spacing: 4) {
            Text("Exercise name")
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.48))

            TextField("", text: $email)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.04, green: 0.04, blue: 0.04))
                .onReceive(email.publisher) {
                    print("email $0, \(email) \($0)")
                }
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
