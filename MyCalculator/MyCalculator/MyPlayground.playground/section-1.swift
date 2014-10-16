// Playground - noun: a place where people can play

import UIKit

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
}

public class Calculator {
    var operatorStack = Stack<String>()
    
    var numberStack = Stack<Double>()
    var postfixExp = String()
    
    let str2doubleRex = "\\d+(\\.\\d+)?"
    let operatorDict: [String : Int] = [
        "=" : 0,
        "+" : 2 , "-" : 2,
        "*" : 3, "/" : 3]
    
    func transformInfixToPostfix(infixExp: String) {
        var inputs = infixExp.componentsSeparatedByString(" ")
        for input in inputs {
            println(postfixExp)
            print(input + "->" )
            operatorStack.printAll()
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
                            println("Found a unknown operator: \(input)")
                        }
                        var topOprLvl = operatorDict[topOpr]
                        print(">> " + topOpr + "|")
                        print(oprLvl)
                        println(topOprLvl)
                        if oprLvl > topOprLvl {
                            operatorStack.push(input)
                        } else {
                            
                            while operatorStack.items.count >= 0 {
                                if operatorStack.items.count == 0 {
                                    operatorStack.push(input)
                                    break;
                                }
                                var top = operatorStack.top()
                                print(">> ")
                                print(top)
                                println(operatorDict[top!])
                                if oprLvl <= operatorDict[top!] {
                                    updatePostfix(operatorStack.pop())
                                }
                                else {
                                    println(">> " + input)
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
        var inputs = postfixExp.componentsSeparatedByString(" ")
        
        for input in inputs {
            let match = input.rangeOfString(str2doubleRex, options: .RegularExpressionSearch)
            if nil != match { //It is a number
                var number = (input as NSString).doubleValue
                println(" \(number)")
                numberStack.push(number)
            } else {
                var operand1 = numberStack.pop()
                var operand2 = numberStack.pop()
                
                switch input {
                case "+":
                    numberStack.push(operand2 + operand1)
                case "-":
                    numberStack.push(operand2 - operand1)
                case "*":
                    numberStack.push(operand2 * operand1)
                case "/":
                    numberStack.push(operand2 / operand1)
                default:
                    println("Found a unknown operator: \(input)")
                    return 0.0
                }
                numberStack.printAll()
            }
        }
        //numberStack.printAll()
        return numberStack.pop()
    }
}

var cal = Calculator()
//cal.transformInfixToPostfix("9 + ( 3 - 1 ) * 3 / 2 + 10 / 2")
cal.transformInfixToPostfix("6 + ( 3 / 2 ) - 20 / 2")
//cal.postfixExp = "9 3 1 - 3 * + 10 2 / +"
NSString(format: "%f", cal.calculatePostfixExp())
