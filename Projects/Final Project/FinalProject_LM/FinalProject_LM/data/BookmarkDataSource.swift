//
//  BookmarkDataSource.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/26/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation

class BookmarkDataSource: CrimeDataSource {
    
    let defaults = UserDefaults.standard
    let key = UserDefaultsType.bookmarks.rawValue
    
    var doesNotExistBookmarksDefaults: Bool {
        return defaults.value(forKey: key) == nil
    }
    
    init() {
        if doesNotExistBookmarksDefaults {
            setEmptyContainer(for: key)
        }
    }
    
    func getAll(completion: @escaping CrimeDataSource.callback) {
        
        guard let data = defaults.value(forKey: key)
            as? Data else { completion(nil, nil) ; return }
        
        guard let crimes = try? PropertyListDecoder().decode(
            Array<Crime>.self, from: data), !crimes.isEmpty
            else { completion(nil, nil) ; return }
        
        completion(crimes, nil)
    }
    
    func get(id: String, completion: @escaping CrimeDataSource.callback) {
        
        guard let data = defaults.value(forKey: key)
            as? Data else { completion(nil, nil) ; return }
        
        guard var crimes = try? PropertyListDecoder()
            .decode(Array<Crime>.self, from: data)
            else { completion(nil, nil) ; return }
        
        guard let index = crimes.index(
            where: { $0.identifier ==  id })
            else { completion(nil, nil) ; return }
        
        let crime = crimes[index]
        
        completion([crime], nil)
    }
    
    func create(crime: Crime) -> Bool {
        
        guard let data = defaults.value(forKey: key)
            as? Data else { return false }
        
        guard var crimes = try? PropertyListDecoder()
            .decode(Array<Crime>.self, from: data)
            else { return false }
        
        crimes.append(crime)
        
        defaults.set(try? PropertyListEncoder()
            .encode(crimes), forKey: key)
        
        return true
    }
    
    func updateAll(crimes: [Crime]) -> Bool {
        defaults.set(try? PropertyListEncoder()
            .encode(crimes), forKey: key)
        return true
    }
    
    func update(crime: Crime) -> Bool {
        
        guard let data = defaults.value(forKey: key)
            as? Data else { return false }
        
        guard var crimes = try? PropertyListDecoder()
            .decode(Array<Crime>.self, from: data)
            else { return false }
        
        if let index = crimes.index(where: { $0 == crime }) {
            crimes[index] = crime
        } else {
            crimes.append(crime)
        }
        
        guard let encodedCrimes = try? PropertyListEncoder()
            .encode(crimes) else { return false }
        
        defaults.set(encodedCrimes, forKey: key)
        
        return true
    }
    
    func delete(crime: Crime) -> Bool {
        
        guard let data = defaults.value(forKey: key)
            as? Data else { return false }
        
        guard var crimes = try? PropertyListDecoder().decode(
            Array<Crime>.self, from: data) else { return false }
        
        guard let index = crimes.index(where:
            { $0 == crime }) else { return false }
        
        crimes.remove(at: index)
        
        defaults.set(try? PropertyListEncoder()
            .encode(crimes), forKey: key)
        
        return true
    }
}

extension BookmarkDataSource {
    fileprivate func setEmptyContainer(for key: String) {
        defaults.set(try? PropertyListEncoder()
            .encode([Crime]()), forKey: key)
    }
}
