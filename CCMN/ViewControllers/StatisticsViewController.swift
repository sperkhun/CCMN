//
//  StatisticsViewController.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/6/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit
import Foundation

class StatisticsViewController: UIViewController, UIGestureRecognizerDelegate {

    let pickerData = ["Today", "Yesterday", "Last 3 days", "Last 7 days", "Last 30 days", "This month", "Last month", "Custom"]
    
    @IBOutlet weak var predictionBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var totalVisitors: UILabel!
    @IBOutlet weak var dwellTime: UILabel!
    @IBOutlet weak var peakHour: UILabel!
    @IBOutlet weak var conversionRate: UILabel!
    @IBOutlet weak var topDevice: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var loadingView: UIView!
    
    let request = CiscoRequests()
    static let correlations = Correlations()
    static let visitorsPrediction = Prediction()
    static let passersbyPrediction = Prediction()
    static let connectedPrediction = Prediction()

    var timer: Timer!
    @IBOutlet weak var barView: GroupBar!
    @IBOutlet weak var lineView: LineChart!
    @IBOutlet weak var secondLineView: LineChart!

    @IBOutlet weak var proximityGenView: PieChart!
    @IBOutlet weak var proximityView: PieChart!
    @IBOutlet weak var repeatVisitorsView: PieChart!
    
