//
//  AuthenticationViewModelTests.swift
//  TwitterCloneTests
//
//  Created by Youssef Eldeeb on 19/11/2023.
//

import XCTest
@testable import TwitterClone


final class AuthenticationViewModelTests: XCTestCase {

    private var viewModel: AuthenticationViewModel!
    
    override func setUp() {
        viewModel = AuthenticationViewModel()
    }

    
    func test_isAuthEnable_whenEmailValidateRegExAndPassGreaterThan8_shouldEnable(){
        //Given
        viewModel.email = "Mohamed@gmail.com"
        viewModel.password = "aa1234567"
        viewModel.validateAuthentication()
        //When
        let isAuthEnablew = viewModel.isAuthenticationValid
        //Then
        XCTAssertTrue(isAuthEnablew)
    }
    
    func test_isAuthDisable_whenEmailNotValidateRegExAndPassLessThan8_shouldDisable(){
        //Given
        viewModel.email = "Mohamedgmailcom"
        viewModel.password = "aa123"
        viewModel.validateAuthentication()
        //When
        let isAuthEnablew = viewModel.isAuthenticationValid
        //Then
        XCTAssertFalse(isAuthEnablew)
    }

}
