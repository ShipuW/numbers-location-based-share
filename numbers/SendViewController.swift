//
//  SendViewController.swift
//  numbers
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

var sendFailAlert = UIAlertView(title: "发送失败", message: "请检查网络", delegate: "", cancelButtonTitle: "返回")
var sendSucceedAlert = UIAlertView(title: "发送成功", message: "", delegate: "", cancelButtonTitle: "返回")

class SendViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var takePhote: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var SendContent: UITextView!
    @IBOutlet weak var SendButton: UIButton!
    var existText=Int(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        takePhote.hidden=true
        //takePhote.frame.origin=CGPointMake(imageView.frame.origin.x+102, imageView.frame.origin.y)
        //takePhote.titleLabel?.text="重新拍摄" //拍摄完后可以重新拍
        
    }
    
    
    
////////////////*******************************************************/////////////////
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "" && range.length > 0 {
            //删除字符肯定是安全的
            textCount.text="\(70-(count(SendContent.text) - range.length + count(text)))"
            return true
        }
        else {
            
            if ( count(SendContent.text) - range.length + count(text) ) > 70 {
                println("pass")
                
                return false;
            }
            else {
                textCount.text="\(70-(count(SendContent.text) - range.length + count(text)))"
                return true;
            }
        }
    
    }
///////////////*********************************************************/////////////////
    
    
    @IBAction func takePhoteTapped(sender: UIButton) {
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func TappedSendButton(sender: UIButton) {
        var roomid:Int!
        
        var curUser = AVObject(className: "_User")
        
        var message = AVObject(className: "Content")
        
        var roomSendQuery = AVQuery(className:"Room")//找房间
        roomSendQuery.whereKey("number", equalTo: currentNumber)
        var userSendQuery = AVQuery(className:"_User")//找用户
        userSendQuery.whereKey("username", equalTo: userDefaults.stringForKey("userNameKey"))
        var roomObjects = roomSendQuery.findObjects()
        
        for obj in roomObjects{///即时取值
            roomid = obj.objectForKey("roomId") as! Int
        }
        var userObjects = userSendQuery.findObjects()
        for obj in userObjects{
            curUser = obj as! AVObject
        }
        
        var messageType=Int(1)
        if imageView.image != nil{
            messageType=3
           // var brige=AVObject(className: "_File")
            var uploadImageData : NSData
            
            uploadImageData=UIImageJPEGRepresentation(imageView.image, 0.04)//图片质量0.3
            var uploadImage: AnyObject! = AVFile.fileWithName(currentNumber, data: uploadImageData)
            uploadImage.save()
            println(uploadImage.objectId)
            
            var fileQuery=AVQuery(className: "_File")
            fileQuery.whereKey("objectId", equalTo: uploadImage.objectId)
            var imageRelation:AVRelation
            imageRelation=message.relationforKey("imgRelation")
            
            var imageGets=fileQuery.findObjects()
            
            for imobj in imageGets
            {
                imageRelation.addObject(imobj as! AVObject)
            }
            
            
           // imageRelation=message.relationforKey("imgRelation")
            
           // message.setObject(uploadImage, forKey: "imgRelation")
//            brige=uploadImage as! AVObject
//            imageRelation.addObject(brige)
        }
        message.setObject(curUser, forKey: "author")
        message.setObject(self.SendContent.text, forKey: "content")
        message.setObject(roomid, forKey: "roomId")
        message.setObject(messageType, forKey: "contentType")
        message.saveInBackgroundWithBlock { succeeded, error -> Void in
            if error != nil{
                sendFailAlert.show()//出错
            }else{
                sendSucceedAlert.show()//成功
                needRefresh=1
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
}

