//
//  StringsHelper.swift
//  NYCSchools
//
//  Created by Rolan on 8/10/22.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 comment: "")
    }
    
    func localized(params: CVarArg...) -> String {
        return String(format: localized(),
                      arguments: params)
    }

    func isValidYouTubeLink() -> Bool {
         let pattern = #"https:\/\/youtu\.be\/[A-Za-z0-9_-]{11}"#
         let regex = try? NSRegularExpression(pattern: pattern, options: [])
         let range = NSRange(location: 0, length: self.utf16.count)
         if let match = regex?.firstMatch(in: self, options: [], range: range) {
             return match.range.location != NSNotFound
         }
         return false
     }
}
