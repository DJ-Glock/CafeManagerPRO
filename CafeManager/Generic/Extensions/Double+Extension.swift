//
//  Double+Extension.swift
//  CafeManager
//
//  Created by Denis Kurashko on 23/07/2018.
//  Copyright © 2018 Denis Kurashko. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
