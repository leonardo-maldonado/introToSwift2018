//
//  ColorManager.swift
//  Homework5_LM
//
//  Created by Leonardo Maldonado on 4/15/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import Foundation
import UIKit

struct ColorManager {
    static let maxRGBValue: UInt32 = 255
    static var maxRGBFloatValue: CGFloat {
        get { return CGFloat.init(maxRGBValue) }
    }
    static var randomRGBValue: CGFloat {
        let randomValue = 1 + arc4random_uniform(maxRGBValue)
        return CGFloat.init(randomValue)
    }
    
    /// Generates an array of ColorViewModel's.
    ///
    /// - Parameters:
    ///   - numberOfColors: The desired number of colors.
    ///   - colorType: The color type of the model.
    /// - Returns: An array of ColorViewModel type.
    static func generateColors(desired numberOfColors: Int, with colorType:
        ColorType) -> [ColorViewModel] {
        
        /// Generate random color values
        var randomRGBValues = [CGFloat]()
        for _ in 0...numberOfColors {
            randomRGBValues.append(self.randomRGBValue)
        }
        
        /// For every random value create a ColorViewModel
        var colors = [ColorViewModel]()
        for randomvalue in randomRGBValues {
            let colorName: String
            let color: UIColor
            let colorValue: CGFloat = randomvalue / maxRGBFloatValue
            let stringFormat = "R: %.0f, G: %.0f, B: %.0f, A: %.0f"
     
            /// Depending on the colorType change the values in
            /// UIColor and String init.
            switch colorType {
            case .red:
                color = UIColor(red: colorValue, green: 0, blue: 0, alpha: 1)
                colorName = String(format: stringFormat, arguments:
                    [randomvalue, 0.0, 0.0, 1.0])
                break
            case .blue:
                color = UIColor(red: 0, green: 0, blue: colorValue, alpha: 1)
                colorName = String(format: stringFormat, arguments:
                    [0.0, 0.0, randomvalue, 1.0])
                break
            case .random:
                let randomRedValue = self.randomRGBValue
                let randomGreenValue = self.randomRGBValue
                let randomBlueValue = self.randomRGBValue 
                color = UIColor(red: randomRedValue / maxRGBFloatValue, green:
                    randomGreenValue / maxRGBFloatValue, blue:
                    randomBlueValue / maxRGBFloatValue, alpha: 1)
                colorName = String(format: stringFormat, arguments:
                    [randomRedValue, randomGreenValue, randomBlueValue, 1.0])
                break
            }
            
            /// Create the model and append to the colors array
            let colorViewModel = ColorViewModel(
                name: colorName, color: color, isSelected: false)
            colors.append(colorViewModel)
        }
        return colors
    }
}
