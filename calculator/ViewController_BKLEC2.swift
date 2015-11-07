//
//  ViewController.swift
//  calculator
//
//  Created by Raza Rauf on 2015-06-02.
//  Copyright (c) 2015 Raza Rauf. All rights reserved.
//

import UIKit

//ViewController is just a generic default name for the class
//if need to change this name have to change it in the UI as well
//ViewController inheriting UIViewController
//Swift is single inheritence
class ViewController: UIViewController
{
    //defining an "instance variable" called a "property" in Swift
    //this instance variable, property, is pointing to the label OBJECT
    //in Swift all objects live in the heap and memory management is taken care of
    //they get cleaned up when there is no pointer to it... this not garbage collection but reference counting
    //no & or * to indicate this is a pointer
    //any instance variable or property or local variable that is an object
    //its always a pointer to the object so no need for & or *
    
    //var stands for variable, name of variable is the display and UILabel is the type of this instance variable
    //using this instance variable, display, to talk to the label
    //Outlet created an instance variable
    
    //this is an optional and initialized to nil automatically
    //UILabel! is called the implicity unwrapped optional
    @IBOutlet weak var display: UILabel!
    
    //var usrInMiddleOfTypingNumber : Bool = false
    //using type inference
    var usrInMiddleOfTypingNumber = false
    
    //Action created a method, function, for the class...
    //all arguments seprated by commas
    //name_of_argument: the_type_for_argument
    //@IBAction func appendDigit(sender: UIButton) -> returnType {}
    @IBAction func appendDigit(sender: UIButton) {
        //all the digits are calling this appendDigit method
        
        //local variable: 
        //let is same as var accept let is a constant, never changes in this method
        //Swift is very strongly typed, always needs a type for variable but also good at inference
        //Swift has a type called "optional" with "value not set" (nil) or "something"..., this something could be of type string as in "string?" AKA an optional string
        //the '?' is the type, optional, which is set to string
        //its an optional that can be string
        //getting the property here...
        //unwrapping the optinal by the "!" which then goes from being an optional to becoming a string but if button title has never been set... CRASH
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
    
    //stack for numbers 
    //creating an array and initializing with an empty array:
    //var operandStack: Array<Double> = Array<Double>(), bad approach
    //Swift using type inference so don't have to specify
    //just like with the digit up there, right click to see
    var operandStack = Array<Double>()
    //initializing with an empty array of type double
    
    //method for the enter key
    @IBAction func enter() {
        //starting a new number everytime we press enter
        usrInMiddleOfTypingNumber = false
        
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
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
    
    @IBAction func operate(sender: UIButton){
        let operation = sender.currentTitle!
        //giving an automatic enter ... 
        //if user hits 6, E, 3, x same as 6, E, 3, E, x
        if usrInMiddleOfTypingNumber {enter()}
        switch operation
        {
            case "x" : performOperation { $0 * $1 }
            case "÷" : performOperation { $1 / $0 }
            case "+" : performOperation { $0 + $1 }
            case "–" : performOperation { $1 - $0 }
            case "√" : performOperation { sqrt($0) }
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double){
        if operandStack.count >= 1
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
}

