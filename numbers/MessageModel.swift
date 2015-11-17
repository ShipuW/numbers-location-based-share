//
//  MessageModel.swift
//  numbers
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    var MessageAuthor:String
    var MessageContent:String
    var MessageDate:String
    var MessageID:Int
    var MessageImage:UIImage?
    var MessageType:Int
    var MessageImageURL:String?
    var MessageLike:Int
    var MessageObjectID:String
    init (Author:String,Content:String,Date:String,ID:Int=0,Type:Int,Like:Int,ImageURL:String="",Image:UIImage=UIImage(named: "button_0")!){
        self.MessageAuthor = Author
        self.MessageContent = Content
        self.MessageDate = Date
        self.MessageID = ID
        self.MessageImage=Image
        self.MessageType=Type
        self.MessageImageURL=ImageURL
        self.MessageLike=Like
        self.MessageObjectID=""
    }
}
