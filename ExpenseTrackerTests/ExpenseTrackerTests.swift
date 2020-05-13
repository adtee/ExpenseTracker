//
//  ExpenseTrackerTests.swift
//  ExpenseTrackerTests
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import XCTest
@testable import ExpenseTracker

class ExpenseTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    ///Database Category test
    func testCategories() throws {
        DatabaseManager.shared.connectDb()
        XCTAssertEqual(DatabaseManager.shared.categories.count, 6, "all categories must be added in tabel")
    }
    
    ///Test expenseModel values assigns properly or not
    func testInsertion() throws{
        let expensedata = ExpenseModel(timestamp: "45656565", title: "Expense 1", amount: 500.0, date: 565656565, notes: nil, category: "1")
        XCTAssertEqual(expensedata.amount, 500.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
