//
//  PlayersNameViewController.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-02-28.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit

class PlayersNameViewController: UIViewController, UITextFieldDelegate {

    //outlets
    @IBOutlet weak var playerOName: UITextField!
    @IBOutlet weak var playerXName: UITextField!
    @IBOutlet weak var playersNameOMarker: UIImageView!
    @IBOutlet weak var playersNameXMarker: UIImageView!
    @IBOutlet weak var playersNameBackground: UIImageView!
    
    //constants and variables
    let playersNameTheme = UserDefaults.standard.string(forKey: "Theme")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        playerOName.delegate = self
        playerXName.delegate = self
        
        //set images based on selected theme
        if playersNameTheme == "Billiards" || playersNameTheme == nil {
            playersNameOMarker.image = UIImage(named: "billiardsMarkerO")
            playersNameXMarker.image = UIImage(named: "billiardsMarkerX")
            playersNameBackground.image = UIImage(named: "billiardsFieldBackground")
        } else if playersNameTheme == "Golf" {
            playersNameOMarker.image = UIImage(named: "golfMarkerO")
            playersNameXMarker.image = UIImage(named: "golfMarkerX")
            playersNameBackground.image = UIImage(named: "golfFieldBackground")
        } else if playersNameTheme == "Tennis" {
            playersNameOMarker.image = UIImage(named: "tennisMarkerO")
            playersNameXMarker.image = UIImage(named: "tennisMarkerX")
            playersNameBackground.image = UIImage(named: "tennisGreenBackground")
        }
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //stop listening for keyboard events
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //move screen when keyboard appears or disappears
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardSize.height / 2
        } else {
            view.frame.origin.y = 0
        }
    }
    
    //clear keyboard when screen is touched outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //clear keyboard or change textfield focus when return is selected on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == playerOName {
            playerXName.becomeFirstResponder()
        } else if textField == playerXName {
            playerXName.resignFirstResponder()
        }
        return true
    }
    
    //launches game / play field with default names if none selected
    @IBAction func playerNameGo(_ sender: UIButton) {
        
        var newPlayerOName = playerOName.text!
        if newPlayerOName == "" {
            newPlayerOName = "Player O"
        }

        var newPlayerXName = playerXName.text!
        if newPlayerXName == "" {
            newPlayerXName = "Player X"
        }

        UserDefaults.standard.set(newPlayerOName, forKey: "OPlayerName")
        UserDefaults.standard.set(newPlayerXName, forKey: "XPlayerName")

        performSegue(withIdentifier: "goToPlayField", sender: self)
    }
    
    //dismiss screen
    @IBAction func playersNameHomeButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
