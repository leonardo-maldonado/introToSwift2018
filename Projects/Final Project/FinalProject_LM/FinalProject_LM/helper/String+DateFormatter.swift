//
//  String+DateFormatter.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/26/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation

extension String {
    var formatted: String? {

        /// Create date formatter
        let dateFormatter = DateFormatter()
        
        /// Set actual date format of the string
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        /// Create a date representation of the string
        guard let date = dateFormatter
            .date(from: self) else { return nil }
        
        /// Set desired date format
        dateFormatter.dateFormat = "MM/dd/yyyy"

        /// Apply date format
        let formattedDate = dateFormatter.string(from: date)

        return formattedDate
    }
}
