//
//  ContentViewController.swift
//  numbers
//
//  Created by admin on 4/13/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

let INIT_HIDE_DEVIATION = 220




var alert = UIAlertView(title: "q", message: "", delegate: "", cancelButtonTitle: "back")
var alert4 = UIAlertView(title: "q", message: "", delegate: "", cancelButtonTitle: "back")
var MessageDB:[MessageModel] = []
var contentType:[String] = []
var isscroll=Int(0)
var offscreenCell=NSMutableDictionary()
var i:Int=0
var touchIndex=NSIndexPath()
var touchBug=0
var panGesture = UIPanGestureRecognizer()
var isLoading=Int(0)//是否在刷新中
var moreTimes=Int(0)//刷新次数
var canGetMore=Int(0)//是否可以刷新
var visibleCell=NSMutableArray()
var reportButtonHide=Bool(true)//反馈按钮是否隐藏
var likeButtonHide=Bool(true)//赞按钮是否隐藏
var myLikeNumber=Int(0)
var tableOffSet=CGPoint(x: CGFloat(0),y: CGFloat(0))//println(MessageTableView.contentOffset)
var tableReturnIndex=NSIndexPath()
var returnIndexFlag=Int(0)
var haveFavorited=Int(0)
var haveLike=Int(0)
var likeResult=AVObject()
class ContentViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate{
    @IBOutlet weak var showReportButton: UIButton!
    
    @IBOutlet weak var likeRemain: UILabel!
    @IBOutlet weak var showLikeButton: UIButton!

    @IBOutlet weak var moreTint: UILabel!
    
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var favoriteCurrentButton: UIButton!
    var refreshControl = UIRefreshControl()
    var moreControl = UIRefreshControl()
    @IBOutlet weak var MessageTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        moreTint.hidden=true
        likeRemain.hidden=true
        self.MessageTableView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        self.bottomBar.backgroundColor=UIColor(red: 27/255.0, green: 27/255.0, blue: 27/255.0, alpha: 1)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//*******        MessageTableView.estimatedRowHeight = 30.0//预估高度 ，ios8支持。。。
//*******        MessageTableView.rowHeight = UITableViewAutomaticDimension //tableview自适应，需设置constraints
    
  
        
        
        
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松手刷新")
        
        MessageTableView.addSubview(refreshControl)//下拉刷新动作
        
        getMessageDB(0,countMessage: 10)
        
