//
//  Parser.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/6/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import SwiftyJSON

class Parser {

    func mapImg(imageData: Any?){
        MainData.mapsImg.append(UIImage(data: imageData as! Data, scale:1.0)!)
    }
    
    func parseAll(name: String, data: Any?) {
        switch name {

        case "siteId":
            siteId(json: JSON(data!))
        case "floorInfo":
            floorInfo(json: JSON(data!))
        case "clientsInfo":
            clientsInfo(json: JSON(data!))
        default:
            return
        }
    }
    
    func paramParseAll(name: String, timeStamp: String, data: Any?) {
        switch name {
        case "mainInfo":
            mainInfo(json: JSON(data!))
        case "repeatVisitorsDistribution":
            repeatVisitorsDistribution(json: JSON(data!))
        case "repeatVisitors":
            repeatVisitors(timeStamp: timeStamp, json: JSON(data!))
        case "dwellTime":
            dwellTime(timeStamp: timeStamp, json: JSON(data!))
        case "passersby", "visitors", "connected":
            proximity(type: name, timeStamp: timeStamp, json: JSON(data!))
//        case "searchMac"
//
        default:
            return
        }
    }
    
    func mainInfo(json: JSON) {
        
        //****Main Info
        MainData.mainInfo.removeAll()
        MainData.mainInfo.append("\(json["totalVisitorCount"])")
        MainData.mainInfo.append("\(json["averageDwell"].int!) mins ")
        MainData.mainInfo.append(makeHour(hour: json["peakSummary"]["peakHour"].int!))
        MainData.mainInfo.append("\(json["conversionRate"])%")
        MainData.mainInfo.append("\(json["topManufacturers"]["name"])")
        
        //****Info for Diagram proximityDistribution
        MainData.proximityDistribution.visitors = json["totalVisitorCount"].int!
        MainData.proximityDistribution.passerby = json["totalPasserbyCount"].int!
        MainData.proximityDistribution.connected = json["totalConnectedCount"].int!
        
        //****Info for Diagram TimeDistribution
        MainData.dwellTimeDistribution.0 = json["averageDwellByLevels"]["FIVE_TO_THIRTY_MINUTES"]["count"].int!
        MainData.dwellTimeDistribution.1 = json["averageDwellByLevels"]["THIRTY_TO_SIXTY_MINUTES"]["count"].int!
        MainData.dwellTimeDistribution.2 = json["averageDwellByLevels"]["ONE_TO_FIVE_HOURS"]["count"].int!
        MainData.dwellTimeDistribution.3 = json["averageDwellByLevels"]["FIVE_TO_EIGHT_HOURS"]["count"].int!
        MainData.dwellTimeDistribution.4 = json["averageDwellByLevels"]["EIGHT_PLUS_HOURS"]["count"].int!
    }

    func repeatVisitorsDistribution(json: JSON) {
        MainData.repeatVisitorsDistribution.daily = json["DAILY"].int!
        MainData.repeatVisitorsDistribution.weekly = json["WEEKLY"].int!
        MainData.repeatVisitorsDistribution.occasional = json["OCCASIONAL"].int!
        MainData.repeatVisitorsDistribution.firstTime = json["FIRST_TIME"].int!
        MainData.repeatVisitorsDistribution.yesterday = json["YESTERDAY"].int!
    }
    
    func siteId(json: JSON){
        MainData.siteId = json[0]["aesUidString"].string
        print (MainData.siteId!)
    }
    
    func floorInfo(json: JSON){
        MainData.floorInfo.0 = json["campusCounts"][2]["campusName"].string!
        MainData.floorInfo.1 = json["campusCounts"][2]["buildingCounts"][0]["buildingName"].string!
        MainData.floorInfo.2.append("\(json["campusCounts"][2]["buildingCounts"][0]["floorCounts"][2]["floorName"])")
        MainData.floorInfo.2.append("\(json["campusCounts"][2]["buildingCounts"][0]["floorCounts"][1]["floorName"])")
        MainData.floorInfo.2.append("\(json["campusCounts"][2]["buildingCounts"][0]["floorCounts"][0]["floorName"])")
        MainData.floorInfo.2.sort()
//        print(MainData.floorInfo.0 + " " +  MainData.floorInfo.1 + " " + MainData.floorInfo.2[0])
//         print(MainData.floorInfo.0 + " " +  MainData.floorInfo.1 + " " + MainData.floorInfo.2[1])
//         print(MainData.floorInfo.0 + " " +  MainData.floorInfo.1 + " " + MainData.floorInfo.2[2])
    }
    
//    func defFloor(name: String) -> Int{
//        switch name{
//        case "System Campus>UNIT.Factory>1st_Floor>1st_floor":
//            return 1
//        case "System Campus>UNIT.Factory>2nd_Floor>2nd_floor":
//            return 2
//        case "System Campus>UNIT.Factory>3rd_Floor>3rd_floor":
//            return 3
//        default:
//            return 0
//        }
//    }
    
