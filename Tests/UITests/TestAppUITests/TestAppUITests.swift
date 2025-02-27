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
        
        let choirQuestionButton = app.staticTexts[
            "Myself. I am 18 years of age or older, and I am interested in learning more about a clinical trial opportunity"
        ]
        XCTAssertTrue(choirQuestionButton.waitForExistence(timeout: 1))
        choirQuestionButton.tap()
        
        XCTAssertTrue(continueButton.exists)
        continueButton.tap()
        
        sleep(1)
        
        let firstNameTextField = app.textFields["10:0:first_name"]
        firstNameTextField.tap()
        firstNameTextField.typeText("Leland")
        
        let lastNameTextField = app.textFields["10:1:last_name"]
        lastNameTextField.tap()
        lastNameTextField.typeText("Stanford")
        
        let emailTextField = app.textFields["10:2:email"]
        emailTextField.tap()
        emailTextField.typeText("leland@stanford.edu")
        
        app.swipeUp()
        
        let phoneTextField = app.textFields["10:3:mobile_phone"]
        phoneTextField.tap()
        phoneTextField.typeText("6501111111")
        
        let choirQuestionButton2 = app.staticTexts[
            "Yes, I agree to receive research-related contact."
        ]
        XCTAssertTrue(choirQuestionButton2.waitForExistence(timeout: 1))
        choirQuestionButton2.tap()
        
        XCTAssertTrue(continueButton.exists)
        continueButton.tap()
        
        let finishButton = app.buttons["Finish"]
        XCTAssertTrue(finishButton.waitForExistence(timeout: 1))
        finishButton.tap()
        
        XCTAssertTrue(app.staticTexts["Home"].exists)
    }
}
