//
//  ComputerFieldViewController.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-02-24.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import StoreKit

class ComputerFieldViewController: UIViewController, GADInterstitialDelegate {
 
    //outlets
    @IBOutlet weak var compWinLabel: UILabel!
    @IBOutlet weak var compWhoseTurnLabel: UILabel!
    @IBOutlet weak var compULOutlet: UIButton!
    @IBOutlet weak var compUMOutlet: UIButton!
    @IBOutlet weak var compUROutlet: UIButton!
    @IBOutlet weak var compMLOutlet: UIButton!
    @IBOutlet weak var compMMOutlet: UIButton!
    @IBOutlet weak var compMROutlet: UIButton!
    @IBOutlet weak var compLLOutlet: UIButton!
    @IBOutlet weak var compLMOutlet: UIButton!
    @IBOutlet weak var compLROutlet: UIButton!
    @IBOutlet weak var computerFieldBackground: UIImageView!
    @IBOutlet weak var computerFieldLines: UIImageView!
    
    //constants and variables
    let compPlayerO = UserDefaults.standard.string(forKey: "OCompPlayerName")
    let compPlayerX = UserDefaults.standard.string(forKey: "XCompPlayerName")
    let computerTheme = UserDefaults.standard.string(forKey: "Theme")
    var computerMarkerO : String = ""
    var computerMarkerX : String = ""
    let compSoundArray = ["win", "lose", "tie", "billiardsPing", "golfPing", "tennisPing"]
    var computerPingSound : String = ""
    var compAudioPlayer : AVAudioPlayer!
    var compButtonPressCount = 0
    var computersTurn = false
    var uLHasPressed = false
    var uMHasPressed = false
    var uRHasPressed = false
    var mLHasPressed = false
    var mMHasPressed = false
    var mRHasPressed = false
    var lLHasPressed = false
    var lMHasPressed = false
    var lRHasPressed = false
    var interstitial: GADInterstitial!
    var gameCountForAdRate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets initial first turn randomly
        let compRandomTurn = Int(arc4random_uniform(2)) + 1
        if compRandomTurn == 1 {
            compWhoseTurnLabel.text = "\(compPlayerO!)'s Turn"
            if compPlayerO == "Computer" {
                computersTurn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.compTurn()
                })
            }
        } else {
            compWhoseTurnLabel.text = "\(compPlayerX!)'s Turn"
            if compPlayerX == "Computer" {
                computersTurn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.compTurn()
                })
            }
        }
        
        //assigns images and sounds to match selected theme
        if computerTheme == "Billiards" || computerTheme == nil {  // nil - trying to work on default settings if none choosen at start
            computerMarkerO = "billiardsMarkerO"
            computerMarkerX = "billiardsMarkerX"
            computerPingSound = compSoundArray[3]
            computerFieldBackground.image = UIImage(named: "billiardsBackground")
            computerFieldLines.image = UIImage(named: "billiardsLines")
        } else if computerTheme == "Golf" {
            computerMarkerO = "golfMarkerO"
            computerMarkerX = "golfMarkerX"
            computerPingSound = compSoundArray[4]
            computerFieldBackground.image = UIImage(named: "golfBackground")
            computerFieldLines.image = UIImage(named: "golfLines")
        } else if computerTheme == "Tennis" {
            computerMarkerO = "tennisMarkerO"
            computerMarkerX = "tennisMarkerX"
            computerPingSound = compSoundArray[5]
            computerFieldBackground.image = UIImage(named: "tennisBackground")
            computerFieldLines.image = UIImage(named: "tennisLines")
        }
        
        // loads initial ad
        interstitial = createAndLoadInterstitial()
    }
   
    // google admob ad function
    func createAndLoadInterstitial() -> GADInterstitial {
        //sample app unit id ca-app-pub-3940256099942544/4411468910
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3529250513838673/4301630028")
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
    
    //9 play square functions to call button pressed function, then count as being pressed, includes time delay for computer move
    @IBAction func uLBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compULOutlet, buttonWasAlreadyPressed: uLHasPressed)
            uLHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func uMBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compUMOutlet, buttonWasAlreadyPressed: uMHasPressed)
            uMHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func uRBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compUROutlet, buttonWasAlreadyPressed: uRHasPressed)
            uRHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func mLBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compMLOutlet, buttonWasAlreadyPressed: mLHasPressed)
            mLHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func mMBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compMMOutlet, buttonWasAlreadyPressed: mMHasPressed)
            mMHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func mRBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compMROutlet, buttonWasAlreadyPressed: mRHasPressed)
            mRHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func lLBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compLLOutlet, buttonWasAlreadyPressed: lLHasPressed)
            lLHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func lMBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compLMOutlet, buttonWasAlreadyPressed: lMHasPressed)
            lMHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    @IBAction func lRBox(_ sender: UIButton) {
        if computersTurn == false {
            compButtonPressed(boxIdentity: compLROutlet, buttonWasAlreadyPressed: lRHasPressed)
            lRHasPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }

    //if button pressed by player not already pressed, places marker and makes sound, then switches to computers turn
    func compButtonPressed(boxIdentity: UIButton!, buttonWasAlreadyPressed: Bool) {
        if buttonWasAlreadyPressed == false {
            compPlaySound(compPlaySoundFile: computerPingSound)
            if compWhoseTurnLabel.text == "\(compPlayerO!)'s Turn" {
                boxIdentity.setTitle("O", for: .normal)
                boxIdentity.setImage(UIImage(named: computerMarkerO), for: .normal)
                compWhoseTurnLabel.text = "\(compPlayerX!)'s Turn"
            } else {
                boxIdentity.setTitle("X", for: .normal)
                boxIdentity.setImage(UIImage(named: computerMarkerX), for: .normal)
                compWhoseTurnLabel.text = "\(compPlayerO!)'s Turn"
            }
            computersTurn = true
            compButtonPressCount += 1
            didWin()
        }
    }

    //executes computer turn sound and label changes
    func computerPlays(boxIdentity: UIButton!) {
        compPlaySound(compPlaySoundFile: computerPingSound)
        if compWhoseTurnLabel.text == "\(compPlayerO!)'s Turn" {
            boxIdentity.setTitle("O", for: .normal)
            boxIdentity.setImage(UIImage(named: computerMarkerO), for: .normal)
            compWhoseTurnLabel.text = "\(compPlayerX!)'s Turn"
        } else {
            boxIdentity.setTitle("X", for: .normal)
            boxIdentity.setImage(UIImage(named: computerMarkerX), for: .normal)
            compWhoseTurnLabel.text = "\(compPlayerO!)'s Turn"
        }
        computersTurn = false
        compButtonPressCount += 1
    }
    
    //sound player
    func compPlaySound(compPlaySoundFile: String) {
        if UserDefaults.standard.bool(forKey: "Volume") != false {
            let compSoundURL = Bundle.main.url(forResource: compPlaySoundFile, withExtension: "wav")
            do {
                compAudioPlayer = try AVAudioPlayer(contentsOf: compSoundURL!)
            } catch {
                print(error)
            }
            compAudioPlayer.play()
        }
    }

    //computer turn function
    func compTurn() {
        
        //uses variables to simplify logic used to determine where computer will go
        var pip1 = "X"
        var pip2 = "O"
        
        if compPlayerX == "Computer" {
            pip1 = "X"
            pip2 = "O"
        } else {
            pip1 = "O"
            pip2 = "X"
        }
        
        //logic for where the computer chooses to place marker
        while compButtonPressCount != 9 && computersTurn == true {
            
            // First - computer checks if there are any lines with two X's and a blank, if so it places an X in the blank to win.
            
            if compULOutlet.titleLabel?.text == pip1 && compMMOutlet.titleLabel?.text == pip1 && lRHasPressed == false {
                computerPlays(boxIdentity: compLROutlet)
                lRHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip1 && compLROutlet.titleLabel?.text == pip1 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip1 && compLROutlet.titleLabel?.text == pip1 && uLHasPressed == false {
                computerPlays(boxIdentity: compULOutlet)
                uLHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip1 && compMMOutlet.titleLabel?.text == pip1 && lLHasPressed == false {
                computerPlays(boxIdentity: compLLOutlet)
                lLHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip1 && compLLOutlet.titleLabel?.text == pip1 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip1 && compLLOutlet.titleLabel?.text == pip1 && uRHasPressed == false {
                computerPlays(boxIdentity: compUROutlet)
                uRHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip1 && compUROutlet.titleLabel?.text == pip1 && uMHasPressed == false {
                computerPlays(boxIdentity: compUMOutlet)
                uMHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip1 && compUMOutlet.titleLabel?.text == pip1 && uRHasPressed == false {
                computerPlays(boxIdentity: compUROutlet)
                uRHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip1 && compUMOutlet.titleLabel?.text == pip1 && uLHasPressed == false {
                computerPlays(boxIdentity: compULOutlet)
                uLHasPressed = true
            } else if compMLOutlet.titleLabel?.text == pip1 && compMMOutlet.titleLabel?.text == pip1 && mRHasPressed == false {
                computerPlays(boxIdentity: compMROutlet)
                mRHasPressed = true
            } else if compMLOutlet.titleLabel?.text == pip1 && compMROutlet.titleLabel?.text == pip1 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip1 && compMROutlet.titleLabel?.text == pip1 && mLHasPressed == false {
                computerPlays(boxIdentity: compMLOutlet)
                mLHasPressed = true
            } else if compLLOutlet.titleLabel?.text == pip1 && compLMOutlet.titleLabel?.text == pip1 && lRHasPressed == false {
                computerPlays(boxIdentity: compLROutlet)
                lRHasPressed = true
            } else if compLLOutlet.titleLabel?.text == pip1 && compLROutlet.titleLabel?.text == pip1 && lMHasPressed == false {
                computerPlays(boxIdentity: compLMOutlet)
                lMHasPressed = true
            } else if compLMOutlet.titleLabel?.text == pip1 && compLROutlet.titleLabel?.text == pip1 && lLHasPressed == false {
                computerPlays(boxIdentity: compLLOutlet)
                lLHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip1 && compMLOutlet.titleLabel?.text == pip1 && lLHasPressed == false {
                computerPlays(boxIdentity: compLLOutlet)
                lLHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip1 && compLLOutlet.titleLabel?.text == pip1 && mLHasPressed == false {
                computerPlays(boxIdentity: compMLOutlet)
                mLHasPressed = true
            } else if compMLOutlet.titleLabel?.text == pip1 && compLLOutlet.titleLabel?.text == pip1 && uLHasPressed == false {
                computerPlays(boxIdentity: compULOutlet)
                uLHasPressed = true
            } else if compUMOutlet.titleLabel?.text == pip1 && compMMOutlet.titleLabel?.text == pip1 && lMHasPressed == false {
                computerPlays(boxIdentity: compLMOutlet)
                lMHasPressed = true
            } else if compUMOutlet.titleLabel?.text == pip1 && compLMOutlet.titleLabel?.text == pip1 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip1 && compLMOutlet.titleLabel?.text == pip1 && uMHasPressed == false {
                computerPlays(boxIdentity: compUMOutlet)
                uMHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip1 && compMROutlet.titleLabel?.text == pip1 && lRHasPressed == false {
                computerPlays(boxIdentity: compLROutlet)
                lRHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip1 && compLROutlet.titleLabel?.text == pip1 && mRHasPressed == false {
                computerPlays(boxIdentity: compMROutlet)
                mRHasPressed = true
            } else if compMROutlet.titleLabel?.text == pip1 && compLROutlet.titleLabel?.text == pip1 && uRHasPressed == false {
                computerPlays(boxIdentity: compUROutlet)
                uRHasPressed = true
            
            // Second - computer checks if there are any lines with two O's and a blank, if so it places an X in the blank to block.
            
            } else if compULOutlet.titleLabel?.text == pip2 && compMMOutlet.titleLabel?.text == pip2 && lRHasPressed == false {
                computerPlays(boxIdentity: compLROutlet)
                lRHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip2 && compLROutlet.titleLabel?.text == pip2 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip2 && compLROutlet.titleLabel?.text == pip2 && uLHasPressed == false {
                computerPlays(boxIdentity: compULOutlet)
                uLHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip2 && compMMOutlet.titleLabel?.text == pip2 && lLHasPressed == false {
                computerPlays(boxIdentity: compLLOutlet)
                lLHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip2 && compLLOutlet.titleLabel?.text == pip2 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip2 && compLLOutlet.titleLabel?.text == pip2 && uRHasPressed == false {
                computerPlays(boxIdentity: compUROutlet)
                uRHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip2 && compUROutlet.titleLabel?.text == pip2 && uMHasPressed == false {
                computerPlays(boxIdentity: compUMOutlet)
                uMHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip2 && compUMOutlet.titleLabel?.text == pip2 && uRHasPressed == false {
                computerPlays(boxIdentity: compUROutlet)
                uRHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip2 && compUMOutlet.titleLabel?.text == pip2 && uLHasPressed == false {
                computerPlays(boxIdentity: compULOutlet)
                uLHasPressed = true
            } else if compMLOutlet.titleLabel?.text == pip2 && compMMOutlet.titleLabel?.text == pip2 && mRHasPressed == false {
                computerPlays(boxIdentity: compMROutlet)
                mRHasPressed = true
            } else if compMLOutlet.titleLabel?.text == pip2 && compMROutlet.titleLabel?.text == pip2 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip2 && compMROutlet.titleLabel?.text == pip2 && mLHasPressed == false {
                computerPlays(boxIdentity: compMLOutlet)
                mLHasPressed = true
            } else if compLLOutlet.titleLabel?.text == pip2 && compLMOutlet.titleLabel?.text == pip2 && lRHasPressed == false {
                computerPlays(boxIdentity: compLROutlet)
                lRHasPressed = true
            } else if compLLOutlet.titleLabel?.text == pip2 && compLROutlet.titleLabel?.text == pip2 && lMHasPressed == false {
                computerPlays(boxIdentity: compLMOutlet)
                lMHasPressed = true
            } else if compLMOutlet.titleLabel?.text == pip2 && compLROutlet.titleLabel?.text == pip2 && lLHasPressed == false {
                computerPlays(boxIdentity: compLLOutlet)
                lLHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip2 && compMLOutlet.titleLabel?.text == pip2 && lLHasPressed == false {
                computerPlays(boxIdentity: compLLOutlet)
                lLHasPressed = true
            } else if compULOutlet.titleLabel?.text == pip2 && compLLOutlet.titleLabel?.text == pip2 && mLHasPressed == false {
                computerPlays(boxIdentity: compMLOutlet)
                mLHasPressed = true
            } else if compMLOutlet.titleLabel?.text == pip2 && compLLOutlet.titleLabel?.text == pip2 && uLHasPressed == false {
                computerPlays(boxIdentity: compULOutlet)
                uLHasPressed = true
            } else if compUMOutlet.titleLabel?.text == pip2 && compMMOutlet.titleLabel?.text == pip2 && lMHasPressed == false {
                computerPlays(boxIdentity: compLMOutlet)
                lMHasPressed = true
            } else if compUMOutlet.titleLabel?.text == pip2 && compLMOutlet.titleLabel?.text == pip2 && mMHasPressed == false {
                computerPlays(boxIdentity: compMMOutlet)
                mMHasPressed = true
            } else if compMMOutlet.titleLabel?.text == pip2 && compLMOutlet.titleLabel?.text == pip2 && uMHasPressed == false {
                computerPlays(boxIdentity: compUMOutlet)
                uMHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip2 && compMROutlet.titleLabel?.text == pip2 && lRHasPressed == false {
                computerPlays(boxIdentity: compLROutlet)
                lRHasPressed = true
            } else if compUROutlet.titleLabel?.text == pip2 && compLROutlet.titleLabel?.text == pip2 && mRHasPressed == false {
                computerPlays(boxIdentity: compMROutlet)
                mRHasPressed = true
            } else if compMROutlet.titleLabel?.text == pip2 && compLROutlet.titleLabel?.text == pip2 && uRHasPressed == false {
                computerPlays(boxIdentity: compUROutlet)
                uRHasPressed = true
                
            // Third - the computer checks for blanks in the most strategic square - the middle - if blank places an X
                
            } else {
                if mMHasPressed == false {
                    computerPlays(boxIdentity: compMMOutlet)
                    mMHasPressed = true
                
            // Lastly - the computer randomly picks one of the other 8 squares - if blank places an X.  Any further logic to picking squares, e.g. picking corners over sides, or putting an X in a line with another X already, would make the computer impossible to beat
                    
                } else {
                    let randomSquare = Int(arc4random_uniform(8)) + 1
                    switch randomSquare {
                        case 1:
                            if uLHasPressed == false {
                                computerPlays(boxIdentity: compULOutlet)
                                uLHasPressed = true}
                        case 2:
                            if uMHasPressed == false {
                                computerPlays(boxIdentity: compUMOutlet)
                                uMHasPressed = true}
                        case 3:
                            if uRHasPressed == false {
                                computerPlays(boxIdentity: compUROutlet)
                                uRHasPressed = true}
                        case 4:
                            if mLHasPressed == false {
                                computerPlays(boxIdentity: compMLOutlet)
                                mLHasPressed = true}
                        case 5:
                            if mRHasPressed == false {
                                computerPlays(boxIdentity: compMROutlet)
                                mRHasPressed = true}
                        case 6:
                            if lLHasPressed == false {
                                computerPlays(boxIdentity: compLLOutlet)
                                lLHasPressed = true}
                        case 7:
                            if lMHasPressed == false {
                                computerPlays(boxIdentity: compLMOutlet)
                                lMHasPressed = true}
                        case 8:
                            if lRHasPressed == false {
                                computerPlays(boxIdentity: compLROutlet)
                                lRHasPressed = true}
                        default:
                            print("Default error")
                    }
                }
            }
            didWin()
        }
    }
    
    //checks after each turn to see if anyone has three in a row and has won, if so calls end game function / sound
    func didWin() {
        if (compULOutlet.titleLabel?.text == "X" && compUMOutlet.titleLabel?.text == "X" && compUROutlet.titleLabel?.text == "X") || (compMLOutlet.titleLabel?.text == "X" && compMMOutlet.titleLabel?.text == "X" && compMROutlet.titleLabel?.text == "X") || (compLLOutlet.titleLabel?.text == "X" && compLMOutlet.titleLabel?.text == "X" && compLROutlet.titleLabel?.text == "X") || (compULOutlet.titleLabel?.text == "X" && compMLOutlet.titleLabel?.text == "X" && compLLOutlet.titleLabel?.text == "X") || (compUMOutlet.titleLabel?.text == "X" && compMMOutlet.titleLabel?.text == "X" && compLMOutlet.titleLabel?.text == "X") || (compUROutlet.titleLabel?.text == "X" && compMROutlet.titleLabel?.text == "X" && compLROutlet.titleLabel?.text == "X") || (compULOutlet.titleLabel?.text == "X" && compMMOutlet.titleLabel?.text == "X" && compLROutlet.titleLabel?.text == "X") || (compLLOutlet.titleLabel?.text == "X" && compMMOutlet.titleLabel?.text == "X" && compUROutlet.titleLabel?.text == "X") {
            compWinLabel.text = "\(compPlayerX!) Wins!"
            if compPlayerX == "Computer" {
                compPlaySound(compPlaySoundFile: compSoundArray[1])
            } else {
                compPlaySound(compPlaySoundFile: compSoundArray[0])
            }
            endGame()
        } else if (compULOutlet.titleLabel?.text == "O" && compUMOutlet.titleLabel?.text == "O" && compUROutlet.titleLabel?.text == "O") || (compMLOutlet.titleLabel?.text == "O" && compMMOutlet.titleLabel?.text == "O" && compMROutlet.titleLabel?.text == "O") || (compLLOutlet.titleLabel?.text == "O" && compLMOutlet.titleLabel?.text == "O" && compLROutlet.titleLabel?.text == "O") || (compULOutlet.titleLabel?.text == "O" && compMLOutlet.titleLabel?.text == "O" && compLLOutlet.titleLabel?.text == "O") || (compUMOutlet.titleLabel?.text == "O" && compMMOutlet.titleLabel?.text == "O" && compLMOutlet.titleLabel?.text == "O") || (compUROutlet.titleLabel?.text == "O" && compMROutlet.titleLabel?.text == "O" && compLROutlet.titleLabel?.text == "O") || (compULOutlet.titleLabel?.text == "O" && compMMOutlet.titleLabel?.text == "O" && compLROutlet.titleLabel?.text == "O") || (compLLOutlet.titleLabel?.text == "O" && compMMOutlet.titleLabel?.text == "O" && compUROutlet.titleLabel?.text == "O") {
            compWinLabel.text = "\(compPlayerO!) Wins!"
            if compPlayerO == "Computer" {
                compPlaySound(compPlaySoundFile: compSoundArray[1])
            } else {
                compPlaySound(compPlaySoundFile: compSoundArray[0])
            }
            endGame()
        } else if compButtonPressCount == 9 {
            compWinLabel.text = "Tie Game!"
            compPlaySound(compPlaySoundFile: compSoundArray[2])
            endGame()
        }
    }
    
    //freezes board from further play when a game has ended (win, tie or loss)
    func endGame() {
        compButtonPressCount = 9
        compWhoseTurnLabel.text = ""
        uLHasPressed = true
        uMHasPressed = true
        uRHasPressed = true
        mLHasPressed = true
        mMHasPressed = true
        mRHasPressed = true
        lLHasPressed = true
        lMHasPressed = true
        lRHasPressed = true
        
        // asks for a rating review if player has played at least 2 games and has just won (only runs 3 times a year per apple logic)
        if gameCountForAdRate >= 2 {
            if (compPlayerO != "Computer" && compWinLabel.text == "\(compPlayerO!) Wins!") ||
                (compPlayerX != "Computer" && compWinLabel.text == "\(compPlayerX!) Wins!") {
                SKStoreReviewController.requestReview()
            }
        }
    }
 
    //resets board squares and labels when reset button pressed and plays ads when called
    @IBAction func compResetPressed(_ sender: UIButton) {
        
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
        compWinLabel.text = "Good Luck"
        compButtonPressCount = 0
        uLHasPressed = false
        uMHasPressed = false
        uRHasPressed = false
        mLHasPressed = false
        mMHasPressed = false
        mRHasPressed = false
        lLHasPressed = false
        lMHasPressed = false
        lRHasPressed = false
        compULOutlet.setTitle(nil, for: .normal)
        compUMOutlet.setTitle(nil, for: .normal)
        compUROutlet.setTitle(nil, for: .normal)
        compMLOutlet.setTitle(nil, for: .normal)
        compMMOutlet.setTitle(nil, for: .normal)
        compMROutlet.setTitle(nil, for: .normal)
        compLLOutlet.setTitle(nil, for: .normal)
        compLMOutlet.setTitle(nil, for: .normal)
        compLROutlet.setTitle(nil, for: .normal)
        compULOutlet.titleLabel?.text = nil
        compUMOutlet.titleLabel?.text = nil
        compUROutlet.titleLabel?.text = nil
        compMLOutlet.titleLabel?.text = nil
        compMMOutlet.titleLabel?.text = nil
        compMROutlet.titleLabel?.text = nil
        compLLOutlet.titleLabel?.text = nil
        compLMOutlet.titleLabel?.text = nil
        compLROutlet.titleLabel?.text = nil
        compULOutlet.setImage(nil, for: .normal)
        compUMOutlet.setImage(nil, for: .normal)
        compUROutlet.setImage(nil, for: .normal)
        compMLOutlet.setImage(nil, for: .normal)
        compMMOutlet.setImage(nil, for: .normal)
        compMROutlet.setImage(nil, for: .normal)
        compLLOutlet.setImage(nil, for: .normal)
        compLMOutlet.setImage(nil, for: .normal)
        compLROutlet.setImage(nil, for: .normal)
        if computersTurn == false {
            if compPlayerO == "Computer" {
                compWhoseTurnLabel.text = "\(compPlayerX!)'s Turn"
            } else {
                compWhoseTurnLabel.text = "\(compPlayerO!)'s Turn"
            }
        } else {
            if compPlayerO == "Computer" {
                compWhoseTurnLabel.text = "\(compPlayerO!)'s Turn"
            } else {
                compWhoseTurnLabel.text = "\(compPlayerX!)'s Turn"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.compTurn()
            })
        }
    }
    
    //dismiss screen
    @IBAction func compMenuButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
}

