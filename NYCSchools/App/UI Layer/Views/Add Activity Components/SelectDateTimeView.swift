//
//  SelectDateTimeView.swift
//  NYCSchools
//
//  Created by Longnn on 11/9/24.
//

import Foundation
import SwiftUI

struct SelectDateTimeView: View {
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            Text("Select Date and Time")
                .font(.headline)
                .padding()

          if #available(iOS 14.0, *) {
            DatePicker(
              "Date and Time",
              selection: $selectedDate,
              displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
          } else {
            // Fallback on earlier versions
          }

            Text("Selected: \(formattedDate(selectedDate))")
                .padding()
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
