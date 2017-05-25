//
//  ViewController.swift
//  RetroCalculator
//
//  Created by SANTINO VALENZUELA on 5/21/17.
//  Copyright © 2017 SANTINO VALENZUELA. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var outputLbl: UILabel!
    
    // Using the ! means that it may or may not have an audio to use.
    // So if there is not audio to use, the app could break.
    // Use do/catch statement because we can't rely that there will always have an audio available for use.
    var btnSound: AVAudioPlayer!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }
    
    // To get the processOperation function working, we also need "currentOperation"
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var clear = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab the url path of the btn.wav file from the device.
        // Bundle - Bundle for the app that stores the actual files and things for the application.
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        //print(path)
        
        // Turn path into a URL that can be used.
        // Explecitly unwrapping the path with !.
        // Added ! because we know that there is going to have a string value in the "path" variable.
        let soundURL = URL(fileURLWithPath: path!)
        
        
        // Now that there is a URL in "soundURL", use a do/catch statement, which means do this, if it fails, do this instead.
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
    }
    
    // How to play the sound
    // DO: Have a button call a function to play the sound
    
    //
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        
        runningNumber += "\(sender.tag)"
        print(runningNumber)
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: Any) {
        processOperation(operation: .Divide)
    }
    @IBAction func onMultiplyPressed(sender: Any) {
        processOperation(operation: .Multiply)
    }
    @IBAction func onAddPressed(sender: Any) {
        processOperation(operation: .Subtract)
    }
    @IBAction func onSubtractPressed(sender: Any) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: Any) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        outputLbl.text = "0"
        //leftValStr = ""
        //currentOperation = Operation.Clear
        currentOperation = Operation.Empty
    }

    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    // Create function that will process the operations
    func processOperation(operation: Operation) {
        playSound()
        if currentOperation != Operation.Empty {
            
            // Check if a user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                
                // If runningNumber is not empty, assign the rightValStr to runningNumber
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            currentOperation = operation
        } else {
            // This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
        
    }

}

