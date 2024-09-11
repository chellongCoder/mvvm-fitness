//
//  StoreManager.swift
//  NYCSchools
//
//  Created by Longnn on 9/9/24.
//

import Foundation

class ExerciseModel: Codable {
    var exerciseName: String
    var ytLink: String
    var createdAt: Date

    init(exerciseName: String, ytLink: String, createdAt: Date) {
        self.exerciseName = exerciseName
        self.ytLink = ytLink
        self.createdAt = createdAt
    }
}
class UserDefaultsManager {

    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private let key = "savedObjects"

    private init() {
        // Create mock data array
        let mockExerciseData: [ExerciseModel] = [
            ExerciseModel(exerciseName: "Push Up", ytLink: "https://youtube.com/pushup", createdAt: Date()),
            ExerciseModel(exerciseName: "Squat", ytLink: "https://youtube.com/squat", createdAt: Date()),
            ExerciseModel(exerciseName: "Plank", ytLink: "https://youtube.com/plank", createdAt: Date()),
            ExerciseModel(exerciseName: "Lunge", ytLink: "https://youtube.com/lunge", createdAt: Date()),
            ExerciseModel(exerciseName: "Burpee", ytLink: "https://youtube.com/burpee", createdAt: Date())
        ]
//      self.pushObjects(mockExerciseData)
    }

    // Method to push an object to the array
    func pushObject(_ object: ExerciseModel) {
        var objects = getObjects()
        objects.append(object)
        defaults.set(try? PropertyListEncoder().encode(objects), forKey: key)
    }

    func pushObjects(_ objects: [ExerciseModel]) {
      defaults.set(try? PropertyListEncoder().encode(objects), forKey: key)
    }

    // Method to remove an object by index
    func removeObject(at index: Int) {
        var objects = defaults.array(forKey: key) ?? []
        guard index < objects.count else { return }
        objects.remove(at: index)
        defaults.set(objects, forKey: key)
    }

    // Method to save the current object
    func saveCurrentObject(_ object: Any) {
        defaults.set(object, forKey: "currentObject")
    }

    // Method to retrieve the array of objects
    func getObjects() -> [ExerciseModel] {
      var userData: [ExerciseModel]!
      if let data = UserDefaults.standard.value(forKey: key) as? Data {
          userData = try! PropertyListDecoder().decode([ExerciseModel].self, from: data)
          return userData
      } else {
          return userData
      }
    }

    // Method to retrieve the current object
    func getCurrentObject() -> Any? {
        return defaults.object(forKey: "currentObject")
    }
}

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String : Any]
    }
}

extension Decodable {
    init?(dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        guard let object = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = object
    }
}

extension UserDefaults {
    func setEncodablesAsArrayOfDictionaries<T: Encodable>(_ encodables: Array<T>, for key: String) {
        let arrayOfDictionaries = encodables.map({ $0.asDictionary })
        self.set(arrayOfDictionaries, forKey: key)
    }

    func getDecodablesFromArrayOfDictionaries<T: Decodable>(for key: String) -> [T]? {
        guard let arrayOfDictionaries = self.array(forKey: key) as? [[String: Any]] else {
            return nil
        }
        return arrayOfDictionaries.compactMap({ T(dictionary: $0) })
    }
}
