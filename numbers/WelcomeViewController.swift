//
//  WelcomeViewController.swift
//  numbers
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController,UIAlertViewDelegate {
    
    var succeedAlert = UIAlertView(title: "的墙", message: "保存成功", delegate: "", cancelButtonTitle: "返回")
    var errorConnectionAlert=UIAlertView(title: "的墙", message: "网络错误", delegate: "", cancelButtonTitle: "返回")
    
    var roomStatus:Int = 0 //0没有房间，1有房间没欢迎语，2有房间有欢迎语
    var recordId:String=""
    @IBOutlet weak var welcomeText: UITextView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var numbersWelcome: UILabel!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 249/255.0, green: 67/255.0, blue: 94/255.0, alpha: 1)
        super.viewDidLoad()
        
        
        
        
        succeedAlert.delegate=self
        errorConnectionAlert.delegate=self
        
        
        
        numbersWelcome.text = currentNumber
        self.mainView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        var welcomeQuery=AVQuery(className: "Room")
        welcomeQuery.whereKey("number", equalTo: currentNumber)
        var welcomes = welcomeQuery.findObjects()
        welcomeQuery.findObjectsInBackgroundWithBlock { welcomes, welcomeerror -> Void in
            if welcomeerror != nil {
                self.errorConnectionAlert.show()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                if welcomes.count != 0 {
                    for wobj in welcomes{
                        
                        println(wobj.objectForKey("welcome"))
                            
                        if wobj.objectForKey("welcome") != nil {
                            self.roomStatus=3
                            self.welcomeText.text = wobj.objectForKey("welcome") as! String
                            //recordId=wobj.objectForKey("objectId") as! String
                            println(self.roomStatus)
                        }else{
                            
                            self.roomStatus=1
                            self.welcomeText.text = "欢迎来到一串数字的世界"
                            println(self.roomStatus)
                        }
                        self.recordId=wobj.objectForKey("objectId") as! String
                    }
                }else{
                    self.roomStatus=0
                    self.welcomeText.text="还没有人来过这里哦"
                }
                self.welcomeText.reloadInputViews()
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        println("buttonIndex:\(buttonIndex)")
        if buttonIndex == 0 {
            
           // self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WelcomeToContent" {
            if roomStatus == 0 {
                roomStatus=3
                var welcomeObject=AVObject(className: "Room")
                welcomeObject.setObject(currentNumber, forKey: "number")
                if welcomeText.text != "还没有人来过这里哦"{//如果没改下次也不显示这句话
                    welcomeObject.setObject(welcomeText.text, forKey: "welcome")
                }
                welcomeObject.save()
                recordId=welcomeObject.objectForKey("objectId") as! String
                
            }else{
                var updateResult=AVQuery.getObjectOfClass("Room", objectId: recordId)
                updateResult.setObject(welcomeText.text, forKey: "welcome")
                updateResult.save()
                
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 249/255.0, green: 67/255.0, blue: 94/255.0, alpha: 1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveWelcomeButton(sender: UIButton) {
        if roomStatus == 0 {
            roomStatus=3
            var welcomeObject=AVObject(className: "Room")
            welcomeObject.setObject(currentNumber, forKey: "number")
            welcomeObject.setObject(welcomeText.text, forKey: "welcome")
            welcomeObject.save()
            recordId=welcomeObject.objectForKey("objectId") as! String
            self.succeedAlert.show()
        }else{
            var updateResult=AVQuery.getObjectOfClass("Room", objectId: recordId)
            updateResult.setObject(welcomeText.text, forKey: "welcome")
            updateResult.save()
            self.succeedAlert.show()

        }
        
    }
  

}

