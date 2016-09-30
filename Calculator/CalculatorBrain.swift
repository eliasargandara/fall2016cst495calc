//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Eliasar Gandara on 9/15/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    // Stack for storing operations and operands
    private var opStack = [Op]()
    
    // Dictionary for accessing known operations
    private var knownOps = [String:Op]()
    
    // Stack for storing operand and operation history
    private var opHistoryStack = [Op]()
    
    // Dictrionary for storing variables in the calculator brain
    var variableValues = [String:Double]()
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)";
                case .UnaryOperation(let symbol, _):
                    return symbol;
                case .BinaryOperation(let symbol, _):
                    return symbol;
                }
            }
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", {$0 * $1} ) )
        learnOp(Op.BinaryOperation("+", {$0 + $1} ) )
        learnOp(Op.BinaryOperation("÷", {$1 / $0} ) )
        learnOp(Op.BinaryOperation("-", {$1 - $0} ) )
        
        learnOp(Op.UnaryOperation("√", sqrt) )
        learnOp(Op.UnaryOperation("sin", sin) )
        learnOp(Op.UnaryOperation("cos", cos) )
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops;
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        //print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand) )
        opHistoryStack.append(Op.Operand(operand) )
        return evaluate()
    }
    
    // Allows the user to use a stored variable to evaluate an expression
    func pushOperand(symbol: String) -> Double? {
        let variableValue = variableValues[symbol]
        if variableValue != nil {
            let operand = variableValue!
            opStack.append(Op.Operand(operand) )
            opHistoryStack.append(Op.Operand(operand) )
            return evaluate()
        }
        else {
            return nil
        }
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            opHistoryStack.append(operation)
        }
        return evaluate()
    }
    
    func reset() {
        opStack.removeAll()
        opHistoryStack.removeAll()
    }
    
    func getOpHistoryRepresentation() -> String {
        var historyStack = opHistoryStack
        var stackRepresentation = ""
        while !historyStack.isEmpty {
            let op = historyStack.removeFirst()
            stackRepresentation += "\(op.description) "
        }
        return stackRepresentation
    }
}