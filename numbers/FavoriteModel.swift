//
//  FavoriteModel.swift
//  numbers
//
//  Created by admin on 5/28/15.
//  Copyright (c) 2015 duanziyushi. All rights reserved.
//

import UIKit

class FavoriteModel: NSObject {
    var FavoriteObjectID:String
    var FavoriteRoom:String
    var FavoriteTint:String
    init(ObjectID:String,Room:String,Tint:String="") {
        self.FavoriteObjectID=ObjectID
        self.FavoriteRoom=Room
        self.FavoriteTint=Tint
    }
}
