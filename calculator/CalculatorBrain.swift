//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Raza Rauf on 2015-06-27.
//  Copyright (c) 2015 Raza Rauf. All rights reserved.
//

import Foundation
//core services layer, no UI stuff because this the 'model,' which is UI independant

class CalculatorBrain
//the model can inherit from NSObject but this class is going to be a basic swift base class no need for inheritence
{
    //enums can have functions and computed properties but not stored properties
    
    //Op : Printable looks like inheritence but enums don't have inheritence, this is called a protocol, which means this enum implements w/e is in the protocol which is the computed property called description
    private enum Op : CustomStringConvertible{
        case Operand(Double)
        //associating data with this "case" => enumerated member Operand is of type Double
        case UnaryOperation (String, Double -> Double)
        case BinaryOperation (String, (Double, Double) -> Double)
        
        //enums can only have computed properties
        //here the computed proerty is used to tell the system to convert enum to string when println is used
        //has to be called description and must be of type string
        var description: String{
            //its read only so only get
            get {
                //convert each enum to a string
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return "\(symbol)"
                case .BinaryOperation(let symbol, _):
                    return "\(symbol)"
                }
            }
        }
    }
    
    //need to capture operations and operands (math symbol and function)
    //var opStack = Array<Op>()
    private var opStack = [Op]() //same function as the line above but this syntax is prefered
    //Each Op is either an operand or one of the Unary or Binary operation
    
    //var knownOps = Dictionary<String, Op>()
    private var knownOps = [String: Op]()
    
    init(){
        
        func learnOp (op: Op){
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("x",*))
        //knownOps["x"] = Op.BinaryOperation("x") {$0 * $1}
        knownOps["-"] = Op.BinaryOperation("-") {$1 - $0}
        knownOps["+"] = Op.BinaryOperation("+") {$0 + $1}
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["√"] = Op.UnaryOperation("√")  {sqrt($0)}
        knownOps["x²"] = Op.UnaryOperation("x²")  {pow($0, 2)}
        knownOps["x³"] = Op.UnaryOperation("x³")  {pow($0, 3)}
    }
    
    private func evaluate (ops : [Op]) -> (result: Double?, remainingOps: [Op]) {
        //use this for recursion return a smaller stack each time recusively
        if !ops.isEmpty {
            var remainingOps = ops
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
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        //need to return nil b/c sometimes cannot evaluate => return optional
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    //function pushes an operand to the opStack
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if symbol == "C"
        {
            opStack.removeAll()
        } else if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
//        if let operation = knownOps[symbol]{
//            opStack.append(operation)
//        }
        return evaluate()
    }
}