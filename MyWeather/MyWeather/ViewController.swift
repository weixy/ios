//
//  ViewController.swift
//  MyWeather
//
//  Created by weixy on 21/09/14.
//  Copyright (c) 2014 weixy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var bkgImgView: UIImageView!
    @IBOutlet var bluImgView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var hourlyFormatter: NSDateFormatter
    var dailyFormatter: NSDateFormatter
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        hourlyFormatter = NSDateFormatter()
        hourlyFormatter.dateFormat = "h a"
        dailyFormatter = NSDateFormatter()
        dailyFormatter.dateFormat = "EEEE"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        hourlyFormatter = NSDateFormatter()
        hourlyFormatter.dateFormat = "h a"
        dailyFormatter = NSDateFormatter()
        dailyFormatter.dateFormat = "EEEE"
        super.init(coder: aDecoder)
    }
    
    func initParams() {
        hourlyFormatter = NSDateFormatter()
        hourlyFormatter.dateFormat = "h a"
        dailyFormatter = NSDateFormatter()
        dailyFormatter.dateFormat = "EEEE"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UIImage(named: "background04")
        bluImgView.setImageToBlur(image, blurRadius: 15, completionBlock: nil)
        
        var headerFrame: CGRect = UIScreen.mainScreen().bounds
        let inset: CGFloat = 20
        let temperatureHeight: CGFloat = 110
        let hiloHeight: CGFloat = 40
        let iconHeight: CGFloat = 30
    
        var hiloFrame = CGRectMake(inset,
            headerFrame.size.height - hiloHeight,
            headerFrame.size.width - (2 * inset),
            hiloHeight)
        var temperatureFrame = CGRectMake(inset,
            headerFrame.size.height - (temperatureHeight + hiloHeight),
            headerFrame.size.width - (2 * inset),
            temperatureHeight)
        var iconFrame = CGRectMake(inset,
            temperatureFrame.origin.y - iconHeight,
            iconHeight, iconHeight)
        var conditionsFrame = iconFrame
        conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10)
        conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10)
        
        var header: UIView = UIView(frame: headerFrame)
        header.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = header
        
        var temperatureLabel = UILabel(frame: temperatureFrame)
        temperatureLabel.backgroundColor = UIColor.clearColor()
        temperatureLabel.textColor = UIColor.whiteColor()
        temperatureLabel.text = "0°"
        temperatureLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 120)
        header.addSubview(temperatureLabel)
        
        var hiloLabel = UILabel(frame: hiloFrame)
        hiloLabel.backgroundColor = UIColor.clearColor()
        hiloLabel.textColor = UIColor.whiteColor()
        hiloLabel.text = "0 / 0" //"0° / 0°"
        hiloLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        header.addSubview(hiloLabel)
        
        var cityLabel = UILabel(frame: CGRectMake(0, 20, self.view.bounds.size.width, 30))
        cityLabel.backgroundColor = UIColor.clearColor()
        cityLabel.textColor = UIColor.whiteColor()
        cityLabel.text = "Loading..."
        cityLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cityLabel.textAlignment = NSTextAlignment.Center
        header.addSubview(cityLabel)
        
        var conditionsLabel = UILabel(frame: conditionsFrame)
        conditionsLabel.backgroundColor = UIColor.clearColor()
        conditionsLabel.textColor = UIColor.whiteColor()
        conditionsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        header.addSubview(conditionsLabel)
        
        var iconView = UIImageView(frame: iconFrame)
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        iconView.backgroundColor = UIColor.clearColor()
        header.addSubview(iconView)
        
        RACObserve(WXManager.sharedManager, "currentCondition")
            .ignore(nil)
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext({newCondition in
                var temp = (newCondition as WXCondition).temperature?.floatValue
                var cond = (newCondition as WXCondition).condition?.capitalizedString
                var city = (newCondition as WXCondition).locationName?.capitalizedString
                var imgN = (newCondition as WXCondition).imageName()
                var humd = (newCondition as WXCondition).humidity?.floatValue
                var wind = (newCondition as WXCondition).windSpeed?.floatValue
                var high = (newCondition as WXCondition).tempHigh?.floatValue
                var low = (newCondition as WXCondition).tempLow?.floatValue
                temperatureLabel.text =  NSString(format: "%.0f°", temp!)
                conditionsLabel.text = cond
                cityLabel.text = city
                iconView.image = UIImage(named: imgN)
                hiloLabel.text = NSString(format: "Humidity: %.0f%% / Wind speed: %.0fm/s", humd!, wind!)
                //hiloLabel.text = NSString(format: "%.0f° / %.0f°", high!, low!)
            })
        
        RACObserve(WXManager.sharedManager, "hourlyForecast")
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext({newForecast in
                self.tableView.reloadData()
            })
        
        RACObserve(WXManager.sharedManager, "dailyForecast")
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext({newForecast in
                self.tableView.reloadData()
            })
        
        /*var signal = RACSignal.combineLatest([
            RACObserve(WXManager.sharedManager, "currentCondition.tempHigh"),
            RACObserve(WXManager.sharedManager, "currentCondition.tempLow")])
            .map({tuple -> AnyObject in
                let signals = (tuple as RACTuple).allObjects() as NSArray
                NSLog("%s", signals)
                return NSString(format: "%.0f° / %.0f°")
            })
            .deliverOn(RACScheduler.mainThreadScheduler())
        signal ~> RAC(hiloLabel, "text")*/
            /*.reduce({(hi: NSNumber, low: NSNumber) in
                return NSString(format: "%.0f° / %.0f°", hi.floatValue, low.floatValue)
            })*/
        
        WXManager.sharedManager.findCurrentLocation()
        
        /*if WXManager.sharedManager.locationManager.location == nil {
            TSMessage.showNotificationInViewController(self, title: "Can't find location!", subtitle: "WXManager.sharedManager.locationManager.location", type: TSMessageNotificationType.Error)
        } else {
            TSMessage.showNotificationInViewController(self, title: "Found location!", subtitle: WXManager.sharedManager.locationManager.location.description, type: TSMessageNotificationType.Success)
        }*/
        
    }
    
    //MARK UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var height = scrollView.bounds.size.height
        var position: CGFloat = max(scrollView.contentOffset.y, 0.0)
        var percent: CGFloat = min(position/height, 1.0)
        self.bluImgView.alpha = percent
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var bounds: CGRect = self.view.bounds
        self.bkgImgView.frame = bounds
        self.bluImgView.frame = bounds
        self.tableView.frame = bounds
    }

    //MARK UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> NSInteger {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return min(WXManager.sharedManager.hourlyForecast.count, 6) + 1
        }
        return min(WXManager.sharedManager.dailyForecast.count, 6) + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: NSString = "CellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if nil == cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.backgroundColor = UIColor(white: 0, alpha: 0.2)
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                configureHeaderCell(cell!, title: "Hourly Forecast")
            } else {
                var weather = WXManager.sharedManager.hourlyForecast[indexPath.row - 1] as WXCondition
                configureHourlyCell(cell!, weather: weather)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                configureHeaderCell(cell!, title: "Daily Forecast")
            } else {
                var weather = WXManager.sharedManager.dailyForecast[indexPath.row - 1] as WXCondition
                configureDailyCell(cell!, weather: weather)
            }
        }
        
        return cell!
    }
    
    //MARK UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellCount = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        var screenRect = UIScreen.mainScreen().bounds
        return screenRect.height / CGFloat(cellCount);
    }
    
    func configureHeaderCell(cell: UITableViewCell, title: NSString) {
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = nil
    }
    
    func configureHourlyCell(cell: UITableViewCell, weather: WXCondition) {
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.textLabel?.text = self.hourlyFormatter.stringFromDate(weather.date!)
        if let temp = weather.temperature {
            cell.detailTextLabel?.text = NSString(format: "%.0f°", temp.floatValue)
        }
        cell.imageView?.image = UIImage(named: weather.imageName())
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func configureDailyCell(cell: UITableViewCell, weather: WXCondition) {
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.textLabel?.text = self.dailyFormatter.stringFromDate(weather.date!)
        cell.detailTextLabel?.text = NSString(format: "%.0f° / %.0f°",
            weather.tempHigh!.floatValue, weather.tempLow!.floatValue)
        cell.imageView?.image = UIImage(named: weather.imageName())
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }

}