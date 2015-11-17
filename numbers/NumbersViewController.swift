//
//  NumbersViewController.swift
//  numbers
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {
    @IBOutlet weak var GoButton: UIButton!
    @IBOutlet weak var TypedNumbers: UITextField!
    
    @IBOutlet weak var FavoriteButton: UIBarButtonItem!
   
    @IBOutlet var mainView: UIView!

    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image9: UIImageView!
    
   
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 249/255.0, green: 67/255.0, blue: 94/255.0, alpha: 1)
        super.viewDidLoad()
        
        
        

        
        
        TypedNumbers.delegate=self
        
        let timmer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"CheckInput", userInfo:nil, repeats:true)//设置定时器
        timmer.fire()
        
        GoButton.hidden=true
        TypedNumbers.userInteractionEnabled=false
        
        self.navigationController?.interactivePopGestureRecognizer.delegate = self //滑动返回初始化
        
        self.mainView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)//设置主背景颜色

        image1.image=UIImage(named: "num_1")
        image2.image=UIImage(named: "num_0")
        image3.image=UIImage(named: "num_0")
        image4.image=UIImage(named: "num_0")
        image5.image=UIImage(named: "num_0")
        image6.image=UIImage(named: "num_0")
        image7.image=UIImage(named: "num_0")
        image8.image=UIImage(named: "num_0")
        image9.image=UIImage(named: "num_0")
        
       // self.navigationController?.navigationBar.tintColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)//设置导航栏颜色
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addNumImage(numImage:String){
        switch count(self.TypedNumbers.text) {
            
        case 1:
            self.image1.image = UIImage(named: numImage)
            
        case 2:
            self.image2.image=UIImage(named: numImage)
            
        case 3:
            self.image3.image=UIImage(named: numImage)
            
        case 4:
            self.image4.image=UIImage(named: numImage)
            
        case 5:
            self.image5.image=UIImage(named: numImage)
            
        case 6:
            self.image6.image=UIImage(named: numImage)
            
        case 7:
            self.image7.image=UIImage(named: numImage)
            
        case 8:
            self.image8.image=UIImage(named: numImage)
            
        case 9:
            self.image9.image=UIImage(named: numImage)
            
        default:
            print("default")
        }
    }
    
    override func viewDidAppear(animated: Bool) { //视图出现前
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        userNameLabel.text = userDefaults.stringForKey("userNameKey")//显示用户名
        if userNameLabel.text==nil
        {
            print("yes")
            userDefaults.setObject("未登录", forKey: "userNameKey")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func num1Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "1"
            addNumImage("num_1")
        }
    }
    
    @IBAction func num2Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "2"
            addNumImage("num_2")
        }
    }
    
    @IBAction func num3Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "3"
            addNumImage("num_3")
        }
    }
    
    
    @IBAction func num4Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "4"
            addNumImage("num_4")
        }
    }
    
    
    @IBAction func num5Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "5"
            addNumImage("num_5")
        }
    }
    
    
    @IBAction func num6Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "6"
            addNumImage("num_6")
        }
    }
    
    
    @IBAction func num7Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "7"
            addNumImage("num_7")
        }
    }
    
    @IBAction func num8Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "8"
            addNumImage("num_8")
        }
    }
    
    
    @IBAction func num9Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "9"
            addNumImage("num_9")
        }
    }
    
    
    @IBAction func num0Tapped(sender: UIButton) {
        if count(TypedNumbers.text) < 9 {
            TypedNumbers.text = TypedNumbers.text + "0"
            addNumImage("num_0")
        }
    }
    
    
    @IBAction func backTapped(sender: UIButton) {
        if count(TypedNumbers.text) != 0
        {
            self.TypedNumbers.text = (self.TypedNumbers.text as NSString).substringWithRange(NSMakeRange(0, count(self.TypedNumbers.text)-1)) as String
            switch count(self.TypedNumbers.text) {
                
            case 0:
                self.image1.image = nil
            case 1:
                self.image2.image=nil
            case 2:
                self.image3.image=nil
            case 3:
                self.image4.image=nil
            case 4:
                self.image5.image=nil
            case 5:
                self.image6.image=nil
            case 6:
                self.image7.image=nil
            case 7:
                self.image8.image=nil
            case 8:
                self.image9.image=nil
            default:
                print("default")
            }
            
        }
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIButton == GoButton{
            currentNumber = TypedNumbers.text
        }
        else if sender as! UIButton == LoginButton{
        }
        else if sender as! UIButton == FavoriteButton{
        }
    }
    
    func CheckInput(){
        if count(self.TypedNumbers.text) > 8{
            self.GoButton.hidden=false
            //self.TypedNumbers.text = (self.TypedNumbers.text as NSString).substringWithRange(NSMakeRange(0, 9)) as String//截取前9位
        }else{
            self.GoButton.hidden=true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{//delegate函数
        if range.location >= 9
        {
            return  false
        }
        else
        {
            return true
        }
    }
    
    
    
    @IBAction func close(segue: UIStoryboardSegue){
        print("close")
    }
    
}

