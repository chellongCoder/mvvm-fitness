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
}
