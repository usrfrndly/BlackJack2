//
//  Dealer.swift
//  Blackjack
//
//  Created by Jaclyn May on 9/15/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import Foundation

/**
*  Represents a Dealer
*/
class Dealer{
    /// The dealer's hand of cards
    var dealerHand:[Card]=[]
    /// The sum of the dealer's cards
    var dealerTotal:Int
    /// The face down card
    var holeCard:Card? = nil
    
    init(){
        self.dealerTotal = 0
    }
    
    /**
    Adds a card to the dealer's hand
    
    :param: card card
    */
    func addCard(card:Card){
        // The first card in the dealers hand is the holeCard, whose value is hidden
        if dealerHand.isEmpty{
            holeCard = card
        }else{
            // Evaluate ace cards
            if(card.isAce()){
                if dealerTotal >= 11 {
                    card.makeSmallAce()
                }
                else {
                    card.makeBigAce()
                }
            }
            dealerTotal+=card.value
        }
        dealerHand.append(card)
        
    }
    
    
    func calculateHoleCard(){
        if holeCard != nil{
            if(holeCard!.isAce()){
                if dealerTotal >= 11 {
                    holeCard!.makeSmallAce()
                }
                else {
                    holeCard!.makeBigAce()
                }
            }
        }
    }

    func hasBlackjack()->Bool{
        if holeCard != nil{
            calculateHoleCard()
            if dealerTotal+holeCard!.value == 21{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func revealHoleCard() -> Card?{
        if holeCard != nil{
            calculateHoleCard()
            dealerTotal+=holeCard!.value
            return holeCard!
        }else{
            return holeCard
        }
    }
    
    func calculateTotal() -> Int{
        var total:Int=0
        for card in dealerHand{
            total+=card.value
        }
        return total
    }
    
    func clear(){
        holeCard = nil
        dealerHand=[]
        dealerTotal=0
    }
    
}
