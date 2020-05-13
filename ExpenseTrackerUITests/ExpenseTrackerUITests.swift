
let app = XCUIApplication()
let scrollViewsQuery = app.scrollViews
let elementsQuery = scrollViewsQuery.otherElements

//
//  ExpenseTrackerUITests.swift
//  ExpenseTrackerUITests
//
//  Created by Aditi Pancholi on 12/05/20.
//  Copyright © 2020 Aditi Mehta. All rights reserved.
//

import XCTest

class ExpenseTrackerUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIfAllElementsAreOnScreen() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        
        
        //MARK: check if every control is visible on screen
        XCTAssert(elementsQuery.staticTexts["Title"].exists)
        XCTAssert(elementsQuery.staticTexts["Amount"].exists)
        XCTAssert(elementsQuery.staticTexts["Date"].exists)
        XCTAssert(elementsQuery.staticTexts["Notes"].exists)
        XCTAssert(elementsQuery.staticTexts["Category"].exists)
        
        //MARK: check if collection view has all the categories
        XCTAssertEqual(elementsQuery.collectionViews.cells.count, 6)
        
        XCTAssert(elementsQuery.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Grocery"]/*[[".cells.staticTexts[\"Grocery\"]",".staticTexts[\"Grocery\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Add Expense"]/*[[".buttons[\"Add Expense\"].staticTexts[\"Add Expense\"]",".staticTexts[\"Add Expense\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Expense Report"]/*[[".buttons[\"Expense Report\"].staticTexts[\"Expense Report\"]",".staticTexts[\"Expense Report\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        
        app.scrollViews.otherElements.buttons["Expense Report"].tap()
        
        let betweenDatesStaticText = app.staticTexts["between Dates :"]
        XCTAssert(betweenDatesStaticText.exists)
        
        XCTAssert(app/*@START_MENU_TOKEN@*/.buttons["Week"]/*[[".segmentedControls.buttons[\"Week\"]",".buttons[\"Week\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(app.buttons["Month"].exists)
        app/*@START_MENU_TOKEN@*/.buttons["Day"]/*[[".segmentedControls.buttons[\"Day\"]",".buttons[\"Day\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssert(app.textFields["Select category"].exists)
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Filter by dates"]/*[[".buttons[\"Filter by dates\"].staticTexts[\"Filter by dates\"]",".staticTexts[\"Filter by dates\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let okayButton = app.alerts["Expense Tracker"].scrollViews.otherElements.buttons["Okay"]
        okayButton.tap()
        
        XCTAssert(app/*@START_MENU_TOKEN@*/.staticTexts["Filter by time"]/*[[".buttons[\"Filter by time\"].staticTexts[\"Filter by time\"]",".staticTexts[\"Filter by time\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        
        XCTAssert(app/*@START_MENU_TOKEN@*/.staticTexts["filter by category"]/*[[".buttons[\"filter by category\"].staticTexts[\"filter by category\"]",".staticTexts[\"filter by category\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
