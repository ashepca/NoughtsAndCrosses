//
//  ViewController.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-02-23.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //outlets
    @IBOutlet weak var playerVsPlayerOutlet: UIButton!
    @IBOutlet weak var playerVsComputerOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVsPlayerOutlet.layer.cornerRadius = 15
        playerVsComputerOutlet.layer.cornerRadius = 15
        UserDefaults.standard.register(defaults: ["Volume" : true])
        UserDefaults.standard.register(defaults: ["Theme" : "Billiards"])
    }

    //segues
    @IBAction func playerVsPlayer(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPlayerNames", sender: self)
    }
    
    @IBAction func playerVsComputer(_ sender: UIButton) {
        performSegue(withIdentifier: "goToComputerNames", sender: self)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSettings", sender: self)
    }
}


