//
//  StoreManager.swift
//  NYCSchools
//
//  Created by Longnn on 9/9/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private let key = "savedObjects"

    private init() {}

    // Method to push an object to the array
    func pushObject(_ object: Any) {
        var objects = defaults.array(forKey: key) ?? []
        objects.append(object)
        defaults.set(objects, forKey: key)
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
    func getObjects() -> [Any] {
        return defaults.array(forKey: key) ?? []
    }

    // Method to retrieve the current object
    func getCurrentObject() -> Any? {
        return defaults.object(forKey: "currentObject")
    }
}
