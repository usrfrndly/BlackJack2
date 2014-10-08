//
//  BlackjackModel.swift
//  Blckjack
//
//  Created by Jaclyn May on 9/9/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import Foundation

class BlackjackModel{
    var decks:Decks
    var players:[Player]
    var dealer:Dealer
    var gameNumber:Int
    var gameOverMessage:String?
    var playerNumber:Int
    
    
    init(){
        self.players = []
        self.decks = Decks()
        self.dealer = Dealer()
        self.gameNumber = 0
        self.gameOverMessage = nil
        self.playerNumber = 2
    }
    
    func playAgain(){
        gameOverMessage = ""
        for player in players{
            player.clear()
        }
        dealer.clear()
        
        if gameNumber <= 5{
            gameNumber++
            
        }else{
            self.decks.deck = self.decks.shuffleDeck()
            gameNumber = 0
        }
    }
    
    func newGame(playerNum:Int=2, deckNum:Int=3) {
        gameOverMessage = ""
        playerNumber = playerNum
        var currentPlayersNum = players.count
        for x in 0..<playerNum{
            players.append(Player(number:x+1))
        }
//        if playerNumber != currentPlayersNum{
//            if playerNumber < currentPlayersNum{
//                players = Array(players[0...playerNumber])
//            }
//            else{
//                for x in currentPlayersNum ..< playerNumber {
//                    players += [Player(number:x)]
//                }
//            }
        //}
//        for player in players{
//            player.clear()
//        }
//        dealer.clear()
        // TODO: Check gameNumber calculation
        self.decks = Decks(numDecks: deckNum)

        self.decks.deck=self.decks.shuffleDeck()
        
    }

    
    /**
    Deal the initial cards to the players and dealer and evaluate if either has blackjack
    */
    func deal(){
        var card:Card
        for i in 0...1{
            for player in players{
                card = decks.deck.removeAtIndex(0)
                // Add top card in deck to player's hand
                player.addCard(card)
                // Place card at the end of the deck
                decks.deck.append(card)
            }
            // Add next card to dealer's hand
            card = decks.deck.removeAtIndex(0)
            dealer.addCard(card)
            decks.deck.append(card)
        }
        var dealerHasBlackjack = false
        // dealer.dealerTotal does not include the value of the holeCard and right nowjust contains the value of the dealer's face up card
        // Dealer checks if he has blackjack if second card has a value of 10 or 11
        if dealer.dealerTotal >= 10{
            dealerHasBlackjack = dealer.hasBlackjack()
        }
        for player in players{
            // Check whether either or both the player or dealer have blackjack
            // If both player and dealer have blackjack -> push()
            if player.hasBlackjack() && dealerHasBlackjack{
                push(player)
            }
            else if !player.hasBlackjack() && dealerHasBlackjack {
                playerLose(player)
            }
            else if player.hasBlackjack() && !dealerHasBlackjack{
                playerBj(player)
            }
        }
    }

    func push(player:Player){
        //player.gameOverMess = "Shucks - it's a tie for Player \(player.playerNumber) ."
        player.gameOverMess = "TIE"
    }
    
    /**
    If a player has blackjack (2 cards valuing at 10 and 11) and dealer does not,
    they win 1.5 times their bet
    */
    func playerBj(player:Player){
        player.funds += player.playerBet*1.5
        player.gameOverMess="BLACKJACK."
        //gameOverMessage = "Player \(player.playerNumber) got BLACKJACK, YEERHAW! Wanna play again? Click the New Game button and place a bet."
    }
    
    /**
    If dealer busts or player has a higher value under 21 than the dealer, the player wins the amount she put in
    */
    func playerWin(player:Player){
        player.funds += player.playerBet
        player.gameOverMess="WON."
        //gameOverMessage = "Player \(player.playerNumber) beat the dealer! Ride em cowgirl. Wanna play again? Click the New Game button and place a bet."
        
    }
    /**
    If the player busts, or the dealer has blackjack, or the dealer has a higher ultimate total hand under 21
    than the player, the player loses the amount that they bet
    */
    func playerLose(player:Player){
        player.funds-=player.playerBet
        player.gameOverMess="LOST."
    }
    
    /**
    Player chooses to hit, or get dealt another card
    */
    func playerHit(player:Player){
        var card:Card = decks.deck.removeAtIndex(0)
        player.addCard(card)
        decks.deck.append(card)
        //nothing happens immediately right?
        if player.playerTotal > 21{
            playerLose(player)
        }
        // Game automatically runs the dealer turn if player gets 21
//        if player.playerTotal == 21{
//            dealerTurn()
//        }
    }
    
    /**
    Dealer continues to hit as long as card total is less than 17
    */
    func dealerTurn(){
        var hiddenCard = dealer.revealHoleCard()
        // TODO: Hole card is revealed in gui
        while dealer.dealerTotal < 17{
            var card:Card = decks.deck.removeAtIndex(0)
            dealer.addCard(card)
            decks.deck.append(card)
        }
        for player in players{
            // Check if player has already gotten blackjack or busted
            if player.gameOverMess.isEmpty{
                if dealer.dealerTotal > 21 && player.playerTotal<=21{ // Dealer busts, player wins
                    playerWin(player)
                }
                else if dealer.dealerTotal == player.playerTotal{ // Tie
                    push(player)
                }
                else if dealer.dealerTotal > player.playerTotal{ // Whoever has the greatest total under 21 wins
                    playerLose(player)
                }
                else if dealer.dealerTotal < player.playerTotal{
                    playerWin(player)
                }
            
            }
        }
    }
}
