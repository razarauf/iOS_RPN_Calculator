//
//  ViewController.swift
//  calculator
//
//  Created by Raza Rauf on 2015-06-02.
//  Copyright (c) 2015 Raza Rauf. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!

    var usrInMiddleOfTypingNumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //append digit onto the end display
        if usrInMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else{
            display.text = digit
            usrInMiddleOfTypingNumber = true
        }
        //println ("digit = \(digit)")
    }
    
    //method for the enter key
    @IBAction func enter() {
        //starting a new number everytime we press enter
        usrInMiddleOfTypingNumber = false
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func operate(sender: UIButton){
        let operation = sender.currentTitle!
        //giving an automatic enter ... 
        //if user hits 6, E, 3, x same as 6, E, 3, E, x
        if usrInMiddleOfTypingNumber {enter()}
        if let result = brain.performOperation(operation){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    //get or set the display value from or to string from or to double
    //called computed property
    //this value is always calculated
    var displayValue : Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set{
            display.text = "\(newValue)"
            usrInMiddleOfTypingNumber = false
        }
    }
}