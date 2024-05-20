//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    let db = Firestore.firestore()
//    var messages: [Message] = [
//        Message(sender: "1@2.com", body: "Hey!"),
//        Message(sender: "2@2.com", body: "Hello!"),
//        Message(sender: "1@2.com", body: "What's up?")
//    ]
    var messages: [Message] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField, descending: false)
            .addSnapshotListener(includeMetadataChanges: false, listener: { [self]
            (qs: QuerySnapshot?, err: (any Error)?) -> Void in
            messages = []
            if let e = err {
                print("Error getting documents: \(e)")
            } else {
                if let r = qs {
                    r.documents.forEach {
                        print("\($0.documentID) => \($0.data())")
                        if let s = $0.data()[K.FStore.senderField] as? String, let b = $0.data()[K.FStore.bodyField] as? String {
                            messages.append(Message(sender: s, body: b))
                        }
                    }
                    DispatchQueue.main.async { [self] in
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        })
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        Task { @MainActor in
            if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
                do {
                    let ref = try await db.collection(K.FStore.collectionName).addDocument(data: [
                        K.FStore.senderField : messageSender,
                        K.FStore.bodyField: messageBody,
                        K.FStore.dateField: Date().timeIntervalSince1970
                    ])
//                    print("Document added with ID: \(ref.documentID)")
                    messageTextfield.text = ""
                } catch {
                    print("Error adding document: \(error)")
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.alpha = 1
            cell.leftImageView.alpha = 0
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageLabel.textAlignment = .right
        } else {
            cell.leftImageView.alpha = 1
            cell.rightImageView.alpha = 0
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.purple)
            cell.messageLabel.textAlignment = .left
        }
        cell.messageLabel?.text = message.body
        return cell
        
    }
    
    
}
