//
//  WXClient.swift
//  MyWeather
//
//  Created by weixy on 27/09/14.
//  Copyright (c) 2014 weixy. All rights reserved.
//

import Foundation
import CoreLocation

class WXClient {
    
    var _session: NSURLSession
    
    init() {
        var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self._session = NSURLSession(configuration: config)
    }
    
    func fetchJSONFromURL(url: NSURL) -> RACSignal {
        NSLog("Fetching ... %@", url.absoluteString!)
        //println("Fetching ... %s", url.absoluteString!)
        
        return RACSignal.createSignal({(subscriber:RACSubscriber!) -> RACDisposable in
            var dataTask: NSURLSessionDataTask = self._session.dataTaskWithURL(url, completionHandler: { data, response, error in
                //MARK Handle retrieved data
                if error == nil {
                    var jsonError: NSError? = nil
                    var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                    if jsonError == nil {
                        subscriber.sendNext(json)
                    } else {
                        subscriber.sendError(jsonError)
                    }
                } else {
                    subscriber.sendError(error)
                }
                subscriber.sendCompleted()
            })
            
            dataTask.resume()
            
            return RACDisposable(block: {
                dataTask.cancel()
            })
        }) .doError({(error:NSError!) in
            NSLog("%s", error)
        })
    }
    
    func fetchCurrentConditionsForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        let urlString = NSString(format: "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric",coordinate.latitude, coordinate.longitude)
        var url = NSURL.URLWithString(urlString)
        return self.fetchJSONFromURL(url).map({json -> AnyObject! in
            return MTLJSONAdapter.modelOfClass(WXCondition.self, fromJSONDictionary: json as NSDictionary, error: nil)
        })
    }
    
    func fetchHourlyForecastForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        let urlString = NSString(format: "http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=metric&cnt=12",coordinate.latitude, coordinate.longitude)
        var url = NSURL.URLWithString(urlString)
        return self.fetchJSONFromURL(url).map({json -> AnyObject! in
            var list: RACSequence? = json.objectForKey("list")?.rac_sequence
            return list?.map({item -> AnyObject! in
                return MTLJSONAdapter.modelOfClass(WXCondition.self, fromJSONDictionary: item as NSDictionary, error: nil)
            }).array
        })
    }
    
    func fetchDailyForecastForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        let urlString = NSString(format: "http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=metric&cnt=7",coordinate.latitude, coordinate.longitude)
        var url = NSURL.URLWithString(urlString)
        return self.fetchJSONFromURL(url).map({json -> AnyObject! in
            var list: RACSequence? = json.objectForKey("list")?.rac_sequence
            return list?.map({item -> AnyObject! in
                return MTLJSONAdapter.modelOfClass(WXDailyForecast.self, fromJSONDictionary: item as NSDictionary, error: nil)
            }).array
        })
    }
    
}