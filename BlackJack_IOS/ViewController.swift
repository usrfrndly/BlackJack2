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
    
    var playerLabels:[UILabel] = []
    var playerBetLabels:[UILabel] = []
    var playerBets:[UITextField] = []
    var playerHandLabels:[UILabel] = []
    var playerHands:[UITextField] = []
    var playerTotals:[UITextField] = []
    var playerResults:[UILabel] = []
    var dealerLabel:UILabel!
    var dealerHand:UITextField!
    var activePlayerIndex = 0
    
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet var gameOverField : UITextView!
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
    
    func refreshUI(){
        for(index,player) in enumerate(blackJack.players){
            playerTotals[index].text = String(player.funds.description)
            playerHands[index].text = String(player.playerHand.description)
            playerResults[index].text = String(player.gameOverMess)
        }
        if blackJack.dealer.dealerHand.count == 2 && activePlayerIndex < blackJack.players.count{
            dealerHand.text = "[HoleCard, \(blackJack.dealer.dealerHand[1].description) ]"
        }
        else{
            dealerHand.text = blackJack.dealer.dealerHand.description
        }
        if activePlayerIndex < blackJack.players.count && !blackJack.players[activePlayerIndex].gameOverMess.isEmpty{
            stay()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func setPlayerNumAndDeckNum(sender:AnyObject){
        var playerNum = playerCountTextField.text.toInt()!
        var deckCount = deckCountTextField.text.toInt()!
        playerLabels = []
        playerBets = []
        playerBetLabels = []
        playerHandLabels = []
        playerHands = []
        playerTotals  = []
        playerResults = []
        var y = CGFloat(150)
        if playerNum < 1{
            gameOverField.text = "You must have at least one player"
        }else if deckCount < 1{
            gameOverField.text = "You must select at least one deck"
        }
        else{
            playerCountStepper.hidden = true
            deckCountStepper.hidden = true
            setPlayersAndDeckButton.hidden = true
            deckCountTextField.enabled = false
            playerCountTextField.enabled = false
            blackJack.newGame(playerNum: playerCountTextField.text.toInt()! , deckNum: deckCountTextField.text.toInt()!)
            for x in 1...playerNum{
                var playerLab: UILabel = UILabel()
                playerLab.frame = CGRectMake(0, y, 80,30)
                playerLab.text = "Player \(x)"
                playerLabels.append(playerLab)
                var totalTxtField: UITextField = UITextField()
                totalTxtField.frame = CGRectMake(80, y, 100, 30)
                var funds = blackJack.players[x-1].funds
                totalTxtField.text = NSString(format:"%.2f",funds)
                totalTxtField.userInteractionEnabled = false
                playerTotals.append(totalTxtField)
                var betTxtLabel:UILabel = UILabel()
                betTxtLabel.frame = CGRectMake(180, y, 50, 30)
                betTxtLabel.text = "Bet:"
                playerBetLabels.append(betTxtLabel)
                var betTxtField: UITextField = UITextField()
                betTxtField.frame = CGRectMake(230, y, 80, 30)
                betTxtField.borderStyle = UITextBorderStyle.Line
                betTxtField.text = NSString(format:"%.2f",1.0)
                playerBets.append(betTxtField)
                var playerHandLabel:UILabel = UILabel()
                playerHandLabel.frame = CGRectMake(0,y+50,50,30)
                playerHandLabel.text = "Hand:"
                playerHandLabel.hidden = true
                playerHandLabels.append(playerHandLabel)
                var playerHand: UITextField = UITextField()
                playerHand.frame = CGRectMake(50, y+50, 300, 30)
                playerHand.borderStyle = UITextBorderStyle.Line
                playerHand.hidden = true
                playerHand.userInteractionEnabled = false
                playerHands.append(playerHand)
                var playerResult:UILabel = UILabel()
                playerResult.frame = CGRectMake(150,y+50,150,30)
                playerResult.hidden = true
                playerResult.userInteractionEnabled = false
                playerResult.textColor = UIColor( red: 1.0, green: 0.0, blue:0.0, alpha: 1.0 )
                playerResults.append(playerResult)
                self.view.addSubview(playerLab)
                self.view.addSubview(totalTxtField)
                self.view.addSubview(betTxtLabel)
                self.view.addSubview(betTxtField)
                self.view.addSubview(playerHandLabel)
                self.view.addSubview(playerHand)
                self.view.addSubview(playerResult)
                y += 100
            }
            dealerLabel = UILabel()
            dealerHand = UITextField()
            dealerLabel.frame = CGRectMake(0, y, 80,30)
            dealerLabel.text = "Dealer:"
            dealerLabel.hidden = true
            dealerHand.frame = CGRectMake(100,y,200,30)
            dealerHand.borderStyle =  UITextBorderStyle.Line
            dealerHand.hidden = true
            dealerHand.userInteractionEnabled = false
            self.view.addSubview(dealerLabel)
            self.view.addSubview(dealerHand)
            placeBetButton.hidden = false

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
            else{
                betTextField.userInteractionEnabled = false
            }
        }
        return true
    }
    
    @IBAction func newGame(sender:AnyObject){
        if validate_bets(){
    
            placeBetButton.hidden = true
            hitButton.hidden = false
            stayButton.hidden = false
            blackJack.dealer.clear()
            for (index,player) in enumerate(blackJack.players){
                player.clear()
                playerHandLabels[index].hidden = false
                playerHands[index].hidden = false
                playerResults[index].hidden = false
            }
            dealerLabel.hidden = false
            dealerHand.hidden = false
            activePlayerIndex = 0
            playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
            blackJack.deal()
            gameOverField.text = ""
        }
        refreshUI()
    }
    
    
    
    @IBAction func hit(sender:AnyObject){
        if activePlayerIndex < blackJack.players.count{
            blackJack.playerHit(blackJack.players[activePlayerIndex])
        }
        refreshUI()
    }
    
    func stay(){
        playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 1.0, green: 1.0, blue:1.0, alpha: 1.0)
        activePlayerIndex++
        if activePlayerIndex >= blackJack.players.count{
            blackJack.dealerTurn()
            refreshUI()
            gameOver()
        }else{
            refreshUI()
            playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
        }
    }
    @IBAction func stay(sender:AnyObject){
        stay()
    }
    
    @IBAction func resetGame(sender: AnyObject) {
        for (index,player) in enumerate(blackJack.players){
            playerLabels[index].removeFromSuperview()
            playerHands[index].removeFromSuperview()
            playerBets[index].removeFromSuperview()
            playerBetLabels[index].removeFromSuperview()    
            playerTotals[index].removeFromSuperview()
            playerResults[index].removeFromSuperview()
            playerHandLabels[index].removeFromSuperview()
        }
        dealerLabel.removeFromSuperview()
        dealerHand.removeFromSuperview()
        

        blackJack = BlackjackModel()
        playerCountStepper.hidden = false
        deckCountStepper.hidden = false
        setPlayersAndDeckButton.hidden = false
        deckCountTextField.enabled = true
        playerCountTextField.enabled = true
        ResetButton.hidden = true
        placeBetButton.setTitle("Place Bet", forState: UIControlState.Normal)
        var activePlayerIndex = 0
    
    }
    
    
    func gameOver(){
        activePlayerIndex=0
        dealerHand.text = String(blackJack.dealer.dealerHand.description)
        gameOverField.text = blackJack.gameOverMessage
        placeBetButton.setTitle("Play Again", forState: UIControlState.Normal)
        hitButton.hidden = true
        stayButton.hidden = true
        placeBetButton.hidden = false
        ResetButton.hidden = false
        for (index,player) in enumerate(blackJack.players){
            playerBets[index].userInteractionEnabled=true
        }
        
        
        
        
    }
    
    
}
