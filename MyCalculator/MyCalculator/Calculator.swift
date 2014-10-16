//
//  Calculator.swift
//  MyCalculator
//
//  Created by weixy on 15/08/14.
//  Copyright (c) 2014 cyberimp. All rights reserved.
//

import Foundation

struct Stack <T> {
    var items = [T]()
    
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    
    mutating func top() -> T? {
        return items.last
    }
    
    mutating func printAll() {
        print("[")
        for a: T in items {
            print(" \(a)")
        }
        print(" ]\n")
    }
    
    func size() -> Int {
        return items.count
    }
}

public class Calculator {
    var operatorStack = Stack<String>()
    
    var numberStack = Stack<Double>()
    var postfixExp = String()
    
    let str2doubleRex = "\\d+(\\.\\d+)?"
    let operatorDict: [String : Int] = [
        "=" : 0,
        "+" : 2 , "-" : 2, "−" : 2,
        "*" : 3, "×" : 3, "/" : 3, "÷" : 3]
    
    func transformInfixToPostfix(infixExp: String) {
        println(infixExp)
        var inputs = infixExp.componentsSeparatedByString(" ")
        for input in inputs {
            let match = input.rangeOfString(str2doubleRex, options: .RegularExpressionSearch)
            if nil != match { //It is a number
                updatePostfix(input)
            } else {
                if let topOpr = operatorStack.top() {
                    if "(" == input || operatorStack.items.count == 0 {
                        operatorStack.push(input)
                    } else if ")" == input {
                        while nil != operatorStack.top() {
                            var o = operatorStack.pop()
                            if "(" == o {
                                break;
                            } else {
                                updatePostfix(o)
                            }
                        }
                    } else {
                        var oprLvl = operatorDict[input]
                        if nil == oprLvl {
                            println("Failed to find the level of operator: \(input)")
                        }
                        var topOprLvl = operatorDict[topOpr]
                        if oprLvl > topOprLvl {
                            operatorStack.push(input)
                        } else {
                            
                            while operatorStack.items.count >= 0 {
                                if operatorStack.items.count == 0 {
                                    operatorStack.push(input)
                                    break;
                                }
                                var top = operatorStack.top()
                                if oprLvl <= operatorDict[top!] {
                                    updatePostfix(operatorStack.pop())
                                }
                                else {
                                    operatorStack.push(input)
                                    break;
                                }
                            }
                            
                        }
                    }
                } else {
                    operatorStack.push(input)
                }
                
                
                
            }
        }
        while (0 < operatorStack.items.count) {
            updatePostfix(operatorStack.pop())
        }
    }
    
    func updatePostfix(input: String) {
        if countElements(postfixExp) != 0 {
            postfixExp = postfixExp + " "
        }
        postfixExp = postfixExp + input
    }
    
    func calculatePostfixExp() -> Double {
        println(postfixExp)
        var inputs = postfixExp.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).componentsSeparatedByString(" ")
        
        for input in inputs {
            let match = input.rangeOfString(str2doubleRex, options: .RegularExpressionSearch)
            if nil != match { //It is a number
                var number = (input as NSString).doubleValue
                numberStack.push(number)
            } else {
                var operand1 = numberStack.pop()
                var operand2 = numberStack.pop()
                
                switch input {
                case "+":
                    numberStack.push(operand2 + operand1)
                case "-":
                    numberStack.push(operand2 - operand1)
                case "−":
                    numberStack.push(operand2 - operand1)
                case "*":
                    numberStack.push(operand2 * operand1)
                case "×":
                    numberStack.push(operand2 * operand1)
                case "/":
                    numberStack.push(operand2 / operand1)
                case "÷":
                    numberStack.push(operand2 / operand1)
                default:
                    println("Found a unknown operator: \(input)")
                    return 0.0
                }
            }
        }
        return numberStack.pop()
    }
}