        likeRemain.text="剩余\(haveLike)"
 
        
        

       
    }

    @IBAction func tappedShowReportButton(sender: UIButton) {
        if likeButtonHide == false{
            tappedShowLikeButton(showLikeButton)
        }
        reportButtonHide = !(reportButtonHide)
        for allindex in self.MessageTableView.indexPathsForVisibleRows() as! [NSIndexPath]{
            if MessageTableView.cellForRowAtIndexPath(allindex)!.reuseIdentifier == "MessageSimpleCellId" {
                MessageTableView.cellForRowAtIndexPath(allindex)?.viewWithTag(107)!.hidden=reportButtonHide
            }else if MessageTableView.cellForRowAtIndexPath(allindex)!.reuseIdentifier == "MessageImageCellId" {
                MessageTableView.cellForRowAtIndexPath(allindex)?.viewWithTag(117)!.hidden=reportButtonHide
            }
            
        }
    }
    @IBAction func tappedShowLikeButton(sender: UIButton) {
        if userDefaults.stringForKey("userNameKey") == "未登录"{
            var LoginAlert = UIAlertView(title: "提示", message: "请先登录", delegate: "", cancelButtonTitle: "返回")
            LoginAlert.show()
        }else{
                likeResult.setObject(haveLike, forKey: "like")
                likeResult.saveInBackground()
            
            if reportButtonHide == false{
                tappedShowReportButton(showReportButton)
            }
            if haveLike == 0 {
                likeRemain.hidden = false
            }else{
                likeRemain.hidden = !(likeRemain.hidden)
            }
            likeButtonHide = !(likeButtonHide)
            for allindex in self.MessageTableView.indexPathsForVisibleRows() as! [NSIndexPath]{
                if MessageTableView.cellForRowAtIndexPath(allindex)!.reuseIdentifier == "MessageSimpleCellId" {
                    MessageTableView.cellForRowAtIndexPath(allindex)?.viewWithTag(108)!.hidden = likeButtonHide
                    MessageTableView.cellForRowAtIndexPath(allindex)?.viewWithTag(106)!.hidden = !(likeButtonHide)
                }else if MessageTableView.cellForRowAtIndexPath(allindex)!.reuseIdentifier == "MessageImageCellId" {
                    MessageTableView.cellForRowAtIndexPath(allindex)?.viewWithTag(118)!.hidden = likeButtonHide
                    MessageTableView.cellForRowAtIndexPath(allindex)?.viewWithTag(116)!.hidden = !(likeButtonHide)
                }
                var renewQuery = AVQuery(className: "Content")
                renewQuery.whereKey("contentId", equalTo: MessageDB[allindex.row].MessageID)
                renewQuery.findObjectsInBackgroundWithBlock { renewMessages, renewerror -> Void in
                    for obj in renewMessages {
                        var saveobj = obj as! AVObject
                        saveobj.setObject(MessageDB[allindex.row].MessageLike, forKey: "like")
                        saveobj.saveInBackground()
                    }
                }
                
                
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) { //开始滑动了！！
        print("scroll")
        self.view.removeGestureRecognizer(panGesture)
        if likeButtonHide == false{
            tappedShowLikeButton(showLikeButton)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){//上拉更新
        //print(tableOffSet)
        
        if isLoading == 0 { // 判断是否处于刷新状态，刷新中就不执行
            
            var height:CGFloat = scrollView.contentSize.height > MessageTableView.frame.size.height ?MessageTableView.frame.size.height : scrollView.contentSize.height;
            
            if (height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.01 {
                moreTint.hidden=false
            }else{
                moreTint.hidden=true
            }
            
            
            if (height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2 {
                moreTint.text="松开加载更多"
                println("pullup")
                canGetMore=1
                
            }else{
                moreTint.text="上拉刷新"
                canGetMore=0
            }
            
        }
    
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if canGetMore == 1{
            moreTint.hidden=true
            canGetMore = 0
            moreData()
        }
    }
    
    func completeInitAnimation(animationCell:UITableViewCell!, cellType:Int) {
        
            var timeTag:Int
            var nameTag:Int
        
            if cellType == 1{
                timeTag=102
                nameTag=101
                
            }else{
                timeTag=112
                nameTag=111
            }
            
            var moveTimeView = animationCell!.viewWithTag(timeTag) as! UILabel
            var moveNameView = animationCell!.viewWithTag(nameTag) as! UILabel
            
                UIView.animateWithDuration(2, animations: {
                    moveTimeView.frame.origin = CGPoint(x:CGFloat(INIT_HIDE_DEVIATION) + CGFloat(400),
                        y:moveTimeView.frame.origin.y)
                    moveNameView.frame.origin = CGPoint(x:CGFloat(INIT_HIDE_DEVIATION) + CGFloat(400),
                        y:moveNameView.frame.origin.y)
                    }, completion: nil)

    }
    

    
    
    func getMessageDB( beginMessage:Int, countMessage:Int){                 //更新数据源函数
        var updateArray:[NSIndexPath]=[]
        for var i = 0;i < countMessage; i++ {
            var index = NSIndexPath(forRow: beginMessage+i, inSection: 0)
            updateArray.append(index)
        }//生成更新索引
        
        
        
        
        if beginMessage == 0{
            MessageDB.removeAll()//先清空
            
        }
        var roomQuery = AVQuery(className:"Room")
        roomQuery.whereKey("number", equalTo: currentNumber)
        
        if userDefaults.stringForKey("userNameKey") == "未登录"{
            haveLike=0
            //self.navigationController?.pushViewController(RegViewController(), animated: true)
        }else{
        
            var nameQuery = AVQuery(className: "_User")
            nameQuery.whereKey("username", equalTo:userDefaults.objectForKey("userNameKey"))
            var nameResult=nameQuery.getFirstObject()
            
            
            
            
            
            var likeQuery=AVQuery(className: "LikeRoom")
            likeQuery.whereKey("roomId", matchesKey: "roomId", inQuery: roomQuery)
            likeQuery.whereKey("user", equalTo: nameResult)
            var likeResults=likeQuery.findObjects()
            for obj in likeResults{
                if count(likeResults) == 0 {
                    var saveLikeRoom=AVObject(className: "LikeRoom")
                    saveLikeRoom.setObject(0, forKey: "like")
                    saveLikeRoom.setObject(nameResult, forKey: "user")
                    saveLikeRoom.setObject(roomQuery.getFirstObject().objectForKey("roomId"), forKey: "roomId")
                    saveLikeRoom.saveInBackground()
                }else{
                    likeResult = obj as! AVObject
                    haveLike = likeResult.objectForKey("like") as! Int
                }
            }
        }
        var query = AVQuery(className:"Content")
        //query.whereKey("roomId", equalTo: currentNumber)
        query.whereKey("roomId", matchesKey: "roomId", inQuery: roomQuery)
        //alert.show()
        query.orderByDescending("contentId")
        query.includeKey("author")
        query.includeKey("imgRelation")
        
        
        query.limit = countMessage
        query.skip = beginMessage
        //print("kaishi")
        query.findObjectsInBackgroundWithBlock {messageObjects, error -> Void in
            if error != nil{
              //  print("shibai")//失败
            }else{
                var loadingObject = MessageModel(Author: "", Content: "", Date: "", ID: 0,Type:0, Like:0)
                var date:NSDate
                var imageRelation:AVRelation
                for obj in messageObjects {
                    if obj.objectForKey("author")!.objectForKey("nickname")  == nil {
                        loadingObject.MessageAuthor = "匿名"
                    }else{
                        loadingObject.MessageAuthor = obj.objectForKey("author")!.objectForKey("nickname") as! String
                    }
                    loadingObject.MessageContent = obj.objectForKey("content") as! String
                    date = obj.updatedAt
                    loadingObject.MessageDate = self.stringFromDate(date)
                    loadingObject.MessageID = obj.objectForKey("contentId") as! Int
                    loadingObject.MessageType = obj.objectForKey("contentType") as! Int
                    loadingObject.MessageLike = obj.objectForKey("like") as! Int
                   // println(obj.objectForKey("contentId"))
                    imageRelation = obj.relationforKey("imgRelation")
                    var curHaveImagePosition = MessageDB.count
                    imageRelation.query().findObjectsInBackgroundWithBlock {imageObjects, error2 -> Void in
                        if error2 != nil{
                           // print("shibai")
                        }else{
                            for iobj in imageObjects
                            {
                              //  println(iobj.objectForKey("url"))
                                var file: AnyObject!=AVFile.fileWithURL(iobj.objectForKey("url") as? String)
                                file.getThumbnail(true, width: 600, height: 800, withBlock: { curImage, imageError -> Void in ///获取缩略图
                            
                                    MessageDB[curHaveImagePosition].MessageImage = curImage
                                    MessageDB[curHaveImagePosition].MessageImageURL = iobj.objectForKey("url") as? String
                                    var curImageIndex = NSIndexPath(forRow: curHaveImagePosition, inSection: 0)
                      //              self.MessageTableView.cellForRowAtIndexPath(curImageIndex)?.viewWithTag(114)?.frame.size = (curImage as UIImage).size
                                    self.MessageTableView.reloadRowsAtIndexPaths( [curImageIndex], withRowAnimation: UITableViewRowAnimation.Automatic)//更新加载出来的那个cell
                                })
                            }
                        }
                    }


                    MessageDB.append(MessageModel(Author: loadingObject.MessageAuthor, Content: loadingObject.MessageContent, Date: loadingObject.MessageDate, ID: loadingObject.MessageID, Type:loadingObject.MessageType,Like: loadingObject.MessageLike))
                    contentType.append(obj.objectForKey("content") as! String)
                    
                }
               
                    self.MessageTableView.reloadData()
                

                self.refreshControl.endRefreshing()
            }
        }

    }

    func touchesShouldBegin(touches: Set<NSObject>!, withEvent event: UIEvent!, inContentView view: UIView!) -> Bool{
     return false
    }

    
    @IBAction func handlePanGesture(recognizer:UIPanGestureRecognizer) {
       var indexPath = Optional(touchIndex)

        if let index = indexPath {
            var timeTag:Int
            var nameTag:Int
            if MessageDB[index.row].MessageType == 1{
                timeTag=102
                nameTag=101
            }else{
                timeTag=112
                nameTag=111
            }
            var selectCell:UITableViewCell
            selectCell=MessageTableView.cellForRowAtIndexPath(index)!
            var moveTimeView = selectCell.viewWithTag(timeTag) as! UILabel
            var moveNameView = selectCell.viewWithTag(nameTag) as! UILabel
            let translation = recognizer.translationInView(self.view)
            if moveTimeView.frame.origin.x < CGFloat(-50)
            {
                moveTimeView.frame.origin = CGPoint(x:moveTimeView.frame.origin.x,
                    y:moveTimeView.frame.origin.y)
                moveNameView.frame.origin = CGPoint(x:moveNameView.frame.origin.x,
                    y:moveNameView.frame.origin.y)
            }else{
                moveTimeView.frame.origin = CGPoint(x:moveTimeView.frame.origin.x + translation.x * 1.8,
                    y:moveTimeView.frame.origin.y)
                moveNameView.frame.origin = CGPoint(x:moveNameView.frame.origin.x + translation.x * 1.8,
                    y:moveNameView.frame.origin.y)
            }
            recognizer.setTranslation(CGPointZero, inView: self.view)
            if recognizer.state == UIGestureRecognizerState.Ended {
                UIView.animateWithDuration(0.5, animations: {
                    moveTimeView.frame.origin = CGPoint(x:CGFloat(INIT_HIDE_DEVIATION),
                        y:moveTimeView.frame.origin.y)
                    moveNameView.frame.origin = CGPoint(x:CGFloat(INIT_HIDE_DEVIATION),
                        y:moveNameView.frame.origin.y)
                    }, completion:{ finished in
                        self.MessageTableView.deselectRowAtIndexPath(indexPath!, animated: true)
                    })
            }
        }
        
        
    }

    
    @IBAction func favoriteCurrentRoom(sender: UIButton) {
        if userDefaults.stringForKey("userNameKey") == "未登录"{
            var LoginAlert = UIAlertView(title: "提示", message: "请先登录", delegate: "", cancelButtonTitle: "返回")
            LoginAlert.show()
        }else{
            var nameQuery = AVQuery(className: "_User")
            nameQuery.whereKey("username", equalTo: userDefaults.stringForKey("userNameKey"))
            var nameObject = nameQuery.getFirstObject()
            
            var haveFavoriteQuery=AVQuery(className: "Favorite")
            haveFavoriteQuery.whereKey("user", equalTo: nameObject)
            haveFavoriteQuery.whereKey("favoriteNumbers", equalTo: currentNumber)
            var curResults=haveFavoriteQuery.findObjects()
            if count(curResults) != 0
            {
                var AlreadyAlert = UIAlertView(title: "提示", message: "你已经收藏过了", delegate: "", cancelButtonTitle: "返回")
                AlreadyAlert.show()
                
            }else{
                var saveFavorite=AVObject(className: "Favorite")
                saveFavorite.setObject(nameObject, forKey: "user")
                saveFavorite.setObject(currentNumber, forKey: "favoriteNumbers")
                saveFavorite.saveInBackground()
                var FavoriteAlert = UIAlertView(title: "提示", message: "收藏成功", delegate: "", cancelButtonTitle: "返回")
                FavoriteAlert.show()
            }
                
      
        }
    }
    
    
    @IBAction func tappedLike(sender: UIButton) {
        if haveLike != 0{
            MessageDB[MessageTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)!.row].MessageLike+=1
            ((sender.superview?.superview as! UITableViewCell).viewWithTag(116) as! UILabel).text = "\(MessageDB[MessageTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)!.row].MessageLike)赞"
            haveLike-=1
            likeRemain.text="剩余\(haveLike)"
            
        }
        //        UIView.animateWithDuration(2, animations: {
//            ((sender.superview?.superview as! UITableViewCell).viewWithTag(116) as! UILabel).frame.size = CGSize(width: ((sender.superview?.superview as! UITableViewCell).viewWithTag(116) as! UILabel).frame.size.width * 2, height: ((sender.superview?.superview as! UITableViewCell).viewWithTag(116) as! UILabel).frame.size.height * 2)
//        })
            //self.MessageTableView.reloadRowsAtIndexPaths( [MessageTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)!], withRowAnimation: UITableViewRowAnimation.Automatic)//更新加载出来的那个cell
       
    }
    
    @IBAction func tappedSimpleLike(sender: UIButton) {
        MessageDB[MessageTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)!.row].MessageLike+=1
        ((sender.superview?.superview as! UITableViewCell).viewWithTag(106) as! UILabel).text = "\(MessageDB[MessageTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)!.row].MessageLike)赞"
        haveLike-=1
        likeRemain.text="剩余\(haveLike)"
        //self.MessageTableView.reloadRowsAtIndexPaths( [MessageTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)!], withRowAnimation: UITableViewRowAnimation.Automatic)//更新加载出来的那个cell
        
        
    }
    

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        self.MessageTableView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        if needRefresh == 1 {
            needRefresh = 0
            refreshData()
        }
        if  likeButtonHide == false{
            tappedShowLikeButton(showLikeButton)
        }
        if reportButtonHide == false{
            tappedShowReportButton(showReportButton)
        }
        
        
        
        
  

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return MessageDB.count
    }
    
    
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var tempDB = MessageDB[indexPath.row] as MessageModel
        var MessageCell:UITableViewCell
        
        if tempDB.MessageType == 1{
            MessageCell = self.MessageTableView.dequeueReusableCellWithIdentifier("MessageSimpleCellId") as! UITableViewCell
   
            
            var mcontent = MessageCell.viewWithTag(103) as! UILabel
            var mbackground = MessageCell.viewWithTag(109) as! UIImageView
            var mlike = MessageCell.viewWithTag(106) as! UILabel
            var inset = UIEdgeInsetsMake(CGFloat(25), CGFloat(25), CGFloat(25), CGFloat(25))
            mbackground.image = mbackground.image?.resizableImageWithCapInsets(inset)
            mlike.text = "\(tempDB.MessageLike)赞"
            mcontent.numberOfLines == 0 //不限制最大行数
            mcontent.lineBreakMode = NSLineBreakMode.ByWordWrapping//label自适应
            
            mcontent.text = tempDB.MessageContent

           

            
            let font=UIFont.systemFontOfSize(17)
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let size = CGSizeMake(270, CGFloat(MAXFLOAT))
            let stringRect = mcontent.text!.boundingRectWithSize(size, options: option, attributes: attributes as [NSObject : AnyObject], context: nil)
            var textSize = stringRect.size

            
            mcontent.frame=CGRectMake(mcontent.frame.origin.x, mcontent.frame.origin.y, textSize.width, textSize.height)
            var mauthor = MessageCell.viewWithTag(101) as! UILabel
            mauthor.text = "----"+tempDB.MessageAuthor
            var mdate = MessageCell.viewWithTag(102) as! UILabel
            mdate.text =  tempDB.MessageDate
            MessageCell.viewWithTag(107)?.hidden=reportButtonHide
            MessageCell.viewWithTag(108)?.hidden=likeButtonHide
            }
            else //tempDB.MessageType == 3
            {
                MessageCell = self.MessageTableView.dequeueReusableCellWithIdentifier("MessageImageCellId") as! UITableViewCell

                var mcontent = MessageCell.viewWithTag(113) as! UILabel//103
                var mimage = MessageCell.viewWithTag(114) as! UIImageView
                var mbackground = MessageCell.viewWithTag(119) as! UIImageView
                
                
                
                
                var mlike = MessageCell.viewWithTag(116) as! UILabel
             
               
                var inset = UIEdgeInsetsMake(CGFloat(25), CGFloat(25), CGFloat(25), CGFloat(25))
                mbackground.image = mbackground.image?.resizableImageWithCapInsets(inset)
                
                mlike.text = "\(tempDB.MessageLike)赞"
             
                mcontent.numberOfLines == 0 //不限制最大行数
                mcontent.lineBreakMode = NSLineBreakMode.ByWordWrapping//label自适
                mcontent.text = tempDB.MessageContent
                mimage.image=tempDB.MessageImage
                let font=UIFont.systemFontOfSize(17)
                let option = NSStringDrawingOptions.UsesLineFragmentOrigin
                let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
                let size = CGSizeMake(40, CGFloat(MAXFLOAT))
                let stringRect = mcontent.text!.boundingRectWithSize(size, options: option, attributes: attributes as [NSObject : AnyObject], context: nil)
                var textSize = stringRect.size
                mcontent.frame=CGRectMake(mcontent.frame.origin.x, mcontent.frame.origin.y, textSize.width, textSize.height)
                var mauthor = MessageCell.viewWithTag(111) as! UILabel
                mauthor.text = "----"+tempDB.MessageAuthor
                var mdate = MessageCell.viewWithTag(112) as! UILabel
                mdate.text =  tempDB.MessageDate
                MessageCell.viewWithTag(117)?.hidden=reportButtonHide
                MessageCell.viewWithTag(118)?.hidden=likeButtonHide
            }
       

        MessageCell.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        MessageCell.setNeedsUpdateConstraints()
        MessageCell.updateConstraintsIfNeeded()
        
        return MessageCell
        
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { /////获得高度
     //   println("高度heightcell")
        var tempDB = MessageDB[indexPath.row] as MessageModel
        var MessageCell:UITableViewCell
        if tempDB.MessageType == 1{
            MessageCell = self.MessageTableView.dequeueReusableCellWithIdentifier("MessageSimpleCellId") as! UITableViewCell
            var mcontent = MessageCell.viewWithTag(103) as! UILabel//103
            var mbackground = MessageCell.viewWithTag(109) as! UIImageView
            mcontent.numberOfLines == 0 //不限制最大行数
            mcontent.lineBreakMode = NSLineBreakMode.ByWordWrapping//label自适应
            mcontent.text = tempDB.MessageContent
            
            let font=UIFont.systemFontOfSize(17)
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let size = CGSizeMake(270, CGFloat(MAXFLOAT))
            let stringRect = mcontent.text!.boundingRectWithSize(size, options: option, attributes: attributes as [NSObject : AnyObject], context: nil)
            var textSize = stringRect.size
            mcontent.frame=CGRectMake(mcontent.frame.origin.x, mcontent.frame.origin.y, textSize.width, textSize.height)
            var mauthor = MessageCell.viewWithTag(101) as! UILabel
            mauthor.text = "----"+tempDB.MessageAuthor //先赋值、
            var mdate = MessageCell.viewWithTag(102) as! UILabel
            mdate.text =  tempDB.MessageDate //先赋值、

            return mdate.frame.size.height + mcontent.frame.size.height + mauthor.frame.size.height + CGFloat(50)
        }
        else //tempDB.MessageType == 3
        {
            MessageCell = self.MessageTableView.dequeueReusableCellWithIdentifier("MessageImageCellId") as! UITableViewCell
            var mcontent = MessageCell.viewWithTag(113) as! UILabel//103
            var mimage = MessageCell.viewWithTag(114) as! UIImageView
            var mbackground = MessageCell.viewWithTag(119) as! UIImageView

            mcontent.numberOfLines == 0 //不限制最大行数
            mcontent.lineBreakMode = NSLineBreakMode.ByWordWrapping//label自适应

            mcontent.text = tempDB.MessageContent
            mimage.image=tempDB.MessageImage
            let font=UIFont.systemFontOfSize(17)
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let size = CGSizeMake(270, CGFloat(MAXFLOAT))//270
            let stringRect = mcontent.text!.boundingRectWithSize(size, options: option, attributes: attributes as [NSObject : AnyObject], context: nil)
            var textSize = stringRect.size //设置格式
            mcontent.frame=CGRectMake(mcontent.frame.origin.x, mcontent.frame.origin.y, textSize.width, textSize.height)
            var mauthor = MessageCell.viewWithTag(111) as! UILabel
            mauthor.text = "----"+tempDB.MessageAuthor //先赋值、
            var mdate = MessageCell.viewWithTag(112) as! UILabel
            mdate.text =  tempDB.MessageDate //先赋值、
            return mdate.frame.size.height + mcontent.frame.size.height + mimage.frame.size.height + mauthor.frame.size.height + CGFloat(75)
        }
        
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return CGFloat(30.0)
    }

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       
        touchIndex = indexPath
        panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.view.addGestureRecognizer(panGesture)
       
        self.MessageTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    

    
    func stringFromDate(date:NSDate)->String{//date转string
    
        var dateFormatter:NSDateFormatter =  NSDateFormatter()
        //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateString:String =  dateFormatter.stringFromDate(date)
        return dateString
    }
    
    
    

    
    
    func refreshData() {//下拉刷新实现
        refreshControl.attributedTitle = NSAttributedString(string: "刷新中。。。")
        getMessageDB(0,countMessage: 10)
    }
    
    func moreData(){//上拉加载
        moreTimes+=1
        isLoading = 1
       // println(moreTimes)
        getMessageDB( 10*moreTimes , countMessage: 10)
        isLoading = 0
    }
    

    

 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if userDefaults.stringForKey("userNameKey") == "未登录"{
          
           
            var LoginAlert = UIAlertView(title: "提示", message: "请先登录", delegate: "", cancelButtonTitle: "返回")
            LoginAlert.show()
        }else{
            if segue.identifier == "SimpleToReport" || segue.identifier == "ImageToReport"{
                returnIndexFlag=1
                tableOffSet = MessageTableView.contentOffset
                var descontroller=segue.destinationViewController as! ReportViewController
                var reportCellIndex = MessageTableView.indexPathForCell(sender!.superview!!.superview as! UITableViewCell)
                println(MessageDB[reportCellIndex!.row].MessageID)
                tableReturnIndex = reportCellIndex!
                descontroller.reportMessageId = MessageDB[reportCellIndex!.row].MessageID
            }
        }
    }
    
    
    
    @IBAction func closeToContent(segue: UIStoryboardSegue){
       // print("close")
        
        //MessageTableView.reloadData()
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        //MessageDB.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

