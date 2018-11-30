//
//  MainData.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/5/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

struct MainData {
    
    static var dataPoints : [String] = ["Mon", "Tue", "Wed", "Thur", "Fr", "Sat", "Sun"]
    static let username = "RO"
    static let dateFormatter = DateFormatter()
    static var siteId: String?
    
    //startDay, endDay - for time periods: current month, last month, last week, custom period
    static var startDay : Date = Date()
    static var endDay : Date = Date()
    static var predictDate : Date = Date()
    static var currentDay : Date?
    //list of X-axis values
    static var proximityX = [String]()
    static var dwellX = [String]()
    static var repeatX = [String]()
    static var predictionX : [String] = []
    static var reloadCorr = 1
    //define by choosing the date
    static var timeStamp : String = "Today"
    static var clientsNumber = 0
    static var mainInfo: [String] = []
    static var floorInfo = (campus: String(), building: String(), floor: [String]())
    static var mapsImg: [UIImage?] = Array(repeating: nil, count: 3)
    
    static var clientsInfo1stFloor: [(macAddr: String, x: Int, y: Int, status: String)] = []
    static var clientsInfo2ndFloor: [(macAddr: String, x: Int, y: Int, status: String)] = []
    static var clientsInfo3rdFloor: [(macAddr: String, x: Int, y: Int, status: String)] = []

    static var repeatVisitors : [(date: String, hour: Int, daily: Int, weekly: Int, occas: Int, firstTime: Int, yesterday: Int)] = []
    static var dwellTime : [(date: String, hour: Int, fiveThirtyMin: Int, thirtySixtyMin: Int, oneFiveHour: Int, fiveEightHour: Int, eightPlusHour: Int)] = []
    static var passersby : [(date: String, hour: Int, qty: Int)] = []
    static var visitors : [(date: String, hour: Int, qty: Int)] = []
    static var connected : [(date: String, hour: Int, qty: Int)] = []
    
    static var visitorsPrediction : [(date: String, hour: Int, qty: Int)] = []
    static var passersbyPrediction : [(date: String, hour: Int, qty: Int)] = []
    static var connectedPrediction : [(date: String, hour: Int, qty: Int)] = []
    
    static var visitorsPredicted : Int = 0
    static var passersbyPredicted : Int = 0
    static var connectedPredicted : Int = 0
    //data for prediction charts
    static var visualVisitorsPrediction : [Int] = []
    static var visualPassersbyPrediction : [Int] = []
    static var visualConnectedPrediction : [Int] = []
    
    static var proximityDistribution : [Int] = []
    static var proximityDistributionGen : [Int] = []
    static var dwellTimeDistribution : [Int] = []
    static var repeatVisitorsDistribution : [Int] = []
}

var requests : [String : (url: String, password: String)] = [
    "siteId" : ("https://cisco-presence.unit.ua/api/config/v1/sites", "Passw0rd"),
    "mainInfo" : ("https://cisco-presence.unit.ua/api/presence/v1/kpisummary", "Passw0rd") ,
    "floorInfo" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/count", "just4reading"),
    "mapImg" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/image", "just4reading"),
    "clientsInfo" : ("https://cisco-cmx.unit.ua/api/location/v2/clients", "just4reading"),
    
    //**************REPEAT VISITORS
    "repeatVisitors" : ("https://cisco-presence.unit.ua/api/presence/v1/repeatvisitors", "Passw0rd"),

    //**************DWELL TIME
    "dwellTime" : ("https://cisco-presence.unit.ua/api/presence/v1/dwell", "Passw0rd"),
   
    //**************PASSERSBY
    "passersby" : ("https://cisco-presence.unit.ua/api/presence/v1/passerby", "Passw0rd"),
    
    //**************VISITORS
     "visitors" : ("https://cisco-presence.unit.ua/api/presence/v1/visitor", "Passw0rd"),
    
    //**************CONNECTED
    "connected" : ("https://cisco-presence.unit.ua/api/presence/v1/connected", "Passw0rd"),
    
    //**************REPEAT_VISITORS_DISTRIBUTION
    "repeatVisitorsDistribution" : ("https://cisco-presence.unit.ua/api/presence/v1/repeatvisitors/count", "Passw0rd"),
    
    //*************PREDICTION
    "visitorsPrediction" : ("https://cisco-presence.unit.ua/api/presence/v1/visitor", "Passw0rd"),
    "passersbyPrediction" : ("https://cisco-presence.unit.ua/api/presence/v1/passerby", "Passw0rd"),
    "connectedPrediction" : ("https://cisco-presence.unit.ua/api/presence/v1/connected", "Passw0rd")
]

var timeParams : [String : (String, String)] = [
    "Today" : ("/today", "/hourly/today"),
    "Yesterday" : ("/yesterday", "/hourly/yesterday"),
    "Last 3 days" : ("/3days", "/hourly/3days"),
    "Last 7 days" : ("/lastweek", "/daily/lastweek"),
    "Last 30 days" : ("/lastmonth", "/daily/lastmonth"),
    "Custom" : ("", "/daily"),
    "hourly" : ("", "/hourly")
]
