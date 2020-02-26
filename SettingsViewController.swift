//
//  SettingsViewController.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-03-02.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //outlets
    @IBOutlet weak var volumeOutlet: UISwitch!
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var themeLabelOutlet: UILabel!
    @IBOutlet weak var soundLabelOutlet: UILabel!
    @IBOutlet weak var contactButtonOutlet: UIButton!
    
    //constants and variables
    let themeArray = ["Billiards", "Golf", "Tennis"]
    var themeSelected = UserDefaults.standard.string(forKey: "Theme") ?? ""
    var soundSelected = UserDefaults.standard.bool(forKey: "Volume")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        themePicker.delegate = self
        themePicker.dataSource = self
        
        //sets sound and theme settings to stored value in user defaults
        if soundSelected == false {
            volumeOutlet.setOn(false, animated: false)
        }
        if let row = themeArray.index(of: themeSelected) {
            themePicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    //pickerview functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themeArray.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = themeArray[row]
        pickerLabel.textAlignment = NSTextAlignment.right
        pickerLabel.textColor = UIColor.white
        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerLabel.font = UIFont.systemFont(ofSize: 37)
        } else {
            pickerLabel.font = UIFont.systemFont(ofSize: 24)
        }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        var rowHeight : CGFloat = 21
        if UIDevice.current.userInterfaceIdiom == .pad {
            rowHeight = 34
        }
        return rowHeight
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(themeArray[row], forKey: "Theme")
    }
    
    //settings functions
    @IBAction func soundOnOffSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Volume")
    }

    @IBAction func contactBlueOakPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.blueoakapps.com")! as URL, options: [:], completionHandler: nil)
    }
   
    //dismiss screen
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
}
