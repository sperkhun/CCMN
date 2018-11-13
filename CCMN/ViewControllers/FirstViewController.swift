//
//  FirstViewController.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/6/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

let pickerData = ["Today", "Yesterday", "Last 3 days", "Last 7 days", "Last 30 days"]//, "This month", "Last month", "Custom"]

class FirstViewController: UIViewController {

    @IBOutlet weak var totalVisitors: UILabel!
    @IBOutlet weak var dwellTime: UILabel!
    @IBOutlet weak var peakHour: UILabel!
    @IBOutlet weak var conversionRate: UILabel!
    @IBOutlet weak var topDevice: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let request = CiscoRequests()
    let correlations = Correlations()
    var timer: Timer!
    @IBOutlet weak var barView: GroupBar!
    @IBOutlet weak var lineView: LineChart!
    @IBOutlet weak var secondLineView: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineDates()
        makeAllRequests()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(makeInfoRequests), userInfo: nil, repeats: true)
//        timer.invalidate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func makeAllRequests() {
        // GET all maps
        request.jsonRequest(name: "floorInfo") { complete in
            if complete {
                for floor in MainData.floorInfo.2 {
                    let floorURL = "/\(MainData.floorInfo.0)/\(MainData.floorInfo.1)/\(floor)"
                    self.request.dataRequest(name: "mapImg", floor: floorURL) { complete in
                        if complete {
                            print("img is ok!")
                        }
                    }
                }
            }
        }
        
        // GET site id
        request.jsonRequest(name: "siteId") { complete in
            if complete {
                self.makeInfoRequests()
            }
        }
        
    }
    
    @objc func makeInfoRequests() {
        
        //GET Main Information
        request.paramJsonRequest(name: "mainInfo", dopUrl: (timeParams[MainData.timeStamp]?.0)!, param: ["siteId" : MainData.siteId!]) { complete in
            if complete {
                self.totalVisitors.text = MainData.mainInfo[0]
                self.dwellTime.text = MainData.mainInfo[1]
                self.peakHour.text = MainData.mainInfo[2]
                self.conversionRate.text = MainData.mainInfo[3]
                self.topDevice.text = MainData.mainInfo[4]
            }
        }
        
        // GET all clients
        request.jsonRequest(name: "clientsInfo") { complete in
            if complete {
                let nv = self.tabBarController?.selectedViewController as? UINavigationController
                if let vc = nv?.visibleViewController as? SecondViewController {
                    vc.macAddr.removeAll()
                    vc.macAddr.append(contentsOf: MainData.clientsInfo1stFloor)
                    vc.macAddr.append(contentsOf: MainData.clientsInfo2ndFloor)
                    vc.macAddr.append(contentsOf: MainData.clientsInfo3rdFloor)
                    vc.tableView.reloadData()
                }
            }
        }
        
        // GET Proximity
        request.paramJsonRequest(name: "passersby", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: ["siteId" : MainData.siteId!]) { complete in
            if complete {
                self.request.paramJsonRequest(name: "visitors", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: ["siteId" : MainData.siteId!]) { complete in
                    if complete {
                        self.request.paramJsonRequest(name: "connected", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: ["siteId" : MainData.siteId!]) { complete in
                            if complete {
                                self.barView.drawChart()
                                //                self.correlations.buildCorrelations(type: "connected")
                            }
                        }
                        //                self.correlations.buildCorrelations(type: "visitors")
                    }
                }
//                self.correlations.buildCorrelations(type: "passersby")
            }
        }
        
        //GET Dwell Time
        request.paramJsonRequest(name: "dwellTime", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: ["siteId" : MainData.siteId!]) { complete in
            if complete {
                self.lineView.drawChartFill()
              //  self.correlations.buildCorrelations(type: "dwellTime")
            }
        }
        
        // GET Repeat Visitors
        request.paramJsonRequest(name: "repeatVisitors", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: ["siteId" : MainData.siteId!]) { complete in
            if complete {
                self.secondLineView.drawChart()
                //  self.correlations.buildCorrelations(type: "dwellTime")
            }
        }
    }

    func defineDates() {
        MainData.currentDay = Date()
        var components = Calendar.current.dateComponents([.year, .month], from: MainData.currentDay!)
        switch MainData.timeStamp {
        case "Lastweek" : do {
            MainData.startDay = Calendar.current.date(byAdding: .day, value: -7, to: MainData.currentDay!)!
            MainData.endDay = MainData.currentDay!
            }
        case "last30" : do {
            MainData.startDay = MainData.currentDay!
            MainData.endDay = Calendar.current.date(byAdding: .month, value: -1, to: MainData.currentDay!)!
            }
        case "thismonth" : do {
            MainData.startDay = Calendar.current.date(from: components)!
            MainData.endDay = MainData.currentDay!
            }
        case "lastmonth" : do {
            components.month = components.month! - 1
            MainData.startDay = Calendar.current.date(from: components)!
            components.month = components.month! + 1
            components.day = 1
            components.day = components.day! - 1
            MainData.endDay = Calendar.current.date(from: components)!
            }
        default:
            return
        }
    }
    
}


extension FirstViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        MainData.timeStamp = pickerData[row]
        makeInfoRequests()
    }
}
