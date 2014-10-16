//
//  WXManager.swift
//  MyWeather
//
//  Created by weixy on 28/09/14.
//  Copyright (c) 2014 weixy. All rights reserved.
//

import Foundation
import CoreLocation

class WXManager: NSObject, CLLocationManagerDelegate {
    dynamic var currentCondition: WXCondition?
    dynamic var currentLocation: CLLocation?
    dynamic var hourlyForecast: NSArray = []
    dynamic var dailyForecast: NSArray = []
    var locationManager: CLLocationManager
    var isFirstUpdate: Bool = false
    var client: WXClient
    
    class var sharedManager: WXManager {
        struct Static {
            static var instance: WXManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = WXManager()
        }
        return Static.instance!
    }
    
    override init() {
        client = WXClient()
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.requestWhenInUseAuthorization()
        
        
        
        RACObserve(self, "currentLocation")
            .ignore(nil)
            .flattenMap({newLocation in
                return RACSignal.merge([
                    self.updateCurrentConditions(),
                    self.updateHourlyForecast(),
                    self.updateDailyForecast()])
            })
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeError({error in
                TSMessage.showNotificationWithTitle("Error", subtitle: "There was a problem fetching the latest weather.", type: TSMessageNotificationType.Error)
            })
    }
    
    func updateCurrentConditions() -> RACSignal {
        NSLog(">> Update current conditions ...")
        return self.client.fetchCurrentConditionsForLocation(self.currentLocation!.coordinate)
            .doNext({ condition in
                WXManager.sharedManager.currentCondition = condition as WXCondition?
            })
    }
    
    func updateHourlyForecast() -> RACSignal {
        NSLog(">> Update hourly forecast ...")
        return self.client.fetchHourlyForecastForLocation(self.currentLocation!.coordinate)
            .doNext({ conditions in
                WXManager.sharedManager.hourlyForecast = conditions as NSArray
            })
    }
    
    func updateDailyForecast() ->RACSignal {
        NSLog(">> Update daily forecast ...")
        return self.client.fetchDailyForecastForLocation(self.currentLocation!.coordinate)
            .doNext({ conditions in
                WXManager.sharedManager.dailyForecast = conditions as NSArray
            })
    }
    
    func findCurrentLocation() {
        self.isFirstUpdate = true
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        if self.isFirstUpdate {
            self.isFirstUpdate = false
            return;
        }
        var location: CLLocation = locations.last as CLLocation
        if location.horizontalAccuracy > 0 {
            self.currentLocation = location
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    
}