    func clientsInfo(json: JSON){
        let count = json.count
        MainData.clientsInfo1stFloor.removeAll()
        MainData.clientsInfo2ndFloor.removeAll()
        MainData.clientsInfo3rdFloor.removeAll()
        for i in 0...count - 1{
            let floor = json[i]["mapInfo"]["mapHierarchyString"].string!
            switch floor {
            case "System Campus>UNIT.Factory>1st_Floor>1st_floor", "System Campus>UNIT.Factory>1st_Floor" :
                MainData.clientsInfo1stFloor.append(("\(json[i]["macAddress"])", json[i]["mapCoordinate"]["x"].int!, json[i]["mapCoordinate"]["y"].int!, json[i]["dot11Status"].string!))
            case "System Campus>UNIT.Factory>2nd_Floor>2nd_floor", "System Campus>UNIT.Factory>2nd_Floor" :
                MainData.clientsInfo2ndFloor.append(("\(json[i]["macAddress"])", json[i]["mapCoordinate"]["x"].int!, json[i]["mapCoordinate"]["y"].int!, json[i]["dot11Status"].string!))
            case "System Campus>UNIT.Factory>3rd_Floor>3rd_floor", "System Campus>UNIT.Factory>3rd_Floor" :
                MainData.clientsInfo3rdFloor.append(("\(json[i]["macAddress"])", json[i]["mapCoordinate"]["x"].int!, json[i]["mapCoordinate"]["y"].int!, json[i]["dot11Status"].string!))
            default:
                return
            }
        }
    }

    func repeatVisitors(timeStamp: String, json: JSON) {
        let sortedResults = json.sorted(by: < )
        MainData.repeatX.removeAll()
        MainData.repeatVisitors.removeAll()
        switch timeStamp {
        case "Today", "Yesterday": do {
            let count : Int = json.count
            for i in 0...count - 1{
                MainData.repeatX.append(makeHour(hour: i))
                MainData.repeatVisitors.append(("0", i, json["\(i)"]["DAILY"].int!, json["\(i)"]["WEEKLY"].int!, json["\(i)"]["OCCASIONAL"].int!, json["\(i)"]["FIRST_TIME"].int!, json["\(i)"]["YESTERDAY"].int!))
            }
        }
        case "Last 3 days": do {
            var str = ""
            for (key) : (String, JSON) in sortedResults {
                let count : Int = key.1.count
                for i in 0...count - 1{
                    if str != key.0 {
                        str = key.0
                        MainData.repeatX.append(key.0)
                    }
                    else {
                        MainData.repeatX.append(makeHour(hour: i))
                    }
                    MainData.repeatVisitors.append((key.0, i, key.1["\(i)"]["DAILY"].int!, key.1["\(i)"]["WEEKLY"].int!, key.1["\(i)"]["OCCASIONAL"].int!, key.1["\(i)"]["FIRST_TIME"].int!, key.1["\(i)"]["YESTERDAY"].int!))
                }
            }
        }
        case "Last 7 days", "Last 30 days", "daily" : do {
            let sortedResults = json.sorted(by: < )
            for (key) : (String, JSON) in sortedResults {
                MainData.repeatX.append(key.0)
                MainData.repeatVisitors.append((key.0, 0, key.1["DAILY"].int!, key.1["WEEKLY"].int!, key.1["OCCASIONAL"].int!, key.1["FIRST_TIME"].int!, key.1["YESTERDAY"].int!))
                }
            }
        default:
            return
        }
    }

