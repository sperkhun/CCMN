//
//  MainData.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/5/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

struct MainData {
    
    static let username = "RO"
    static let passw1 = "just4reading"
    static let passw2 = "Passw0rd"
    
    //startDay, endDay - for time periods: current month, last month, last week, custom period
    static var startDay : Date = Date()
    static var endDay : Date = Date()
    static var proximityX = [String]()
    static var dwellX = [String]()
    static var repeatX = [String]()
    //определяем при нажатии кнопки для выбора даты
    static var timeStamp : String = "Today"
    static var clientsNumber = 0
    static var mainInfo: [String] = []
    static var floorInfo = (campus: String(), building: String(), floor: [String]())
    static var mapsImg: [UIImage] = []
    
    static var clientsInfo1stFloor: [(macAddr: String, x: Int, y: Int, status: String)] = []
    static var clientsInfo2ndFloor: [(macAddr: String, x: Int, y: Int, status: String)] = []
    static var clientsInfo3rdFloor: [(macAddr: String, x: Int, y: Int, status: String)] = []
    
    static var siteId: String?
    static var currentDay : Date?

    static var parametrs = Dictionary<String, Any>()
    //static var parametrs : [String:Any] = ["siteId" : "1513804707441"]
    
    static var repeatVisitors : [(date: String, hour: Int, daily: Int, weekly: Int, occas: Int, firstTime: Int, yesterday: Int)] = []
    static var dwellTime : [(date: String, hour: Int, fiveThirtyMin: Int, thirtySixtyMin: Int, oneFiveHour: Int, fiveEightHour: Int, eightPlusHour: Int)] = []
    static var passersby : [(date: String, hour: Int, qty: Int)] = []
    static var visitors : [(date: String, hour: Int, qty: Int)] = []
    static var connected : [(date: String, hour: Int, qty: Int)] = []
    
    static var proximityDistribution : (visitors: Int, passerby: Int, connected: Int) = (0, 0, 0)
    static var dwellTimeDistribution : (Int, Int, Int, Int, Int) = (0, 0, 0, 0, 0)
    static var repeatVisitorsDistribution : (daily: Int, weekly: Int, occasional: Int, firstTime: Int, yesterday: Int) = (0, 0, 0, 0, 0)
}

var requests : [String : (url: String, password: String)] = [
    "siteId" : ("https://cisco-presence.unit.ua/api/config/v1/sites", "Passw0rd"),
    "mainInfo" : ("https://cisco-presence.unit.ua/api/presence/v1/kpisummary", "Passw0rd") ,
    "floorInfo" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/count", "just4reading"),
    
    "mapImg" : ("https://cisco-cmx.unit.ua/api/config/v1/maps/image", "just4reading"),
    
    "clientsInfo" : ("https://cisco-cmx.unit.ua/api/location/v2/clients", "just4reading"),
   
    "searchMac" : ("https://cisco-cmx.unit.ua/api/location/v2/clients", "just4reading"),
    
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
    
//    //**************REPEAT_VISITORS_DISTRIBUTION
    "repeatVisitorsDistribution" : ("https://cisco-presence.unit.ua/api/presence/v1/repeatvisitors/count", "Passw0rd")
]

var timeParams : [String : (String, String)] = [
    "Today" : ("/today", "/hourly/today"),
    "Yesterday" : ("/yesterday", "/hourly/yesterday"),
    "Last 3 days" : ("/3days", "/hourly/3days"),
    "Last 7 days" : ("/lastweek", "/daily/lastweek"),
    "Last 30 days" : ("/lastmonth", "/daily/lastmonth"),
    "daily" : ("/insights", "/daily")
]

var timeStamps = ["today", "yesterday", "3days", "lastweek", "lastmonth", "daily"]
