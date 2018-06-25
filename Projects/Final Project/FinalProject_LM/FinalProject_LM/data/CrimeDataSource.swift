//
//  CrimeDataSource.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/10/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation

protocol CrimeDataSource {
    
    typealias callback = (_ crime: [Crime]?, _ error: Error?) -> Void
    
    func getAll(completion: @escaping callback)
    
    func get(id: String, completion: @escaping callback)
    
    func create(crime: Crime) -> Bool
    
    func update(crime: Crime) -> Bool
    
    func delete(crime: Crime) -> Bool
}
