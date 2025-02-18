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
        
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists)
        continueButton.tap()
        
        let finishButton = app.buttons["Finish"]
        XCTAssertTrue(finishButton.exists)
        finishButton.tap()
    }
}
