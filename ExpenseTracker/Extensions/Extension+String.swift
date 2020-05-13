//
//  Extension+String.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 13/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import Foundation

extension String{
    
    func isOnlyWhiteSpaces()->Bool{
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
}
