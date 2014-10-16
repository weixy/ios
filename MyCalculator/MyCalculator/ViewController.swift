//
//  ViewController.swift
//  MyCalculator
//
//  Created by weixy on 11/08/14.
//  Copyright (c) 2014 cyberimp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let ADDNEW_LABEL = "AddNewLabel"
    let UPDATE_LABEL = "UpdateLabel"
    let CLEAN_LABEL = "CleanLabel"
    let NUMBER_PRINT_COLOR = UIColor.whiteColor()
    let NUMBER_PRINT_BACKG = UIColor(red: 0.0, green: 0.8, blue: 0.7, alpha: 0.75)
    let OPERAT_PRINT_COLOR = UIColor.whiteColor()
    let BRACKET_PRINT_COLOR = UIColor.whiteColor()
    let OPERAT_PRINT_BACKG = UIColor.whiteColor()
    let NUMBER_KEY_BACKG = UIColor(red: 0.174366, green: 0.174366, blue: 0.174366, alpha: 1.0)
    let NUMBER_KEY_ACTIVE_BACKG = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    let OPERAT_KEY_BACKG = UIColor(red: 0.267518, green: 0.267518, blue: 0.267518, alpha: 1.0)
    let OPERAT_KEY_ACTIVE_BACKG = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    
    
    var font = UIFont(name: "Helvetica Neue", size: CGFloat(25))
    var expModel = ExpressionModel()
    var labelArray: Array<UILabel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLabelTexts:", name: "UpdateLabelView", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var inputField: UILabel!
    @IBOutlet var expField: UILabel!
    @IBOutlet var uiView: UIView!

    @IBAction func numberTapped(butn: UIButton) {
        butn.backgroundColor = NUMBER_KEY_BACKG
        if let text = butn.titleLabel?.text {
            expModel.addNumber(text)
        }
    }
    
    @IBAction func operatorTapped(butn: UIButton) {
        butn.backgroundColor = OPERAT_KEY_BACKG
        if let text = butn.titleLabel?.text {
            expModel.addOperator(text)
        }
    }
    
    @IBAction func numberTouchDown(butn: UIButton) {
        butn.backgroundColor = NUMBER_KEY_ACTIVE_BACKG
        butn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
    }
    
    @IBAction func operatorTouchDown(butn: UIButton) {
        butn.backgroundColor = OPERAT_KEY_ACTIVE_BACKG
        butn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
    }
    
    @IBAction func bracketTapped(butn: UIButton) {
        butn.backgroundColor = OPERAT_KEY_BACKG
        if let text = butn.titleLabel?.text {
            expModel.addBracket(text)
        }
    }
    
    @IBAction func enterTapped(butn: UIButton) {
        if "" != expModel.expression {
            expModel.hasCalcuCompleted = true
            var cal = Calculator()
            cal.transformInfixToPostfix(expModel.expression)
            var result = cal.calculatePostfixExp()
        
            var numberFormatter : NSNumberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            numberFormatter.formatterBehavior = NSNumberFormatterBehavior.BehaviorDefault
            println(result)
            if let inputText = inputField.text {
                if let expFieldText = expField.text {
                    expField.text = expFieldText + inputText
                    inputField.text = numberFormatter.stringFromNumber(result)
                }
            }
        }
    }
    
    @IBAction func clearTapped(butn: UIButton) {
        butn.backgroundColor = OPERAT_KEY_BACKG
        clearLabels()
    }
    
    func updateLabelTexts(notification: NSNotification) {
        if let info = notification.userInfo {
            var action = info["action"] as NSString
            if CLEAN_LABEL == action {
                clearLabels()
            } else {
                var seg = info["segment"] as Segment
                var text = seg.text
                if ADDNEW_LABEL == action && "0" != inputField.text && "." != text {
                    expField.text = expField.text! + inputField.text!
                }
                inputField.text = text
            }
        }
    }
    
    
    
    /** For original design #1 *******
    **********************************/
    
    func updateView(notification: NSNotification) {
        //println("View Controller received notification from ExpressionModel: \(notification.name)")
        if let info = notification.userInfo {
            var action = info["action"] as NSString
            if CLEAN_LABEL == action {
                
            } else {
                var seg = info["segment"] as Segment
                var text = seg.text
                var type = seg.type
                if ADDNEW_LABEL == action {
                    if SEG_NUMB == type {
                        labelArray.append(addLabel(SEG_NUMB, text: text, color: NUMBER_PRINT_COLOR, background: NUMBER_PRINT_BACKG))
                    } else if SEG_OPER == type {
                        if "(" == seg.text || ")" == seg.text {
                            labelArray.append(addLabel(SEG_OPER, text: text, color: BRACKET_PRINT_COLOR, background: OPERAT_PRINT_BACKG))
                        } else {
                            labelArray.append(addLabel(SEG_OPER, text: text, color: OPERAT_PRINT_COLOR, background: OPERAT_PRINT_BACKG))
                        }
                    } else {
                        println("Unknown segment type: \(type)")
                    }
                } else if UPDATE_LABEL == action {
                    updateLabel(labelArray.last!, text: text)
                } else {
                    println("Unknown notification received: \(action)")
                }
            }
        } else {
            println("The object received with notification is empty ...")
        }
    }
    
    func clearLabels() {
        expModel.clearText()
        expField.text = ""
        inputField.text = "0"
    }
    
    func addLabel(type: Int, text: String, color: UIColor, background: UIColor) -> UILabel {
        var size = (text as NSString).sizeWithAttributes([NSFontAttributeName: font])
        var x: CGFloat = 0
        var y: CGFloat = 0
        for preLabel in labelArray {
            var preLabelWidth = preLabel.frame.width
            if (x + preLabelWidth + 10) <= 290 {
                x = x + preLabelWidth + 10
            } else {
                x = 0
                y = y + size.height + 4
            }
        }
        
        var label = UILabel(frame: CGRectMake(x, y, size.width + 10, size.height))
        label.textAlignment = NSTextAlignment.Center
        label.layer.cornerRadius = 8
        label.textColor = color
        
        //if SEG_NUMB == type {
            label.layer.shadowColor = UIColor.yellowColor().CGColor
            label.layer.shadowOffset = CGSizeZero
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 7.0
            label.layer.masksToBounds = false
        //}
        
        label.font = font
        label.text = text
        uiView.addSubview(label)
        return label
    }
    
    func updateLabel(label: UILabel, text: String) {
        var size = (text as NSString).sizeWithAttributes([NSFontAttributeName: font])
        var x: CGFloat = label.frame.origin.x
        var y: CGFloat = label.frame.origin.y
        if (x + size.width) > 290 {
            x = 0
            y = y + label.frame.height + 4
        }
        label.text = text
        label.frame = CGRectMake(
            x,
            y,
            size.width + 10,
            label.frame.height)
    }

}

