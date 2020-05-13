//
//  Extension+Date.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 13/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
    
    
    var timeStamp:Int64 {
        return Int64((self.timeIntervalSince1970))
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds))
    }
    
    func formateDateIn(formate:String = "dd/MM/yyyy")->String{
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        return formatter.string(from: self)
    }
    
    
    func getNewDateAfterAdding(daysToAdd:Int=0,monthsToadd:Int=0,yearsToAdd:Int=0)->Date{
        let monthsToAdd = monthsToadd
        let daysToAdd = daysToAdd
        let yearsToAdd = yearsToAdd
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        
        dateComponent.month = monthsToAdd
        dateComponent.day = daysToAdd
        dateComponent.year = yearsToAdd
        
        return Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
    }
}



extension String{
    func getTimeStempFromString()->Double{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat="dd/MM/yyyy"
        
        let dateString = dateFormatter.date(from: self)
        
        return dateString!.timeIntervalSince1970
    }
}
