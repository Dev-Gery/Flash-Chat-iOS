//
//  RegisterRouter.swift
//  Flash Chat iOS13
//
//  Created by Gery J. Sumual on 31/07/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class RegisterRouter {
    static func createModule() -> RegisterViewController {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let registerView: RegisterViewController = storyboard.instantiateViewController(identifier: "register")
        return registerView
    }
}