    @IBOutlet weak var dwellTimeView: PieChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictionBarButtonItem.isEnabled = false
        view.bringSubview(toFront: loadingView)
        makeAllRequests()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(makeInfoRequests), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        predictionBarButtonItem.isEnabled = false
        predictionBarButtonItem.isEnabled = true
    }

    func makeTwoWeeksPrediction(type: String) {
        var currentPredDate = Date()
        for _ in 0...13 {
            currentPredDate = Calendar.current.date(byAdding: .day, value: +1, to: currentPredDate)!
            switch type {
            case "visitors" :
                MainData.predictionX.append(MainData.dateFormatter.string(from: currentPredDate))
                MainData.visualVisitorsPrediction.append(Int(StatisticsViewController.visitorsPrediction.makePrediction(predictDate: currentPredDate)))
            case "connected" :
                MainData.visualConnectedPrediction.append(Int(StatisticsViewController.connectedPrediction.makePrediction(predictDate: currentPredDate)))
            case "passersby" :
                MainData.visualPassersbyPrediction.append(Int(StatisticsViewController.passersbyPrediction.makePrediction(predictDate: currentPredDate)))
            default :
                return
            }
        }
    }

    func buildPredictionModels()
    {
        MainData.dateFormatter.dateFormat = "yyyy-MM-dd"
        let paramsPred = [
            "siteId" : MainData.siteId!,
            "startDate" : MainData.dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: -10, to: MainData.currentDay!)!),
            "endDate" : MainData.dateFormatter.string(from: MainData.currentDay!)
        ]
        request.paramJsonRequest(name: "visitorsPrediction", dopUrl: (timeParams["Custom"]?.1)!, param: paramsPred) { complete in
            if complete {
                StatisticsViewController.visitorsPrediction.buildModel(&MainData.visitorsPrediction) { complete in
                    if complete {
                        self.makeTwoWeeksPrediction(type: "visitors")
                    }
                }
            }
        }
        request.paramJsonRequest(name: "passersbyPrediction", dopUrl: (timeParams["Custom"]?.1)!, param: paramsPred) { complete in
            if complete {
                StatisticsViewController.passersbyPrediction.buildModel(&MainData.passersbyPrediction) { complete in
                    if complete {
                        self.makeTwoWeeksPrediction(type: "passersby")
                    }
                }
            }
        }
        request.paramJsonRequest(name: "connectedPrediction", dopUrl: (timeParams["Custom"]?.1)!, param: paramsPred) { complete in
            if complete {
                StatisticsViewController.connectedPrediction.buildModel(&MainData.connectedPrediction) { complete in
                    if complete {
                        self.makeTwoWeeksPrediction(type: "connected")
                    }
                }
            }
        }
    }
    
    func makeAllRequests() {
        // GET all maps
        request.jsonRequest(name: "floorInfo") { complete in
            if complete {
                for i in 0..<MainData.floorInfo.2.count {
                    let floorURL = "/\(MainData.floorInfo.0)/\(MainData.floorInfo.1)/\(MainData.floorInfo.2[i])"
                    self.request.dataRequest(name: "mapImg", floor: floorURL, index: i) { complete in
                        if complete {
                            if i == MainData.floorInfo.2.count - 1 {
                                self.loadingView.isHidden = true
                                self.tabBarController?.tabBar.isHidden = false
                                self.predictionBarButtonItem.isEnabled = true
                            }
                        }
                    }
                }
            }
        }
        
        // GET site id
        request.jsonRequest(name: "siteId") {complete in
            if complete {
                self.makeInfoRequests()
                self.buildPredictionModels()
            }
        }
    }

    @objc func makeInfoRequests() {
        self.defineDates()
        var params = [String: Any]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        switch MainData.timeStamp {
        case "Custom":
            params = [
                "siteId" : MainData.siteId!,
                "startDate" : dateFormatter.string(from: MainData.startDay),
                "endDate" : dateFormatter.string(from: MainData.endDay),
            ]
        case "hourly":
            params = [
                "siteId" : MainData.siteId!,
                "date" : dateFormatter.string(from: MainData.startDay)
            ]
        default:
            params = ["siteId" : MainData.siteId!]
        }

        //GET Main Information
        request.paramJsonRequest(name: "mainInfo", dopUrl: (timeParams[MainData.timeStamp]?.0)!, param: params) { complete in
            if complete {
                self.totalVisitors.text = MainData.mainInfo[0]
                self.dwellTime.text = MainData.mainInfo[1]
                self.peakHour.text = MainData.mainInfo[2]
                self.conversionRate.text = MainData.mainInfo[3]
                self.topDevice.text = MainData.mainInfo[4]
                
                self.proximityView.setChart(type: "Proximity", rawData: MainData.proximityDistribution)
                self.proximityGenView.setChart(type: "ProximityGen", rawData: MainData.proximityDistributionGen)
                self.dwellTimeView.setChart(type: "DwellTime", rawData: MainData.dwellTimeDistribution)
            }
        }
        
        // GET all clients
        request.jsonRequest(name: "clientsInfo") { complete in
            if complete {
                let nv = self.tabBarController?.selectedViewController as? UINavigationController
                if let vc = nv?.visibleViewController as? SearchViewController {
                    vc.macAddr.removeAll()
                    vc.macAddr.append(contentsOf: MainData.clientsInfo1stFloor)
                    vc.macAddr.append(contentsOf: MainData.clientsInfo2ndFloor)
                    vc.macAddr.append(contentsOf: MainData.clientsInfo3rdFloor)
                    vc.tableView.reloadData()
                }
            }
        }
        
        // GET Proximity
        request.paramJsonRequest(name: "passersby", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: params) { complete in
            if complete {
                self.request.paramJsonRequest(name: "visitors", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: params) { complete in
                    if complete {
                        self.request.paramJsonRequest(name: "connected", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: params) { complete in
                            if complete {
                                MainData.reloadCorr = 1
                                self.barView.drawChart()
                                StatisticsViewController.correlations.buildCorrelations(type: "connected")
                            }
                        }
                        StatisticsViewController.correlations.buildCorrelations(type: "visitors")
                    }
                }
                StatisticsViewController.correlations.buildCorrelations(type: "passersby")
            }
        }
        
        request.paramJsonRequest(name: "repeatVisitorsDistribution", dopUrl: (timeParams[MainData.timeStamp]?.0)!, param: params) { complete in
            if complete {
                self.repeatVisitorsView.setChart(type: "RepeatVisitors", rawData: MainData.repeatVisitorsDistribution)
            }
        }
        
        //GET Dwell Time
        request.paramJsonRequest(name: "dwellTime", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: params) { complete in
            if complete {
                MainData.reloadCorr = 1
                self.lineView.drawChartFill()
                StatisticsViewController.correlations.buildCorrelations(type: "dwellTime")
            }
        }
        
        // GET Repeat Visitors
        request.paramJsonRequest(name: "repeatVisitors", dopUrl: (timeParams[MainData.timeStamp]?.1)!, param: params) { complete in
            if complete {
                self.secondLineView.drawChart()
            }
        }
    }

    func defineDates() {
        MainData.currentDay = Date()
        var components = Calendar.current.dateComponents([.year, .month], from: MainData.currentDay!)
        switch MainData.timeStamp {
        case "Last 7 days" :
            MainData.startDay = Calendar.current.date(byAdding: .day, value: -7, to: MainData.currentDay!)!
            MainData.endDay = MainData.currentDay!
        case "Last 30 days" :
            MainData.startDay = MainData.currentDay!
            MainData.endDay = Calendar.current.date(byAdding: .month, value: -1, to: MainData.currentDay!)!
        case "This month" :
            MainData.startDay = Calendar.current.date(from: components)!
            MainData.endDay = MainData.currentDay!
            MainData.timeStamp = "Custom"
        case "Last month" :
            components.month = components.month! - 1
            MainData.startDay = Calendar.current.date(from: components)!
            components.month = components.month! + 1
            components.day = 1
            components.day = components.day! - 1
            MainData.endDay = Calendar.current.date(from: components)!
            MainData.timeStamp = "Custom"
        default:
            return
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopupViewController" {
            let pvc = segue.destination as! PopupViewController
            pvc.custom = true
        }
    }
}

extension StatisticsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: self.pickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        MainData.timeStamp = self.pickerData[row]
        switch self.pickerData[row] {
        case "Custom":
            self.performSegue(withIdentifier: "PopupViewController", sender: self)
        default:
            self.navigationItem.title = nil
            self.makeInfoRequests()
        }
    }
}
