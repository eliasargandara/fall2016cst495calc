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
    
    let π = M_PI
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var isDecimalAlreadyInNumber: Bool = false
    
    var operandStack = Array<Double>()

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "-": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast() )
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast() )
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
    
    @IBAction func appendDecimal() {
        if !isDecimalAlreadyInNumber {
            display.text = (display.text!) + "."
            isDecimalAlreadyInNumber = true
        }
    }
    
    @IBAction func insertSymbolicValue(sender: UIButton) {
        let symbol = sender.currentTitle!
        switch symbol {
        case "π": insertValueIntoKeypad(π)
        default: break;
        }
    }
    
    private func insertValueIntoKeypad(value: Double) {
        display.text = "\(value)"
        userIsInTheMiddleOfTypingANumber = false
        isDecimalAlreadyInNumber = false
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        isDecimalAlreadyInNumber = false
        operandStack.append(displayValue);
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        isDecimalAlreadyInNumber = false
        operandStack = Array<Double>()
        display.text = "0"
    }
    
    var displayValue: Double {
        get {
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