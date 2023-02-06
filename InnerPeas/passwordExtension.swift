//
//  passwordExtension.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/6/23.
//

import Foundation

extension String {
    func passwordValidator() -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
}
