//
//  ChatRouter.swift
//  Flash Chat iOS13
//
//  Created by Gery J. Sumual on 31/07/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class ChatRouter {
    static func createModule() -> ChatViewController {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let chatView: ChatViewController = storyboard.instantiateViewController(identifier: "chat")
        return chatView
    }
}
