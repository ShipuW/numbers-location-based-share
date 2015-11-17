//
//  ReportViewController.swift
//  numbers
//
//  Created by admin on 5/23/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//
import UIKit

class ReportViewController: UIViewController {
    var reportMessageId:Int?
    
    
    @IBOutlet var backGroundView: UIView!
    @IBOutlet weak var backGroundImage: UIImageView!

    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var buttonSend: UIButton!
    
    override func viewDidLoad() {
        self.backGroundView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        super.viewDidLoad()
        
        var inset = UIEdgeInsetsMake(CGFloat(25), CGFloat(25), CGFloat(25), CGFloat(25))
        backGroundImage.image = backGroundImage.image?.resizableImageWithCapInsets(inset)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapped1(sender: UIButton) {
        button1.setImage(UIImage(named: "radio_checked"), forState: UIControlState.Normal)
        button2.setImage(nil, forState: UIControlState.Normal)
        button3.setImage(nil, forState: UIControlState.Normal)
        button4.setImage(nil, forState: UIControlState.Normal)
        
    }
    
    @IBAction func tapped2(sender: UIButton) {
        button2.setImage(UIImage(named: "radio_checked"), forState: UIControlState.Normal)
        button1.setImage(nil, forState: UIControlState.Normal)
        button3.setImage(nil, forState: UIControlState.Normal)
        button4.setImage(nil, forState: UIControlState.Normal)
    }

    @IBAction func tapped3(sender: UIButton) {
        button3.setImage(UIImage(named: "radio_checked"), forState: UIControlState.Normal)
        button2.setImage(nil, forState: UIControlState.Normal)
        button1.setImage(nil, forState: UIControlState.Normal)
        button4.setImage(nil, forState: UIControlState.Normal)
    }
    
    @IBAction func tapped4(sender: UIButton) {
        button4.setImage(UIImage(named: "radio_checked"), forState: UIControlState.Normal)
        button2.setImage(nil, forState: UIControlState.Normal)
        button3.setImage(nil, forState: UIControlState.Normal)
        button1.setImage(nil, forState: UIControlState.Normal)
    }
    
    @IBAction func tappedSend(sender: UIButton) {
        var reportObject=AVObject(className: "Report")
        
        if userDefaults.stringForKey("userNameKey") != nil {
            var nameQuery=AVQuery(className: "_User")
            nameQuery.whereKey("username", equalTo: userDefaults.stringForKey("userNameKey"))
            var nameGet=nameQuery.getFirstObject()
            reportObject.setObject(nameGet, forKey: "user")
        }
        
        if button1.imageView?.image != nil {
            reportObject.setObject("色情", forKey: "type")
        
        }else if button2.imageView?.image != nil {
            reportObject.setObject("暴力", forKey: "type")
            
        }else if button3.imageView?.image != nil {
            reportObject.setObject("广告", forKey: "type")
        }else{
            reportObject.setObject("其他", forKey: "type")
        }
        
        var messageQuery=AVQuery(className: "Content")
        messageQuery.whereKey("contentId", equalTo: reportMessageId)
        var messageResult=messageQuery.getFirstObject()
        reportObject.setObject(messageResult, forKey: "content")
    }
    
}

