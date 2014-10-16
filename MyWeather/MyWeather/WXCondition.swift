//
//  WXCondition.swift
//  MyWeather
//
//  Created by weixy on 26/09/14.
//  Copyright (c) 2014 weixy. All rights reserved.
//

import Foundation

class WXCondition: MTLModel, MTLJSONSerializing {
    
    class func imageMap() -> NSDictionary {
        var _imageMap = [
            "01d" : "weather-clear",
            "02d" : "weather-few",
            "03d" : "weather-few",
            "04d" : "weather-broken",
            "09d" : "weather-shower",
            "10d" : "weather-rain",
            "11d" : "weather-tstorm",
            "13d" : "weather-snow",
            "50d" : "weather-mist",
            "01n" : "weather-moon",
            "02n" : "weather-few-night",
            "03n" : "weather-few-night",
            "04n" : "weather-broken-night",
            "09n" : "weather-shower",
            "10n" : "weather-rain-night",
            "11n" : "weather-tstorm",
            "13n" : "weather-snow-night",
            "50n" : "weather-mist-night"
            ]
        return _imageMap
    }
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return ["date": "dt",
            "locationName": "name",
            "humidity": "main.humidity",
            "temperature": "main.temp",
            "tempHigh": "main.temp_max",
            "tempLow": "main.temp_min",
            "sunrise": "sys.sunrise",
            "sunset": "sys.sunset",
            "conditionDescription": "weather.description",
            "condition": "weather.main",
            "icon": "weather.icon",
            "windBearing": "wind.deg",
            "windSpeed": "wind.speed"
            ]
    }
    
    class func conditionDescriptionJSONTransformer() -> NSValueTransformer {
        let _forwardBlock: MTLValueTransformerBlock? = { values in
            return values.firstObject
        }
        let _reserveBlock: MTLValueTransformerBlock? = { str in
            return str
        }
        return MTLValueTransformer.reversibleTransformerWithForwardBlock(_forwardBlock, reverseBlock: _reserveBlock)
    }
    
    class func conditionJSONTransformer() -> NSValueTransformer {
        return self.conditionDescriptionJSONTransformer()
    }
    
    class func iconJSONTransformer() -> NSValueTransformer {
        return self.conditionDescriptionJSONTransformer()
    }
    
    class func windSpeedJSONTransformer() -> NSValueTransformer {
        let MPS_TO_MPH: Float = 2.23694
        
        let _forwardBlock: MTLValueTransformerBlock? = { num in
            return num.floatValue * MPS_TO_MPH
        }
        let _reserveBlock: MTLValueTransformerBlock? = { speed in
            return speed.floatValue / MPS_TO_MPH
        }
        return MTLValueTransformer.reversibleTransformerWithForwardBlock(_forwardBlock, reverseBlock: _reserveBlock)
    }
    
    class func dateJSONTransformer() -> NSValueTransformer {
        let _forwardBlock: MTLValueTransformerBlock? = { str in
            return NSDate(timeIntervalSince1970: str.doubleValue)
        }
        let _reserveBlock: MTLValueTransformerBlock? = { date in
            return NSString(format: "%f", date.timeIntervalSince1970)
        }
        return MTLValueTransformer.reversibleTransformerWithForwardBlock(_forwardBlock, reverseBlock: _reserveBlock)
    }
    
    class func sunriseJSONTransformer() -> NSValueTransformer {
        return self.dateJSONTransformer()
    }
    
    class func sunsetJSONTransformer() -> NSValueTransformer {
        return self.dateJSONTransformer()
    }
    
    var date: NSDate?
    var humidity: NSNumber?
    var temperature: NSNumber?
    var tempHigh: NSNumber?
    var tempLow: NSNumber?
    var locationName: NSString?
    var sunrise: NSDate?
    var sunset: NSDate?
    var conditionDescription: NSString?
    var condition: NSString?
    var windBearing: NSNumber?
    var windSpeed: NSNumber?
    var icon: NSString?
    
    func imageName() -> NSString {
        if let icon = self.icon {
            return WXCondition.imageMap().valueForKey(icon) as NSString
        } else {
            return ""
        }
    }
}