    func dwellTime(timeStamp: String, json: JSON) {
        let sortedResults = json.sorted(by: < )
        MainData.dwellX.removeAll()
        MainData.dwellTime.removeAll()
        switch timeStamp {
        case "Today", "Yesterday": do {
            let count : Int = json.count
            for i in 0...count - 1{
                MainData.dwellX.append(makeHour(hour: i))
                MainData.dwellTime.append(("0", i, json["\(i)"]["FIVE_TO_THIRTY_MINUTES"].int!, json["\(i)"]["THIRTY_TO_SIXTY_MINUTES"].int!, json["\(i)"]["ONE_TO_FIVE_HOURS"].int!, json["\(i)"]["FIVE_TO_EIGHT_HOURS"].int!, json["\(i)"]["EIGHT_PLUS_HOURS"].int!))
                }
            }
        case "Last 3 days": do {
            var str = ""
            for (key) : (String, JSON) in sortedResults {
                let count : Int = key.1.count
                for i in 0...count - 1{
                    if str != key.0 {
                        str = key.0
                        MainData.dwellX.append(key.0)
                    }
                    else {
                        MainData.dwellX.append(makeHour(hour: i))
                    }
                    MainData.dwellTime.append((key.0, i, key.1["\(i)"]["FIVE_TO_THIRTY_MINUTES"].int!, key.1["\(i)"]["THIRTY_TO_SIXTY_MINUTES"].int!, key.1["\(i)"]["ONE_TO_FIVE_HOURS"].int!, key.1["\(i)"]["FIVE_TO_EIGHT_HOURS"].int!, key.1["\(i)"]["EIGHT_PLUS_HOURS"].int!))
                    }
                }
            }
            print(MainData.dwellTime)
        case "Last 7 days", "Last 30 days", "daily" : do {
            for (key) : (String, JSON) in sortedResults {
                MainData.dwellX.append(key.0)
                MainData.dwellTime.append((key.0, 0, key.1["FIVE_TO_THIRTY_MINUTES"].int!, key.1["THIRTY_TO_SIXTY_MINUTES"].int!, key.1["ONE_TO_FIVE_HOURS"].int!, key.1["FIVE_TO_EIGHT_HOURS"].int!, key.1["EIGHT_PLUS_HOURS"].int!))
                }
            }
        default:
            return
        }
    }

    func proximity(type: String, timeStamp: String, json: JSON) {
        let sortedResults = json.sorted(by: < )
        switch type {
        case "passersby" :
            MainData.proximityX.removeAll()
            MainData.passersby.removeAll()
        case "visitors" :
            MainData.visitors.removeAll()
        case "connected" :
            MainData.connected.removeAll()
        default:
            return
        }
        switch timeStamp {
        case "Today", "Yesterday" : do {
            let count : Int = json.count
            for i in 0...count - 1{
                switch type {
                case "passersby" :
                    MainData.proximityX.append(makeHour(hour: i))
                    MainData.passersby.append(("0", i, json["\(i)"].int!))
                case "visitors" :
                    MainData.visitors.append(("0", i, json["\(i)"].int!))
                case "connected" :
                    MainData.connected.append(("0", i, json["\(i)"].int!))
                default:
                    return
                }
            }
            }
        case "Last 3 days": do {
            for (key) : (String, JSON) in sortedResults {
                let count : Int = key.1.count
                var str = ""
                for i in 0...count - 1{
                    switch type {
                    case "passersby" :
                        if str != key.0 {
                            str = key.0
                            MainData.proximityX.append(key.0)
                        }
                        else {
                            MainData.proximityX.append(makeHour(hour: i))
                        }
                        MainData.passersby.append((key.0, i, key.1["\(i)"].int!))
                    case "visitors" :
                        MainData.visitors.append((key.0, i, key.1["\(i)"].int!))
                    case "connected" :
                        MainData.connected.append((key.0, i, key.1["\(i)"].int!))
                    default :
                        return
                    }
                }
            }
            }
        case "Last 7 days", "Last 30 days", "daily" : do {
            for (key) : (String, JSON) in sortedResults {
                switch type {
                case "passersby" :
                    MainData.proximityX.append(key.0)
                    MainData.passersby.append((key.0, 0, key.1.int!))
                case "visitors" :
                    MainData.visitors.append((key.0, 0, key.1.int!))
                case "connected" :
                    MainData.connected.append((key.0, 0, key.1.int!))
                default :
                    return
                }
                //            let count = MainData.passersby.count
                //            for i in 0...count - 1{
                //                print(MainData.passersby[i].0)
                //                 print(MainData.passersby[i].1)
                //                 print(MainData.passersby[i].2)
                //            }
            }
            }
        default:
            return
        }
    }
    
    func makeHour(hour: Int) -> String {
        let h = hour % 24

        if h == 0 {
            return "12am-1am"
        }
        else if h == 11 {
            return "11am-12pm"
        }
        else if h == 12 {
            return "12pm-1pm"
        }
        else if h == 23 {
            return "11pm-12am"
        }
        else if h < 11 {
            return "\(h)am-\(h+1)am"
        }
        else {
            return "\(h%12)pm-\(h%12+1)pm"
        }
    }
}
