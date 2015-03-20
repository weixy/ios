//
//  HTTPClient.swift
//  MyMusicLibrary
//
//  Created by weixy on 8/03/15.
//  Copyright (c) 2015 j1mw3i. All rights reserved.
//

import UIKit

class HTTPClient {
    func getRequest(url: String) -> (AnyObject) {
        return NSData()
    }
    
    func postRequest(url: String, body: String) -> (AnyObject){
        return NSData()
    }
    
    func downloadImage(url: String) -> (UIImage) {
        let aUrl = NSURL(string: url)
        var data = NSData(contentsOfURL: aUrl!)
        let image = UIImage(data: data!)
        return image!
    }
}

