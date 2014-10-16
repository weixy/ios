//
//  WXDailyForecast.swift
//  MyWeather
//
//  Created by weixy on 27/09/14.
//  Copyright (c) 2014 weixy. All rights reserved.
//

import Foundation

class WXDailyForecast: WXCondition {
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        /*var paths: NSMutableDictionary = (superclass()?.JSONKeyPathsByPropertyKey() as NSMutableDictionary)
        paths.removeObjectForKey("name")
        paths.removeObjectForKey("windSpeed")
        paths.removeObjectForKey("temperature")
        paths.removeObjectForKey("sunrise")
        paths.removeObjectForKey("sunset")
        paths.removeObjectForKey("windBearing")
        paths.removeObjectForKey("windSpeed")
        paths.setValue("temp.max", forKey: "tempHigh")
        paths.setValue("temp.min", forKey: "tempLow")
        return paths*/
        return ["date": "dt",
            "humidity": "main.humidity",
            "tempHigh": "temp.max",
            "tempLow": "temp.min",
            "conditionDescription": "weather.description",
            "condition": "weather.main",
            "icon": "weather.icon"
        ]
    }
}