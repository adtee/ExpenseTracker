//
//  DatabaseManager.swift
//  ExpenseTracker
//
//  Created by Aditi Pancholi on 13/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import Foundation
import UIKit
import SQLite3


enum DatabaseTable : String{
    case expense = "expense"
    case category = "category"
    
    func returncCreateTableQuery()->String{
        switch self{
        case .expense:
            return "timestamp TEXT PRIMARY KEY,title TEXT,amount REAL, date REAL, notes TEXT,category TEXT"
        case .category:
            return "id INTEGER PRIMARY KEY,title TEXT"
        }
    }
}

class DatabaseManager{
    
    static let shared : DatabaseManager = DatabaseManager()
    
    var categories : [CategoryModel] = []
    
    func connectDb()
    {
        db = openDatabase()
        createTable(tableName: DatabaseTable.expense.rawValue, collums: DatabaseTable.expense.returncCreateTableQuery())
        createTable(tableName: DatabaseTable.category.rawValue, collums: DatabaseTable.category.returncCreateTableQuery())
        addDefaultCategories()
    }
    
    let dbPath: String = "ExpenseTracker.sqlite"
    var db:OpaquePointer?
    
    
    //MARK: Open database
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print("Database path: \(fileURL)")
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    //MARK: Create table
    func createTable(tableName:String,collums:String) {
        let createTableString = "CREATE TABLE IF NOT EXISTS \(tableName)(\(collums));"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created successfully.")
            } else {
                print("table could not be created.")
            }
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK: Category
    
    /// add default categories
    func addDefaultCategories(){
        DatabaseManager.shared.categories = []
        let categoriesString = ["Fuel","Food","Grocery","Electronics","Shopping","Subscriptions"]
        for (index,category) in categoriesString.enumerated(){
            
            ///read categories and append to array if not addded before then add
            var isAlreadyAdded : Bool = false
            let queryStatementString = "SELECT id FROM \(DatabaseTable.category.rawValue) WHERE id = ?;"
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1, Int32(index))
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    isAlreadyAdded = true
                    categories.append(CategoryModel(categoryId: index, categoryName: category))
                    print("Already exists")
                    break
                }
            }
            
            sqlite3_finalize(queryStatement)
            if isAlreadyAdded{
                continue
            }
            
            let insertStatementString = "INSERT INTO \(DatabaseTable.category.rawValue) (id,title) VALUES (?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(index))
                sqlite3_bind_text(insertStatement, 2, (category as NSString).utf8String, -1, nil)
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    categories.append(CategoryModel(categoryId: index, categoryName: category))
                }
            }
            sqlite3_finalize(insertStatement)
        }
    }
    
    
    //MARK: Expense
    
    /// insert into expense table
    func insertExpense(timestamp:String, title:String, amount:Double,date:Double,notes:String,category:String)->Bool
    {
        //Guard adding exisitng value to the database
        let exisitngExpenses = fetchExpenseTableWithQuery(queryString: "SELECT * FROM \(DatabaseTable.expense.rawValue);")
        for expense in exisitngExpenses
        {
            if expense.timestamp == timestamp
            {
                return false
            }
        }
        let insertStatementString = "INSERT INTO \(DatabaseTable.expense.rawValue) (timestamp, title, amount,date,notes,category) VALUES (?, ?, ?,?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (timestamp as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 3, amount)
            sqlite3_bind_double(insertStatement, 4, date)
            sqlite3_bind_text(insertStatement, 5, (notes as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (category as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                sqlite3_finalize(insertStatement)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    /// fetch details from expense table
    func fetchExpenseTableWithQuery(queryString:String)->[ExpenseModel]{
        
        let queryStatementString = queryString
        var queryStatement: OpaquePointer? = nil
        var expenses : [ExpenseModel] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let exp = ExpenseModel.init(timestamp:  String(describing: String(cString: sqlite3_column_text(queryStatement, 0))), title: String(describing: String(cString: sqlite3_column_text(queryStatement, 1))), amount: sqlite3_column_double(queryStatement, 2), date: sqlite3_column_double(queryStatement, 3), notes: String(describing: String(cString: sqlite3_column_text(queryStatement, 4))), category: String(describing: String(cString: sqlite3_column_text(queryStatement, 5))))
                expenses.append(exp)
            }
        }
        sqlite3_finalize(queryStatement)
        return expenses
    }
    
}
