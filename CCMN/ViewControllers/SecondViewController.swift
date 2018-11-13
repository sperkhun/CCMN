//
//  SecondViewController.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/6/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var macAddr: [(macAddr: String, x: Int, y: Int, status: String)] = []
    
    @IBOutlet weak var firstBut: UIButton! {
        willSet {
            newValue.setTitle(MainData.floorInfo.2[0], for: .normal)
        }
    }
    @IBOutlet weak var secondBut: UIButton! {
        willSet {
            newValue.setTitle(MainData.floorInfo.2[1], for: .normal)
        }
    }
    @IBOutlet weak var thirdBut: UIButton! {
        willSet {
            newValue.setTitle(MainData.floorInfo.2[2], for: .normal)
        }
    }
    
    @IBAction func showMap(_ sender: Any) {
        performSegue(withIdentifier: "ThirdViewController", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        macAddr.append(contentsOf: MainData.clientsInfo1stFloor)
        macAddr.append(contentsOf: MainData.clientsInfo2ndFloor)
        macAddr.append(contentsOf: MainData.clientsInfo3rdFloor)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return macAddr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "macCell")
        cell?.textLabel?.text = macAddr[indexPath.row].macAddr
        return cell!
    }

    func defineFloorByMacAddr(macAddr: String) -> String {
        var count = MainData.clientsInfo1stFloor.count
        for i in 0...count-1
        {
            if (MainData.clientsInfo1stFloor[i].0 == macAddr) {
                return ("MAC " + macAddr + " now is on the 1st floor." )
            }
        }
        count = MainData.clientsInfo2ndFloor.count
        for i in 0...count-1
        {
            if (MainData.clientsInfo2ndFloor[i].0 == macAddr) {
                return ("MAC " + macAddr + " now is on the 2nd floor." )
            }
        }
        count = MainData.clientsInfo3rdFloor.count
        for i in 0...count-1
        {
            if (MainData.clientsInfo3rdFloor[i].0 == macAddr) {
               return ("MAC " + macAddr + " now is on the 3rd floor." )
            }
        }
        return ("MAC " + macAddr + " now is on the other place.")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThirdViewController" {
            let but = sender as! UIButton
            let tvc = segue.destination as! ThirdViewController
            tvc.image = MainData.mapsImg[Int(but.restorationIdentifier!)!]
            if Int(but.restorationIdentifier!)! == 0 {
                tvc.clients = MainData.clientsInfo1stFloor
            }
            else if Int(but.restorationIdentifier!)! == 1 {
                tvc.clients = MainData.clientsInfo2ndFloor
            }
            else {
                tvc.clients = MainData.clientsInfo3rdFloor
            }
        }
        else if segue.identifier == "PopupViewController" {
            let cell = sender as! UITableViewCell
            let pvc = segue.destination as! PopupViewController
            pvc.message = self.defineFloorByMacAddr(macAddr: (cell.textLabel?.text)!)
        }
    }

}

extension SecondViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text!.lowercased()
        searchTextInBar(text)
    }
    
    func searchTextInBar(_ str: String) {
        var i = 0
        
        if (str != "") {
            let arr = macAddr
            macAddr = []
            while i < arr.count {
                if (arr[i].macAddr.lowercased().contains(str)) {
                    self.macAddr.append(arr[i])
                }
                i += 1
            }
//            filterArr = filterArr.sorted()
        } else {
            macAddr.append(contentsOf: MainData.clientsInfo1stFloor)
            macAddr.append(contentsOf: MainData.clientsInfo2ndFloor)
            macAddr.append(contentsOf: MainData.clientsInfo3rdFloor)
        }
        tableView.reloadData()
    }
    
}
