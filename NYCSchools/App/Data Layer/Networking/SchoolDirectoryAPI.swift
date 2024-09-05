//
//  SchoolDirectoryAPI.swift
//  NYCSchools
//
//  Created by Rolan on 8/8/22.
//

import Foundation
import Alamofire

typealias SchoolListAPIResponse = (Swift.Result<[School]?, DataError>) -> Void
typealias SchoolsSATAPIResponse = (Swift.Result<[SchoolSAT], DataError>) -> Void

/// API interface to retrieve schools
protocol SchoolAPILogic {
    func getSchools(completion: @escaping (SchoolListAPIResponse))
    func getSchoolSATResults(completion: @escaping(SchoolsSATAPIResponse))
}

class SchoolAPI: SchoolAPILogic {
    /// NYC School API URL returning list of schools with details
    private struct Constants {
        static let schoolListURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$$app_token=L1KwLSwm1yz1N7aWqFCF4dLmM"
        static let schoolsSATURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?$$app_token=L1KwLSwm1yz1N7aWqFCF4dLmM"
    }
    
    func getSchools(completion: @escaping (SchoolListAPIResponse)) {
        // this prevents AF retrieving cached responses
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.schoolListURL)
            .validate()
            .responseDecodable(of: [School].self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schools):
                    completion(.success(schools))
                }
            }
    }
    
    func getSchoolSATResults(completion: @escaping(SchoolsSATAPIResponse)) {
        // this prevents AF retrieving cached responses
        URLCache.shared.removeAllCachedResponses()
        
        AF.request(Constants.schoolsSATURL)
            .validate()
            .responseDecodable(of: [SchoolSAT].self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(.networkingError(error.localizedDescription)))
                case .success(let schoolSATs):
                    completion(.success(schoolSATs))
                }
            }
    }
    
    private func retrieveSchoolsUsingStandardServices() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "data.cityofnewyork.us"
        urlComponents.path = "/resource/s3k6-pzi2.json"
        urlComponents.queryItems = [URLQueryItem(name: "$$app_token",
                                                 value: "L1KwLSwm1yz1N7aWqFCF4dLmM")]
        
        // another way to get URL
        // URL(string: schoolListURL)
        
        if let url = urlComponents.url {
            let urlSession = URLSession(configuration: .default)
            
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    print("error occured \(error?.localizedDescription)")
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let schools = try decoder.decode([School].self,
                                                         from: data)
                        print("schools")
                    } catch let error {
                        print("eror during parsing \(error)")
                    }
                    
                }
            }
            task.resume()
        }
    }
}
