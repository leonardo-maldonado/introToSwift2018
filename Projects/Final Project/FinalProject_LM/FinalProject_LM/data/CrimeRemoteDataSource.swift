//
//  CrimeRemoteDataSource.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/10/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation
import Alamofire

enum CrimeRouter: String {
    case crimes = "pzaz-tkx9.json?$where=point_x%20%21%3D%200"
    
    static let baseURL = "https://data.pr.gov/resource/"
    
    var url: String {
        return CrimeRouter.baseURL + self.rawValue
    }
}

class CrimeRemoteDataSource: CrimeDataSource {
    func getAll(completion: @escaping CrimeDataSource.callback) {
        getCrimes { (crimes, error) in
            guard let crimes = crimes else {
                completion(nil, error)
                return
            }
            completion(crimes, nil)
        }
    }
    
    func get(id: String, completion: @escaping CrimeDataSource.callback) {
        completion(nil, nil)
    }
    
    func create(crime: Crime) -> Bool {
        return true
    }
    
    func update(crime: Crime) -> Bool {
        return true
    }
    
    func delete(crime: Crime) -> Bool {
        return true
    }
    
    // MARK: Helper
    
    private func performRequest(url: String,
        completion: @escaping (DataResponse<Any>) -> Void) {

        Alamofire.request(url).responseJSON { (response: DataResponse) in
            completion(response)
        }
    }
 
    private func getCrimes(completion: @escaping CrimeDataSource.callback) {
        performRequest(url: CrimeRouter.crimes.url) { (response) in
            switch response.result {
            case .success:
                guard let data = response.data
                    else { return }
                
                guard let crimes = self.convertData(to:
                    Array<Crime>.self, data: data) else { return }
                
                completion(crimes, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

extension CrimeRemoteDataSource {
    fileprivate func convertData<T: Decodable>(
        to type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
