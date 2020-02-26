//
//  PlayFieldViewController.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-02-23.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import StoreKit

class PlayFieldViewController: UIViewController, GADInterstitialDelegate {

    //outlets
    @IBOutlet weak var winningLabel: UILabel!
    @IBOutlet weak var whoseTurnLabel: UILabel!
    @IBOutlet weak var upperLeftBoxOutlet: UIButton!
    @IBOutlet weak var upperMiddleBoxOutlet: UIButton!
    @IBOutlet weak var upperRightBoxOutlet: UIButton!
    @IBOutlet weak var middleLeftBoxOutlet: UIButton!
    @IBOutlet weak var middleMiddleBoxOutlet: UIButton!
    @IBOutlet weak var middleRightBoxOutlet: UIButton!
    @IBOutlet weak var lowerLeftBoxOutlet: UIButton!
    @IBOutlet weak var lowerMiddleBoxOutlet: UIButton!
    @IBOutlet weak var lowerRightBoxOutlet: UIButton!
    @IBOutlet weak var playFieldBackground: UIImageView!
    @IBOutlet weak var playFieldLines: UIImageView!
    
    //constants and variables
    let playerO = UserDefaults.standard.string(forKey: "OPlayerName")
    let playerX = UserDefaults.standard.string(forKey: "XPlayerName")
    let playerTheme = UserDefaults.standard.string(forKey: "Theme")
    var playerMarkerO : String = ""
    var playerMarkerX : String = ""
    let soundArray = ["win", "lose", "tie", "billiardsPing", "golfPing", "tennisPing"]
    var playerPingSound : String = ""
    var audioPlayer : AVAudioPlayer!
    var buttonPressCount = 0
    var playerOsTurn = true
    var uLWasPressed = false
    var uMWasPressed = false
    var uRWasPressed = false
    var mLWasPressed = false
    var mMWasPressed = false
    var mRWasPressed = false
    var lLWasPressed = false
    var lMWasPressed = false
    var lRWasPressed = false
    var interstitial: GADInterstitial!
    var gameCountForAdRate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //sets initial first turn randomly
        let randomTurn = Int(arc4random_uniform(2)) + 1
        if randomTurn == 1 {
            whoseTurnLabel.text = "\(playerO!)'s Turn"
            playerOsTurn = true
        } else {
            whoseTurnLabel.text = "\(playerX!)'s Turn"
            playerOsTurn = false
        }
        
        //assigns images and sounds to match selected theme
        if playerTheme == "Billiards" || playerTheme == nil {
            playerMarkerO = "billiardsMarkerO"
            playerMarkerX = "billiardsMarkerX"
            playerPingSound = soundArray[3]
            playFieldBackground.image = UIImage(named: "billiardsBackground")
            playFieldLines.image = UIImage(named: "billiardsLines")
        } else if playerTheme == "Golf" {
            playerMarkerO = "golfMarkerO"
            playerMarkerX = "golfMarkerX"
            playerPingSound = soundArray[4]
            playFieldBackground.image = UIImage(named: "golfBackground")
            playFieldLines.image = UIImage(named: "golfLines")
        } else if playerTheme == "Tennis" {
            playerMarkerO = "tennisMarkerO"
            playerMarkerX = "tennisMarkerX"
            playerPingSound = soundArray[5]
            playFieldBackground.image = UIImage(named: "tennisBackground")
            playFieldLines.image = UIImage(named: "tennisLines")
        }
        
