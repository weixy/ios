//
//  FooTwoViewController.swift
//  Segues Delegates Practice
//
//  Created by weixy on 7/03/15.
//  Copyright (c) 2015 j1mw3i. All rights reserved.
//

import UIKit

protocol FooTwoViewControllerDelegate {
    func myVCDidFinish(controller: FooTwoViewController, text: String)
}

class FooTwoViewController: UIViewController {

    var delegate: FooTwoViewControllerDelegate? = nil
    var colorString = ""
    
    @IBOutlet var colorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        colorLabel.text = colorString
    }

    @IBAction func saveColor(sender: UIButton) {
        if delegate != nil {
            delegate?.myVCDidFinish(self, text: colorLabel.text!)
        }
    }
    
    @IBAction func colorSelectionButton(sender: UIButton) {
        colorLabel.text = sender.titleLabel?.text
        
    }
}
