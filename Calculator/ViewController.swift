//
//  ViewController.swift
//  Calculator
//
//  Created by Eliasar Gandara on 9/2/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var opHistoryDisplay: UILabel!
    let π = M_PI
    
    // Flags for working with user's input
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var isDecimalAlreadyInNumber: Bool = false
    
    var brain = CalculatorBrain()

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                opHistoryDisplay.text = brain.getOpHistoryRepresentation()
            }
            else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendPIValue() {
        if userIsInTheMiddleOfTypingANumber {
            enter();
        }
        display.text = String(π)
        isDecimalAlreadyInNumber = true;
    }
    
    @IBAction func appendDecimal() {
        if !isDecimalAlreadyInNumber {
            display.text = (display.text!) + "."
            isDecimalAlreadyInNumber = true
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        isDecimalAlreadyInNumber = false
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        isDecimalAlreadyInNumber = false
        display.text = "0"
        opHistoryDisplay.text = ""
        
        brain.reset()
    }
    
    var displayValue: Double {
        get {
            // Set empty decimal input to zero to prevent NSNumberFormatter errors
            if display.text! == "." {
                display.text = "0"
            }
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}