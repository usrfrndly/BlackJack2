//
//  Player.swift
//  Blackjack
//
//  Created by Jaclyn May on 9/15/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import Foundation

/**
*  Class representing the Blackjack player
*/
class Player{
    /// Player money
    var funds:Double
    /// An array of card objects
    var playerHand:[Card]=[]
    /// Sum of the value of the cards in player's han
    var playerTotal:Int
    /// The player's bet this round
    var playerBet:Double
    
    var playerNumber:Int
    
    init(number:Int){
        self.playerTotal = 0
        self.funds = 100.00
        self.playerBet=0.0
        self.playerNumber=number
    }
    
    /**
    Adds a new card to the player's hand
    :param: card Card
    */
    func addCard(card:Card){
        // Determine value of ace
        if(card.isAce()){
            if playerTotal >= 11 {
                card.makeSmallAce()
            }
            else {
                card.makeBigAce()
            }
        }
        playerHand.append(card)
        playerTotal+=card.value
    }
    
    func hasBlackjack() -> Bool{
        if playerTotal == 21{
            return true
        }else{
            return false
        }
    }

    /**
    Player bets on the round
    
    :param: amount The beT amount
    
    :returns: True if the amount bet is valid, false if invalid (less than $1 or exceeds player's funds)
    */
    func bet(amount:Double) -> Bool{
        if amount > funds ||  amount < 1.0{
            return false
        }
        else{
            playerBet=amount
            return true
        }
        
    }
    /**
    Resets player hand, card total, and bet for a new round
    */
    func clear(){
        playerHand=[]
        playerTotal=0
        //playerBet=0
    }
    
    
    
}