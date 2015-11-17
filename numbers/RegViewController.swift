//
//  RegViewController.swift
//  numbers
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit




class RegViewController: UIViewController {/////////////////这是登陆controller！！！！
    
    
    
    var notCompleteAlert = UIAlertView(title: "错误", message: "信息输入不完整", delegate: "", cancelButtonTitle: "继续输入")
    var notExistAlert = UIAlertView(title: "错误", message: "用户不存在", delegate: "", cancelButtonTitle: "返回")
    var wrongPwdAlert = UIAlertView(title: "错误", message: "密码错误", delegate: "", cancelButtonTitle: "返回")
    var succeedLoginAlert = UIAlertView(title: "登陆成功", message: "", delegate: "", cancelButtonTitle: "返回")
    
    var connectionAlert = UIAlertView(title: "错误", message: "请检查网络", delegate: "", cancelButtonTitle: "返回")
    var completionAlert = UIAlertView(title: "错误", message: "请输入完整手机号", delegate: "", cancelButtonTitle: "返回")
    var existAlert = UIAlertView(title: "错误", message: "手机已注册", delegate: "", cancelButtonTitle: "返回")
    var sendAlert = UIAlertView(title: "注意", message: "短信已发送", delegate: "", cancelButtonTitle: "返回")
    var codeAlert = UIAlertView(title: "错误", message: "验证码错误", delegate: "", cancelButtonTitle: "返回")
    var succeedAlert = UIAlertView(title: "成功", message: "注册成功", delegate: "", cancelButtonTitle: "返回")
    var initTime=Int(60)
    
    var verifyTimmer=NSTimer()
    
    var countTimmer=NSTimer()
    
    
    @IBOutlet weak var backCount: UILabel!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)//设置主背景颜色
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: "SwipeBack")
        swipeBack.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeBack)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedSendVerifyButton(sender: UIButton) {
        println("press")
        if count(self.phoneNumberField.text) != 11{
            completionAlert.show()
        }else{
            
            
            
            var phoneQuery = AVQuery(className: "_User")
            
            
            phoneQuery.whereKey("username", equalTo: self.phoneNumberField.text)
            
            phoneQuery.findObjectsInBackgroundWithBlock {phoneObjects, error -> Void in
                if error != nil{
                    self.connectionAlert.show()
                }else{
                    if phoneObjects.count > 0{
                        //    self.existAlert.show()
                        //}else{
                        AVOSCloud.requestSmsCodeWithPhoneNumber(self.phoneNumberField.text, appName: "一串数字", operation: "注册", timeToLive: 1, callback: {succeeded, error in
                            if error != nil{
                                self.connectionAlert.show()
                            }else{
                                self.sendAlert.show()
                                self.verifyButton.hidden=true
                                self.verifyTimmer = NSTimer.scheduledTimerWithTimeInterval(60, target:self, selector:"sendingVerify", userInfo:nil, repeats:false)//设置定时器
                                self.verifyTimmer.fire()
                                
                                //self.phoneNumberField.enabled=false
                            }
                        })
                    }
                }
                
            }
            
        }

    }
    
    
    
    
    
    @IBAction func tappedLoginButton(sender: UIButton) {
        if phoneNumberField.text.isEmpty && pwdField.text.isEmpty{
            notCompleteAlert.show()
        }else{
//            AVUser.logInWithMobilePhoneNumberInBackground(self.phoneNumberField.text, smsCode: self.verifyCodeField.text, block: {user, error in
//                    if user == nil{
//                        if error.code == 211 {
//                            self.notExistAlert.show()
//                        }else if error.code == 210 {
//                            self.wrongPwdAlert.show()
//                        }
//                    }else{
//                        self.succeedLoginAlert.show()
//                        userDefaults.setObject(user.username, forKey: "userNameKey")
//                        self.dismissViewControllerAnimated(true, completion: {})
//                    }
//            })
            
            AVOSCloud.verifySmsCode(self.verifyCodeField.text, mobilePhoneNumber:self.phoneNumberField.text , callback: {succeeded, error in
                if error != nil{
                    self.codeAlert.show()
                }else{
                    //可以登陆
                    self.succeedLoginAlert.show()
                    userDefaults.setObject(self.phoneNumberField.text, forKey: "userNameKey")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                   
                }
            })

          
//            AVUser.logInWithUsernameInBackground(self.phoneNumberField.text, password: self.pwdField.text, block: {user, error in
//                if user == nil{
//                    if error.code == 211 {
//                        notExistAlert.show()
//                    }else if error.code == 210 {
//                        wrongPwdAlert.show()
//                    }
//                }else{
//                    succeedLoginAlert.show()
//                    userDefaults.setObject(user.username, forKey: "userNameKey")
//                    self.dismissViewControllerAnimated(true, completion: {})
//                }
//            
//            })

        }
    }
    
    
    func sendingVerify() {
        println("sendingVerify")
        self.countTimmer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"sendingCount", userInfo:nil, repeats:true)//设置定时器
        self.countTimmer.fire()
    }
    
    func sendingCount() {
        if initTime == 1{
            self.verifyTimmer.invalidate()
            self.countTimmer.invalidate()
            self.verifyButton.hidden=false
        }
        println("count\(initTime)")
        backCount.text="剩余\(initTime)秒"
        initTime-=1
    }
    
    func SwipeBack(){
        self.navigationController?.popViewControllerAnimated(true)
        //self.dismissViewControllerAnimated(true, completion: {})
    }
    
}

