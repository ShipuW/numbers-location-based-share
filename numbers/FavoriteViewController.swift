//
//  FavoriteViewController.swift
//  numbers
//
//  Created by admin on 4/14/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit
var FavoriteDB:[FavoriteModel]=[]

class FavoriteViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate {
    
    @IBOutlet weak var FavoriteTableView: UITableView!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 249/255.0, green: 67/255.0, blue: 94/255.0, alpha: 1)
        super.viewDidLoad()
        self.FavoriteTableView.backgroundColor=UIColor(red: 43/255.0, green: 43/255.0, blue: 43/255.0, alpha: 1)
        getFavoriteDB()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getFavoriteDB(){
        FavoriteDB.removeAll()//先清空
        var favoriteQuery = AVQuery(className:"Favorite")
        favoriteQuery.orderByDescending("updatedAt")
        favoriteQuery.includeKey("user")
        favoriteQuery.findObjectsInBackgroundWithBlock {favoriteObjects, error -> Void in
            if error != nil{
                var errorConnectionAlert=UIAlertView(title: "的墙", message: "网络错误", delegate: "", cancelButtonTitle: "返回")
                errorConnectionAlert.show()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                for obj in favoriteObjects {
                    if (obj.objectForKey("user")!.objectForKey("username") as! String) == userDefaults.stringForKey("userNameKey")
                    {
                        if obj.objectForKey("note") == nil {
                            FavoriteDB.append(FavoriteModel(ObjectID: obj.objectForKey("objectId") as! String, Room: obj.objectForKey("favoriteNumbers") as! String))
                        }else{
                            FavoriteDB.append(FavoriteModel(ObjectID: obj.objectForKey("objectId") as! String, Room: obj.objectForKey("favoriteNumbers") as! String, Tint: obj.objectForKey("note") as! String))
                        }
                    }else{}
                }
                self.FavoriteTableView.reloadData()
            }
        }

    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return FavoriteDB.count
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var FavoriteCell:UITableViewCell
        
        FavoriteCell = self.FavoriteTableView.dequeueReusableCellWithIdentifier("FavoriteCellId") as! UITableViewCell
        
        (FavoriteCell.viewWithTag(301) as! UILabel).text = FavoriteDB[indexPath.row].FavoriteRoom
        (FavoriteCell.viewWithTag(302) as! UILabel).text = FavoriteDB[indexPath.row].FavoriteTint
        return FavoriteCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentNumber=(FavoriteTableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(301) as! UILabel).text!
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){//向左滑删除cell
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //删除数据库中数据
            var deleteQuery=AVQuery(className: "Favorite")
            var deleteObject:AVObject=deleteQuery.getObjectWithId(FavoriteDB[indexPath.row].FavoriteObjectID)
            deleteObject.deleteInBackground()
            FavoriteDB.removeAtIndex(indexPath.row)
            self.FavoriteTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)//删除后平滑更新
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FavoriteToRoom" {
            
            
        }
    }
    
    
}
