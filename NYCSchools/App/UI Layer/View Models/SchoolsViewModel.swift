//
//  File.swift
//  NYCSchools
//
//  Created by Rolan on 8/9/22.
//

import Foundation
import Combine

class SchoolsViewModel {
    @Published private(set) var schools: [School]?
    @Published var schoolSATs: [SchoolSAT]?
    @Published private(set) var error: DataError? = nil
    
    private(set) var schoolSectionsList: [SchoolSection]?
    private(set) var schoolSATDictionary: [String: SchoolSAT] = [:]
    
    private let apiService: SchoolAPILogic
    
    init(apiService: SchoolAPILogic = SchoolAPI()) {
        self.apiService = apiService
    }
    
    func getSchools() {
        apiService.getSchools { [weak self] result in
            switch result {
            case .success(let schools):
                self?.schools = schools ?? []
                if schools?.isEmpty == false {
                    self?.prepareSchoolSections()
                }
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    func getSchoolSATs() {
        schoolSATs?.removeAll()
        apiService.getSchoolSATResults { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let schoolSATResults):
                self.schoolSATs = schoolSATResults
                
                for sat in schoolSATResults {
                    self.schoolSATDictionary[sat.dbn] = sat
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    private func prepareSchoolSections() {
        var listOfSections = [SchoolSection]()
        var schoolDictionary = [String: SchoolSection]()
        
        guard let schools = schools else {
            return
        }
        
        for school in schools {
            if let city = school.city {
                if schoolDictionary[city] != nil {
                    schoolDictionary[city]?.schools.append(school)
                } else {
                    var newSection = SchoolSection(city: city,
                                                   schools: [])
                    newSection.schools.append(school)
                    schoolDictionary[city] = newSection
                }
            }
        }
        
        listOfSections = Array(schoolDictionary.values)
        listOfSections.sort {
            return $0.city < $1.city
        }
        schoolSectionsList = listOfSections
    }
}
