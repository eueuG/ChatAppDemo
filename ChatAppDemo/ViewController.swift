//
//  ViewController.swift
//  ChatAppDemo
//
//  Created by 野田凜太郎 on 2021/05/29.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var messageInputField: UITextField!
    
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    var databaseRef: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        databaseRef = Database.database().reference()
        
        databaseRef.observe(.childAdded, with: { snapshot in
            print(snapshot)
            if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"] {
                let currentText = self.textView.text
                self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
                print(snapshot)
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification){
        if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            inputViewBottomMargin.constant = keyboardFrameInfo.cgRectValue.height
        }

    }

    @objc func keyboardWillHide(_ notification: NSNotification){
        inputViewBottomMargin.constant = 0
    }

    
    
    
    @IBAction func tappedSendButton(_ sender: Any) {
        view.endEditing(true)
        
        if let name = nameInputField.text, let message = messageInputField.text {
            let messageData = ["name": name, "message": message]
            databaseRef.childByAutoId().setValue(messageData)
            
            messageInputField.text = ""
        }
    }
    
}


