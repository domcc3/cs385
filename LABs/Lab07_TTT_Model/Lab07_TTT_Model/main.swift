//
//  main.swift
//  Lab07_Tic_Tac_Toe_Model
//
//  Created by Troy Weingart on 8/29/16.
//  Copyright © 2016 Troy Weingart. All rights reserved.
//

import Foundation


struct TTTModel : CustomStringConvertible {
    enum TTT : String {                 // enum that represents the "state" of a square on the
        case x = "X"                    // tic-tac-toe board
        case o = "O"
        case empty = "-"
        
        init() {
            self = TTT.empty
        }
    }
    
    // Task A: Determine the types of errors that the makeMove() function should throw and modify the enum below to reflect those errors.  You should be able to come up with 3 or 4.
    enum tttErr : ErrorType {
        case space_occupied //you tried to move where someone else is
        case bad_location //you didn't type in either 0, 1, or 2
        case board_full //we got to 10 turns (board is full)
    }
    
    var gameBoard = Array(count: 3, repeatedValue:                                      // 2D array of type TTT
        Array(count: 3, repeatedValue: TTT.empty))                                      // modeling the TTT board
    
    var whoTurn : TTT = .x                                                              // Who goes first
    
    var turnsTaken : Int = 0                                                            // The number of turns taken
    
    var description : String {                                                          // Because we adopt the Custom
        var strRep = "\n  0 1 2 \n"                                                       // StringConvertible protocol
        for (i,v) in gameBoard.enumerate() {                                            // we must have this property
            strRep += "\(i) \(v[0].rawValue) \(v[1].rawValue) \(v[2].rawValue)\n"       // it's a nice string representation
        }                                                                               // of our 2D array
        return strRep
    }
    
    // Task B:  Finish the makeMove() function so that it modifies the gameBoard array based on passed in parameters (whose attempting the move [turn] and a tuple representing the row/col of where the move is attempting to be made [location]).  You should also update the whoTurn and turnsTaken properties and test for and throw the errors from Task A.  Test your code prior to moving on to Task C.
    mutating func makeMove(turn turn : TTT, location: (Int,Int)) throws {
        turnsTaken += 1
        //error checking
        if(turnsTaken == 10) { throw tttErr.board_full }
        if(!(location.0 == 0 || location.0 == 1 || location.0 == 2 || location.1 == 0 || location.1 == 1 || location.1 == 2)){ throw tttErr.bad_location }
        if(gameBoard[location.0][location.1] != .empty){ throw tttErr.space_occupied }
            
        else { gameBoard[location.0][location.1] = turn }
        if(turn == .x){ self.whoTurn = .o }
        else if(turn == .o){ self.whoTurn = .x }
    }
    
    
    // Task C:  Finish the makeMove() function so that it returns TTT.x when "X" wins and TTT.o when "O" wins.  If there is currently no winner it will return nil ... which is why this fuction returns an optional.
    func hasWon() -> TTT? {
        //To do this, keep track of c0, c1, c2, r0, r1, r2, d0, and d1 for one of the letters. They all start at 0, and when you reach -3 or +3, that means someone won. You have to make an array for this.
        return nil
    }
    
    // Task D: Finish the reset() function so that it restores the properties of the TTTModel to their initial state.
    mutating func reset() {
    }
    
}
//-----------------------------------------------------------------------
//
// The code below this point is a simple View (console) and Controller
// (repeat/while loop & logic) that will use methods and properties
// in your Model.
//
//-----------------------------------------------------------------------
var myTTT = TTTModel()                                          // instantiate the tic-tac-toe Model

var gameIsOver = false                                          // represents whether or not the game is done

var row : Int!                                                  // the row of where to place the "x" or "o"

var col : Int!                                                  // the col of where to place the "x" or "o"

repeat {
    // Output the current board to the console
    print(myTTT.description)
    
    // Ask the user for the location to place the "x" or "o"
    print("\(myTTT.whoTurn)'s turn enter row: ",terminator:"")
    row = Int(readLine()!)
    print("\(myTTT.whoTurn)'s turn enter col: ",terminator:"")
    col = Int(readLine()!)
    
    // Make a move -- Note: I didn't catch any errors...you should "try" to do this properly if you have time
    try myTTT.makeMove(turn: myTTT.whoTurn, location: (row,col))
    
    // Check for a winner and end the game if appropriate
    switch myTTT.hasWon() {
    case TTTModel.TTT.x?:
        print("\nX wins!")
        gameIsOver = true
    case TTTModel.TTT.o?:
        print("\nO wins")
        gameIsOver = true
    default:
        break
    }
} while !gameIsOver

print(myTTT.description)