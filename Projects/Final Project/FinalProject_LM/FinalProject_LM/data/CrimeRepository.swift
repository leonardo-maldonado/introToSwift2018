//
//  CrimeRepository.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/10/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation

class CrimeRepository: CrimeDataSource {

    static let shared = CrimeRepository()
    
    private var crimesRemoteDataSource = CrimeRemoteDataSource()

    private var crimesLocalDataSource = CrimeLocalDataSource()
    
    private init() { /** Prevent direct instantiation. */ }
    
    var cachedCrimes: [Crime]?
    
    /// Marks the cache as invalid, to force
    /// an update the next time data is requested.
    var cacheIsDirty = false;
    
    func getAllRemote(completion: @escaping CrimeDataSource.callback) {
        getCrimesFromRemoteDataSource { (crimes, error) in
            completion(crimes, nil)
        }
    }
    
    func getAll(completion: @escaping CrimeDataSource.callback) {
        
        /// Respond immediately with cache if available and not dirty
        if let cachedCrimes = cachedCrimes, !cacheIsDirty {
            return completion(cachedCrimes, nil)
        }
        
        if cacheIsDirty {
            
            /// If the cache is dirty fetch new data from the network.
            getCrimesFromRemoteDataSource { (crimes, error) in
                completion(crimes, error)
            }
            
        } else {
            
            /// Query the local storage if available. If not, query the network.
            getCrimesFromLocalDataSource { (crimes, error) in
                
                guard let crimes = crimes else {
                    
                    /// Fetch new data from the network.
                    self.getCrimesFromRemoteDataSource { (crimes, error) in
                        completion(crimes, error)
                    }
                    
                    return
                }
                
                completion(crimes, nil)
            }
        }
    }
    
    func get(id: String, completion: @escaping CrimeDataSource.callback) {
        completion(nil, nil)
    }
    
    func create(crime: Crime) -> Bool {
        cachedCrimes?.append(crime)
        let crimeCreated = crimesLocalDataSource.create(crime: crime)
        return crimeCreated
    }
    
    func create(crimes: [Crime]) -> Bool {
        cachedCrimes? = crimes
        let crimeCreated = crimesLocalDataSource.create(crimes: crimes)
        return crimeCreated
    }
    
    func update(crime: Crime) -> Bool {
        if let index = cachedCrimes?.index(where: { $0 == crime }) {
            cachedCrimes?[index] = crime
        }
        return crimesLocalDataSource.update(crime: crime)
    }
    
    func updateAll(crimes: [Crime]) -> Bool {
        if cachedCrimes != nil {
            cachedCrimes = crimes
        }
        return crimesLocalDataSource.updateAll(crimes: crimes)
    }
    
    func deleteAll() -> Bool {
        cachedCrimes = nil
        return crimesLocalDataSource.deleteAll()
    }
    
    func delete(crime: Crime) -> Bool {
        if let index = cachedCrimes?.index(where: { $0 == crime }) {
            cachedCrimes?.remove(at: index)
        }
        return crimesLocalDataSource.delete(crime:crime)
    }
    
    // MARK: Helpers
    
    fileprivate func refreshCache(crimes: [Crime]) {
        
        cachedCrimes?.removeAll()
        
        if cachedCrimes == nil {
            cachedCrimes = []
        }
        
        for crime in crimes {
            cachedCrimes?.append(crime)
        }
        
        cacheIsDirty = false;
    }
    
    fileprivate func refreshLocaDataSource(crimes: [Crime]) {
        _ = crimesLocalDataSource.create(crimes: crimes)
    }
    
    fileprivate func getCrimesFromRemoteDataSource(
        completion: @escaping CrimeDataSource.callback) {
        
        crimesRemoteDataSource.getAll(completion: { (crimes, error) in
            guard let crimes = crimes else {
                completion(nil, nil)
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                self.refreshCache(crimes: crimes)
                self.refreshLocaDataSource(crimes: crimes)
            }
            
            completion(crimes, nil)
        })
    }
    
    fileprivate func getCrimesFromLocalDataSource(
        completion: @escaping CrimeDataSource.callback) {
        
        crimesLocalDataSource.getAll(completion: { (crimes, error) in
            guard let crimes = crimes else {
                completion(nil, nil)
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                self.refreshCache(crimes: crimes)
            }
            
            completion(crimes, nil)
        })
    }
}
