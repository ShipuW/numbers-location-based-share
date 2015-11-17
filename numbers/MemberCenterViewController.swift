//
//  MemberCenterViewController.swift
//  numbers
//
//  Created by admin on 4/14/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

class MemberCenterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TappedLogoutButton(sender: UIButton) {
        userDefaults.setObject("", forKey: "userNameKey")
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
