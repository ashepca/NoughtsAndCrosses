//
//  ComputerNameViewController.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-03-01.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit

class ComputerNameViewController: UIViewController, UITextFieldDelegate {

    //outlets
    @IBOutlet weak var compOName: UITextField!
    @IBOutlet weak var compXName: UITextField!
    @IBOutlet weak var computerNameOMarker: UIImageView!
    @IBOutlet weak var computerNameXMarker: UIImageView!
    @IBOutlet weak var computerNameBackground: UIImageView!
    
    //constants and variables
    let computerNameTheme = UserDefaults.standard.string(forKey: "Theme")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        compOName.delegate = self
        compXName.delegate = self
        
        //set images based on selected theme
        if computerNameTheme == "Billiards" || computerNameTheme == nil {
            computerNameOMarker.image = UIImage(named: "billiardsMarkerO")
            computerNameXMarker.image = UIImage(named: "billiardsMarkerX")
            computerNameBackground.image = UIImage(named: "billiardsFieldBackground")
        } else if computerNameTheme == "Golf" {
            computerNameOMarker.image = UIImage(named: "golfMarkerO")
            computerNameXMarker.image = UIImage(named: "golfMarkerX")
            computerNameBackground.image = UIImage(named: "golfFieldBackground")
        } else if computerNameTheme == "Tennis" {
            computerNameOMarker.image = UIImage(named: "tennisMarkerO")
            computerNameXMarker.image = UIImage(named: "tennisMarkerX")
            computerNameBackground.image = UIImage(named: "tennisGreenBackground")
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
    
    //clear keyboard when return is selected on keyboard    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //auto assigns computer name to field not selected by player
    @IBAction func compOChoosen(_ sender: UITextField) {
        compXName.text = "Computer"
        compXName.isUserInteractionEnabled = false
    }
    
    @IBAction func compXChoosen(_ sender: UITextField) {
        compOName.text = "Computer"
        compOName.isUserInteractionEnabled = false
    }
    
    //launches game / play field with default names if none selected
    @IBAction func compNameGo(_ sender: UIButton) {
        
        var newCompPlayerOName = compOName.text!
        var newCompPlayerXName = compXName.text!
        
        if newCompPlayerOName == "" && newCompPlayerOName == "" {
            newCompPlayerOName = "Player O"
            newCompPlayerXName = "Computer"
        } else if newCompPlayerOName == "" {
            newCompPlayerOName = "Player O"
        } else if newCompPlayerXName == "" {
            newCompPlayerXName = "Player X"
        }
        
        UserDefaults.standard.set(newCompPlayerOName, forKey: "OCompPlayerName")
        UserDefaults.standard.set(newCompPlayerXName, forKey: "XCompPlayerName")
        
        performSegue(withIdentifier: "goToComputerField", sender: self)
        
    }
    
    //dismiss screen
    @IBAction func computerNameHomeButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
}
