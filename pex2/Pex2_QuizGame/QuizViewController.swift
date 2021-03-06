//
//  QuizViewController.swift
//  Pex2_QuizGame
//
//  Created by Dom Celiano on 10/7/16.
//  Copyright © 2016 Dom Celiano. All rights reserved.
//

//DOCUMENTATION: I used this resource quite a bit: https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson8.html
//  I got help with the shuffle function from Lt Col Wiengart.
//  Lt Col Weingart helped me understand how Lab 15 worked, which helped me get my protocol/delegate functionality working.

import UIKit

class QuizViewController: UIViewController, PresentedVCDelegate{
    var settings = quizSettings()
    var questionToDisplay = quizViewSettings()
    var myModel = quizModel()
    var guess_correct = false
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topBar: UISegmentedControl!
    @IBOutlet weak var middleBar: UISegmentedControl!
    @IBOutlet weak var bottomBar: UISegmentedControl!
    @IBAction func topBarPressed(_ sender: AnyObject) {
        let done = barPressed(0, offset: topBar.selectedSegmentIndex)
        if(!done){ topBar.setEnabled(false, forSegmentAt: topBar.selectedSegmentIndex) }
    }
    
    @IBAction func middleBarPressed(_ sender: AnyObject) {
        let done = barPressed(3, offset: middleBar.selectedSegmentIndex)
        if(!done){ middleBar.setEnabled(false, forSegmentAt: middleBar.selectedSegmentIndex) }
    }
    @IBAction func bottomBarPressed(_ sender: AnyObject) {
        let done = barPressed(6, offset: bottomBar.selectedSegmentIndex)
        if(!done){ bottomBar.setEnabled(false, forSegmentAt: bottomBar.selectedSegmentIndex) }
    }
    func barPressed(_ barStartIndex: Int, offset: Int) -> Bool{ //returns if the game is over or not
        guess_correct = self.myModel.makeGuess(barStartIndex + offset)
        if(guess_correct){
            statusLabel.text = "Correct!"
            CATransaction.flush()
            sleep(1)
            self.getNewQuestion()
            return true
        }
        else{
            statusLabel.text = "You are wrong. Try again."
            return false
        }
    }
    
    func getNewQuestion(){
        questionToDisplay = myModel.getNewQuestion(self.settings)
        if(questionToDisplay.game_over){
            let alertController = UIAlertController(title: "Quiz Finished", message: "You scored a \(questionToDisplay.quiz_score)%", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "New Quiz", style: UIAlertActionStyle.default,handler: gameOverAlertHandler))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            imageView.image = UIImage(named: questionToDisplay.image_name)
            self.updateChoiceBars()
            statusLabel.text = "Please select the country where the landmark is located."
        }
    }
    
    func gameOverAlertHandler(_ alert: UIAlertAction!){
        myModel.resetGame()
        self.getNewQuestion()
    }
    
    func updateChoiceBars(){
        //We will remove all of the choices, and then rebuild them
        topBar.removeAllSegments()
        middleBar.removeAllSegments()
        bottomBar.removeAllSegments()
        if(settings.num_possibilities >= 3){ //start building from the first (top) row
            for i in 0...2{
                topBar.insertSegment(withTitle: self.myModel.questionToDisplay.choices[i], at: i % 3, animated: false)
            }
        }
        if(settings.num_possibilities >= 6){
            for i in 3...5{
                middleBar.insertSegment(withTitle: self.myModel.questionToDisplay.choices[i], at: i % 3, animated: false)
            }
        }
        if(settings.num_possibilities >= 9){
            for i in 6...8{
                bottomBar.insertSegment(withTitle: self.myModel.questionToDisplay.choices[i], at: i % 3, animated: false)
            }
        }
    }
    
    // MARK : Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettings"{ //if we are about to segue to the SettingsViewController
            let destController = segue.destination as! SettingsViewController
            destController.delegate = self
            destController.settings = settings //pass the old settings
        }
    }
    func acceptNewSettings(_ newSettings : quizSettings){
        self.settings = newSettings
        let get_new_question = self.myModel.updateAnswerPool(self.settings)
        if(get_new_question){ self.gameOverAlertHandler(nil) } //if we should get a new question
        self.updateChoiceBars()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myModel.oldSettings = settings //as soon as we start the app, initialize the old setting so we will know if we change anything
        self.myModel.loadImagesIntoArray() //read all the image names into an array
        self.gameOverAlertHandler(nil) //display a question to get going
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
