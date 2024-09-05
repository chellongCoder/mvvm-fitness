//
//  SchoolDetailsViewModel.swift
//  NYCSchools
//
//  Created by Rolan on 8/12/22.
//

import Foundation

class SchoolDetailsViewModel {
    private(set) var school: School
    private(set) var schoolSAT: SchoolSAT
    
    init(school: School,
         schoolSAT: SchoolSAT) {
        self.school = school
        self.schoolSAT = schoolSAT
    }
}
