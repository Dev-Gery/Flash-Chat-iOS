//
//  Router.swift
//  Flash Chat iOS13
//
//  Created by Gery J. Sumual on 31/07/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class LoginRouter {
    static func createModule() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginView: LoginViewController = storyboard.instantiateViewController(identifier: "login")
        return loginView
    }
}