        // loads initial ad
        interstitial = createAndLoadInterstitial()
    }
    
    // google admob ad function
    func createAndLoadInterstitial() -> GADInterstitial {
        //sample app unit id ca-app-pub-3940256099942544/4411468910
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3529250513838673/3580996178")
        interstitial.delegate = self
        let request = GADRequest()
        //remove this one test device line before launch
        request.testDevices = [ "kGADSimulatorID" ]
        interstitial.load(request)
        return interstitial
    }
    
    // loads new ad after initial ad used
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }

    //9 play square functions to call button pressed function, then count as being pressed
    @IBAction func upperLeftBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: upperLeftBoxOutlet, buttonWasAlreadyPressed: uLWasPressed)
        uLWasPressed = true
    }
    @IBAction func upperMiddleBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: upperMiddleBoxOutlet, buttonWasAlreadyPressed: uMWasPressed)
        uMWasPressed = true
    }
    @IBAction func upperRightBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: upperRightBoxOutlet, buttonWasAlreadyPressed: uRWasPressed)
        uRWasPressed = true
    }
    @IBAction func middleLeftBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: middleLeftBoxOutlet, buttonWasAlreadyPressed: mLWasPressed)
        mLWasPressed = true
    }
    @IBAction func middleMiddleBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: middleMiddleBoxOutlet, buttonWasAlreadyPressed: mMWasPressed)
        mMWasPressed = true
    }
    @IBAction func middleRightBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: middleRightBoxOutlet, buttonWasAlreadyPressed: mRWasPressed)
        mRWasPressed = true
    }
    @IBAction func lowerLeftBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: lowerLeftBoxOutlet, buttonWasAlreadyPressed: lLWasPressed)
        lLWasPressed = true
    }
    @IBAction func lowerMiddleBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: lowerMiddleBoxOutlet, buttonWasAlreadyPressed: lMWasPressed)
        lMWasPressed = true
    }
    @IBAction func lowerRightBox(_ sender: UIButton) {
        buttonPressed(boxIdentity: lowerRightBoxOutlet, buttonWasAlreadyPressed: lRWasPressed)
        lRWasPressed = true
    }
    
    //if button pressed not already pressed, places marker and makes sound, then switches players turn
    func buttonPressed(boxIdentity: UIButton!, buttonWasAlreadyPressed: Bool) {
        if buttonWasAlreadyPressed == false {
            playSound(playSoundFile: playerPingSound)
            if playerOsTurn == true {
                boxIdentity.setTitle("O", for: .normal)
                boxIdentity.setImage(UIImage(named: playerMarkerO), for: .normal)
                whoseTurnLabel.text = "\(playerX!)'s Turn"
                playerOsTurn = false
            } else {
                boxIdentity.setTitle("X", for: .normal)
                boxIdentity.setImage(UIImage(named: playerMarkerX), for: .normal)
                whoseTurnLabel.text = "\(playerO!)'s Turn"
                playerOsTurn = true
            }
            buttonPressCount += 1
        }
        didWin()
    }
    
    //sound player
    func playSound(playSoundFile: String) {
        if UserDefaults.standard.bool(forKey: "Volume") != false {
            let soundURL = Bundle.main.url(forResource: playSoundFile, withExtension: "wav")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            } catch {
                print(error)
            }
            audioPlayer.play()
        }
    }
    
    //checks after each turn to see if anyone has three in a row and has won, if so calls end game function / sound
    func didWin() {
        if (upperLeftBoxOutlet.titleLabel?.text == "X" && upperMiddleBoxOutlet.titleLabel?.text == "X" && upperRightBoxOutlet.titleLabel?.text == "X") || (middleLeftBoxOutlet.titleLabel?.text == "X" && middleMiddleBoxOutlet.titleLabel?.text == "X" && middleRightBoxOutlet.titleLabel?.text == "X") || (lowerLeftBoxOutlet.titleLabel?.text == "X" && lowerMiddleBoxOutlet.titleLabel?.text == "X" && lowerRightBoxOutlet.titleLabel?.text == "X") || (upperLeftBoxOutlet.titleLabel?.text == "X" && middleLeftBoxOutlet.titleLabel?.text == "X" && lowerLeftBoxOutlet.titleLabel?.text == "X") || (upperMiddleBoxOutlet.titleLabel?.text == "X" && middleMiddleBoxOutlet.titleLabel?.text == "X" && lowerMiddleBoxOutlet.titleLabel?.text == "X") || (upperRightBoxOutlet.titleLabel?.text == "X" && middleRightBoxOutlet.titleLabel?.text == "X" && lowerRightBoxOutlet.titleLabel?.text == "X") || (upperLeftBoxOutlet.titleLabel?.text == "X" && middleMiddleBoxOutlet.titleLabel?.text == "X" && lowerRightBoxOutlet.titleLabel?.text == "X") || (lowerLeftBoxOutlet.titleLabel?.text == "X" && middleMiddleBoxOutlet.titleLabel?.text == "X" && upperRightBoxOutlet.titleLabel?.text == "X") {
            winningLabel.text = "\(playerX!) Wins!"
            playSound(playSoundFile: soundArray[0])
            endGame()
        } else if (upperLeftBoxOutlet.titleLabel?.text == "O" && upperMiddleBoxOutlet.titleLabel?.text == "O" && upperRightBoxOutlet.titleLabel?.text == "O") || (middleLeftBoxOutlet.titleLabel?.text == "O" && middleMiddleBoxOutlet.titleLabel?.text == "O" && middleRightBoxOutlet.titleLabel?.text == "O") || (lowerLeftBoxOutlet.titleLabel?.text == "O" && lowerMiddleBoxOutlet.titleLabel?.text == "O" && lowerRightBoxOutlet.titleLabel?.text == "O") || (upperLeftBoxOutlet.titleLabel?.text == "O" && middleLeftBoxOutlet.titleLabel?.text == "O" && lowerLeftBoxOutlet.titleLabel?.text == "O") || (upperMiddleBoxOutlet.titleLabel?.text == "O" && middleMiddleBoxOutlet.titleLabel?.text == "O" && lowerMiddleBoxOutlet.titleLabel?.text == "O") || (upperRightBoxOutlet.titleLabel?.text == "O" && middleRightBoxOutlet.titleLabel?.text == "O" && lowerRightBoxOutlet.titleLabel?.text == "O") || (upperLeftBoxOutlet.titleLabel?.text == "O" && middleMiddleBoxOutlet.titleLabel?.text == "O" && lowerRightBoxOutlet.titleLabel?.text == "O") || (lowerLeftBoxOutlet.titleLabel?.text == "O" && middleMiddleBoxOutlet.titleLabel?.text == "O" && upperRightBoxOutlet.titleLabel?.text == "O") {
            winningLabel.text = "\(playerO!) Wins!"
            playSound(playSoundFile: soundArray[0])
            endGame()
        } else if buttonPressCount == 9 {
            winningLabel.text = "Tie Game!"
            playSound(playSoundFile: soundArray[2])
            endGame()
        }
    }

    //freezes board from further play when a game has ended (win, tie or loss)
    func endGame() {
        whoseTurnLabel.text = ""
        buttonPressCount = 9
        uLWasPressed = true
        uMWasPressed = true
        uRWasPressed = true
        mLWasPressed = true
        mMWasPressed = true
        mRWasPressed = true
        lLWasPressed = true
        lMWasPressed = true
        lRWasPressed = true
        
        // asks for a rating review if player has played at least 2 games and has just won (only runs 3 times a year per apple logic)
        if gameCountForAdRate >= 2 {
            if winningLabel.text == "\(playerX!) Wins!" || winningLabel.text == "\(playerO!) Wins!" {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    //resets board squares and labels when reset button pressed and plays ads when called
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        //logic to make ads run every 5 games played, without leaving play field screen
        gameCountForAdRate += 1
        
        if gameCountForAdRate % 5 == 0 {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print ("Ad was not ready")
            }
        }
        
        // resets labels and board squares for a new game, loser goes first next game, or not who played last if tied
        if playerOsTurn == true {
            whoseTurnLabel.text = "\(playerO!)'s Turn"
        } else {
            whoseTurnLabel.text = "\(playerX!)'s Turn"
        }
        winningLabel.text = "Good Luck"
        buttonPressCount = 0
        uLWasPressed = false
        uMWasPressed = false
        uRWasPressed = false
        mLWasPressed = false
        mMWasPressed = false
        mRWasPressed = false
        lLWasPressed = false
        lMWasPressed = false
        lRWasPressed = false
        upperLeftBoxOutlet.setTitle(nil, for: .normal)
        upperMiddleBoxOutlet.setTitle(nil, for: .normal)
        upperRightBoxOutlet.setTitle(nil, for: .normal)
        middleLeftBoxOutlet.setTitle(nil, for: .normal)
        middleMiddleBoxOutlet.setTitle(nil, for: .normal)
        middleRightBoxOutlet.setTitle(nil, for: .normal)
        lowerLeftBoxOutlet.setTitle(nil, for: .normal)
        lowerMiddleBoxOutlet.setTitle(nil, for: .normal)
        lowerRightBoxOutlet.setTitle(nil, for: .normal)
        upperLeftBoxOutlet.titleLabel?.text = nil
        upperMiddleBoxOutlet.titleLabel?.text = nil
        upperRightBoxOutlet.titleLabel?.text = nil
        middleLeftBoxOutlet.titleLabel?.text = nil
        middleMiddleBoxOutlet.titleLabel?.text = nil
        middleRightBoxOutlet.titleLabel?.text = nil
        lowerLeftBoxOutlet.titleLabel?.text = nil
        lowerMiddleBoxOutlet.titleLabel?.text = nil
        lowerRightBoxOutlet.titleLabel?.text = nil
        upperLeftBoxOutlet.setImage(nil, for: .normal)
        upperMiddleBoxOutlet.setImage(nil, for: .normal)
        upperRightBoxOutlet.setImage(nil, for: .normal)
        middleLeftBoxOutlet.setImage(nil, for: .normal)
        middleMiddleBoxOutlet.setImage(nil, for: .normal)
        middleRightBoxOutlet.setImage(nil, for: .normal)
        lowerLeftBoxOutlet.setImage(nil, for: .normal)
        lowerMiddleBoxOutlet.setImage(nil, for: .normal)
        lowerRightBoxOutlet.setImage(nil, for: .normal)
    }

    //dismiss screen
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
