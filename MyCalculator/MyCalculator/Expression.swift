//
//  Expression.swift
//  MyCalculator
//
//  Created by weixy on 18/08/14.
//  Copyright (c) 2014 cyberimp. All rights reserved.
//

import Foundation

let SEG_NUMB = 0
let SEG_OPER = 1

class Segment {
    var type = SEG_NUMB
    var text: String = ""
}

class ExpressionModel {
    var segments: Array<Segment>
    var expression: String
    var hasCalcuCompleted: Bool
    
    init() {
        expression = ""
        hasCalcuCompleted = false
        segments = []
    }
    
    func addNumber(num: String) {
        checkIfRestart()
        
        if hasCalcuCompleted || "" == expression {
            addSegment(num, type: SEG_NUMB)
            expression = num
            hasCalcuCompleted = false
        } else if let match = expression.rangeOfString(
            "[\\d{1,}\\.{0,1}]$", options: .RegularExpressionSearch) {
            updateSegment(num)
            expression = expression + num
        } else {
            addSegment(num, type: SEG_NUMB)
            expression = expression + " " + num
        }
    }
    
    func addOperator(oper: String) {
        if let match = expression.rangeOfString("\\d$", options: .RegularExpressionSearch) {
            addSegment(oper, type: SEG_OPER)
            expression = expression + " " + oper
        } else if let match = expression.rangeOfString("\\)$", options: .RegularExpressionSearch) {
            addSegment(oper, type: SEG_OPER)
            expression = expression + " " + oper
        }
    }
    
    func addBracket(bracket: String) {
        if let match = expression.rangeOfString("\\d$", options: .RegularExpressionSearch) {
            if ")" == bracket && hasMatchedBracket(expression){
                addSegment(bracket, type: SEG_OPER)
                expression = expression + " " + bracket
            }
        } else {
            if "(" == bracket {
                checkIfRestart()
                addSegment(bracket, type: SEG_OPER)
                expression = expression + " " + bracket
            }
        }
    }
    
    func hasMatchedBracket(exp: String) -> Bool {
        var segs = exp.componentsSeparatedByString(" ")
        var bracketStack = Stack<String>()
        for seg in segs {
            if "(" == seg {
                bracketStack.push(seg)
            } else if ")" == seg {
                if 0 == bracketStack.size() {
                    return false
                } else {
                    bracketStack.pop()
                }
            }
        }
        
        if 0 == bracketStack.size() {
            return false
        }
        
        return true
    }
    
    func addSegment(txt: String, type: Int) {
        var seg = Segment()
        seg.text = txt
        seg.type = type
        segments.append(seg)
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateLabelView", object: nil, userInfo: ["segment": seg, "action": "AddNewLabel"])
    }
    
    func updateSegment(txt: String) {
        var seg = segments.removeLast()
        if SEG_NUMB == seg.type {
            seg.text = seg.text + txt
            segments.append(seg)
        } else {
            println("Incorrect type of last segment, can't be operator ...")
        }
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateLabelView", object: nil, userInfo: ["segment": seg, "action": "UpdateLabel"])
    }
    
    func checkIfRestart() {
        if hasCalcuCompleted {
            segments.removeAll(keepCapacity: false)
            expression = ""
            NSNotificationCenter.defaultCenter().postNotificationName("UpdateLabelView", object: nil, userInfo: ["action": "CleanLabel"])
        }
        hasCalcuCompleted = false
    }
    
    func clearText() {
        expression = ""
        segments.removeAll(keepCapacity: false)
        hasCalcuCompleted = false
    }
}