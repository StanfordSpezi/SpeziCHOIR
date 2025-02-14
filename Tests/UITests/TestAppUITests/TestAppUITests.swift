//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import OSLog
import XCTest


class TestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    

    @MainActor
    func testCHOIRQuestions() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssert(app.staticTexts["Welcome to Stanford Heartbeat Study!"].waitForExistence(timeout: 1))
        
        let continueButton = app.buttons["Continue"]
        XCTAssert(continueButton.exists)
        continueButton.tap()
        
        XCTAssert(app.staticTexts["Thank you!"].waitForExistence(timeout: 1))
        
        let finishButton = app.buttons["Finish"]
        XCTAssert(finishButton.exists)
        finishButton.tap()
    }
}
