//
//  ViewController.swift
//  Blckjack
//
//  Created by Jaclyn May on 9/9/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var blackJack = BlackjackModel()
    
    
    func refreshUI(){
        
        //fundsTextField.text = String(format:"%0.2f", blackJack.player.funds)
        //betTextField.text = String(format:"%0.2f", blackJack.player.playerBet)
        //playerHandTextView.text=String(blackJack.player.playerHand.description)
        //dealerScore.text = String(blackJack.dealer.dealerTotal)
        //playerScore.text = String(blackJack.player.playerTotal)
        var dHand:[Card]=blackJack.dealer.dealerHand
        var dealer_Card_names:String=""
        if !dHand.isEmpty && dHand.count <= 2 && blackJack.gameOverMessage == nil{
            dealer_Card_names = "[" + "HoleCard"
            for i in 1..<dHand.count{
                dealer_Card_names += ", " + dHand[i].name
            }
            dealer_Card_names += "]"
            dealerHandTextView.text = dealer_Card_names
        }
        if blackJack.gameOverMessage != nil {
            gameOver()
        }
    }
    
    //@IBOutlet var fundsTextField: UITextField!
    //@IBOutlet var betTextField: UITextField!
    @IBOutlet var dealerScore: UITextField!
    //@IBOutlet var playerScore: UITextField!
    @IBOutlet weak var dealerHandLabel: UILabel!
    //@IBOutlet weak var playerHandLabel: UILabel!
    //@IBOutlet var playerHandTextView : UITextView!
    @IBOutlet var dealerHandTextView : UITextView!
    @IBOutlet var gameOverField : UITextView!
    @IBOutlet var hitButton : UIButton!
    @IBOutlet var stayButton : UIButton!
    @IBOutlet var deckCountTextField: UITextField!
    @IBOutlet weak var deckCountStepper: UIStepper!
    @IBOutlet weak var playerCountTextField: UITextField!
    @IBOutlet weak var playerCountStepper: UIStepper!
    @IBOutlet weak var setPlayersAndDeckButton: UIButton!
    @IBAction func playerStepper(sender: UIStepper) {
        playerCountTextField.text = String(Int(sender.value))
        
    }
    @IBAction func deckStepper(sender: UIStepper) {
        deckCountTextField.text = String(Int(sender.value))
    }
    
    var playerLabels:[UILabel] = []
    var playerBets:[UITextField] = []
    var playerHands:[UITextView] = []
    var playerTotals:[UITextField] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fundsTextField.text = String(format:"%0.2f", blackJack.player.funds)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGame(sender:AnyObject){
        if validate_bets(){
            dealerHandTextView.hidden = false
            for hand in playerHands{
                hand.hidden = false
            }
            
                //gameOverField.text = ""
            //errorMessageField.text = ""
            refreshUI()
            blackJack.deal()
        }
        //refreshUI()
    }
    
    @IBAction func setPlayerNumAndDeckNum(sender:AnyObject){
        var playerNum = playerCountTextField.text.toInt()!
        var deckCount = deckCountTextField.text.toInt()!
        if playerNum < 1{
            gameOverField.text = "You must have at least one player"
        }else if deckCount < 1{
            gameOverField.text = "You must select at least one deck"
        }
        else{
            setPlayersAndDeckButton.hidden = true
            blackJack.newGame(playerNum: playerCountTextField.text.toInt()! , deckNum: deckCountTextField.text.toInt()!)
            var y = CGFloat(150)
            for x in 1...playerNum{
                var playerLab: UILabel = UILabel()
                playerLab.frame = CGRectMake(0, y, 100,30)
                playerLab.text = "Player \(x)"
                playerLabels.append(playerLab)
                var totalTxtField: UITextField = UITextField()
                totalTxtField.frame = CGRectMake(50, y, 100, 30)
                totalTxtField.text = String(blackJack.players[x-1].playerTotal)
                totalTxtField.userInteractionEnabled = false
                playerTotals.append(totalTxtField)
                var betTxtField: UITextField = UITextField()
                betTxtField.frame = CGRectMake(150, y, 100, 30)
                playerBets.append(betTxtField)
                var playerHand: UITextView = UITextView()
                playerHand.frame = CGRectMake(150, y+100, 100, 30)
                playerHand.hidden = true
                playerHands.append(playerHand)
                self.view.addSubview(playerLab)
                self.view.addSubview(totalTxtField)
                self.view.addSubview(betTxtField)
                self.view.addSubview(playerHand)
                y += 100
            }
            
            deckCountTextField.enabled = false
            deckCountStepper.hidden = true
            playerCountTextField.enabled = false
            playerCountStepper.hidden = true
        }
        
    }
    
    func validate_bets() -> Bool{
        for (index,betTextField) in enumerate(playerBets){
            var betAmount = NSString(string: betTextField.text).doubleValue

        // If bet > 1  and less than playerTotal, sets player bet
            if !blackJack.players[index].bet(betAmount){
                gameOverField.text = "Your bet must be at least $1 and not exceed your funds"
                return false
            }
        }
        return true
    }


//    @IBAction func hit(sender:AnyObject){
//        blackJack.playerHit()
//        refreshUI()
//    }
    @IBAction func stay(sender:AnyObject){
        blackJack.dealerTurn()
        refreshUI()
    }
    func gameOver(){
        hitButton.hidden = true
        stayButton.hidden = true
        dealerHandTextView.text = String(blackJack.dealer.dealerHand.description)
        gameOverField.text = blackJack.gameOverMessage
        dealerHandTextView.text = String(blackJack.dealer.dealerHand.description)
        //playerScore.text = String(blackJack.player.playerTotal)
        dealerScore.text = String(blackJack.dealer.calculateTotal())
       
        //        var alert = UIAlertController(title: "Game Over?", message: blackJack.gameOverMessage, preferredStyle: UIAlertControllerStyle.Alert)
        //        alert.addAction(UIAlertAction(title: "I Quit.", style: UIAlertActionStyle.Default, handler: nil))
        //        alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default){
        //                action in
        //            var betAmount = alert.textFields![0] as UITextField
        //            var playersNum = alert.textFields![1] as UITextField
        //            var deckNum = alert.textFields![2] as UITextField
        //            alert.addAction(UIAlertAction(title:"Start",style:UIAlertActionStyle.Default){
        //                action  in
        //                if self.bet(alert) && Int(deckNum.text) >= 1 && Int(playersNum.text) >= 1{
        //                    self.newGame(sender: alert)
        //                }
        //
        //        alert.textFields[0] = String(1)
        //        alert.textFields[1] = String(3)
        //                }
        //            }
        //    
        
        //self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
}

