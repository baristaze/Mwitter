//
//  Account.swift
//  Mwitter
//
//  Created by Baris Taze on 5/22/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import Foundation

class Account {
    
    var name:String = ""
    var screenName:String = ""
    var tagLine:String = ""
    var profileImageUrl:String = ""
    var location:String = ""
    
    func initWithDictionary(dict:NSDictionary) -> Account {
        
        self.name = dict["name"] as! String
        self.screenName = dict["screen_name"] as! String
        self.tagLine = dict["description"] as! String
        self.profileImageUrl = dict["profile_image_url"] as! String
        self.location = dict["location"] as! String
        
        return self
    }
}