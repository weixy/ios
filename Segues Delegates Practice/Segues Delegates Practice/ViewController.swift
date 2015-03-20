//
//  ViewController.swift
//  Segues Delegates Practice
//
//  Created by weixy on 7/03/15.
//  Copyright (c) 2015 j1mw3i. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FooTwoViewControllerDelegate {

    @IBOutlet var colorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mySegue" {
            let vc = segue.destinationViewController as FooTwoViewController
            vc.colorString = colorLabel.text!
            vc.delegate = self
        }
    }
    
    func myVCDidFinish(controller: FooTwoViewController, text: String) {
        colorLabel.text = "The color is " + text
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
}

