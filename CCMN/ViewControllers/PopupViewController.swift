//
//  PopupViewController.swift
//  CCMN
//
//  Created by Serhii PERKHUN on 11/10/18.
//  Copyright © 2018 Serhii PERKHUN. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    var custom: Bool?
    
    // Message view
    @IBOutlet weak var popupView: UIView! {
        willSet {
            newValue.layer.borderWidth = 1
            newValue.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var macLabel: UILabel!
    var message: String?
    
    // Date pickers view
    @IBOutlet weak var dateView: UIView! {
        willSet {
            newValue.layer.borderWidth = 1
            newValue.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var fromDate: UIDatePicker! {
        willSet {
            newValue.maximumDate = Date()
        }
    }
    @IBOutlet weak var toDate: UIDatePicker! {
        willSet {
            newValue.maximumDate = Date()
            newValue.minimumDate = Date()
        }
    }
    
    @IBAction func fromDate(_ sender: UIDatePicker) {
        MainData.startDay = sender.date
        toDate.minimumDate = sender.date
    }
    @IBAction func toDate(_ sender: UIDatePicker) {
        MainData.endDay = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if custom == true {
            self.popupView.isHidden = true
            self.dateView.isHidden = false
            fromDate.setValue(UIColor.white, forKey: "textColor")
            toDate.setValue(UIColor.white, forKey: "textColor")
        }
        else {
            self.popupView.isHidden = false
            self.dateView.isHidden = true
            macLabel.text = message
        }
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        
        let vc = presentingViewController as? UITabBarController
        let nc = vc?.viewControllers![0] as? UINavigationController
        if let fvc = nc?.viewControllers[0] as? StatisticsViewController{
            if MainData.startDay == MainData.endDay {
                MainData.timeStamp = "hourly"
                fvc.navigationItem.title = MainData.dateFormatter.string(from: MainData.startDay)
            }
            else {
                fvc.navigationItem.title = MainData.dateFormatter.string(from: MainData.startDay) + " to " + MainData.dateFormatter.string(from: MainData.endDay)
            }
            fvc.makeInfoRequests()
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MainData.startDay = Date()
        MainData.endDay = MainData.startDay
    }
}
