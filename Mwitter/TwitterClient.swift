//
//  TwitterClient.swift
//  Mwitter
//
//  Created by Baris Taze on 5/22/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class TwitterClient: BDBOAuth1RequestOperationManager {
 
    private static let kConsumerKey = "IF1zQnMYaTEcVYW2fPXca6iwi"
    private static let kConsumerSecret = "Vp6ajHiolNINK5EsOIwLkf8rpLw8kzSs4aHQQJVLt96nXpvC0b"
    private static let kBaseUrl = "https://api.twitter.com"
    
    private var requestToken:BDBOAuth1Credential!
    
    private init(baseUrl:NSURL!, consumerKey:String, consumerSecret:String) {
        super.init(baseURL:baseUrl, consumerKey:consumerKey, consumerSecret:consumerSecret)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let sharedInstance = TwitterClient(baseUrl:NSURL(string:kBaseUrl), consumerKey:kConsumerKey, consumerSecret:kConsumerSecret)
    
    func requestAccessToken() -> Void {
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oath"), scope: nil, success: self.onRequestTokenSuccess, failure: self.onRequestTokenError)
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oath"), scope: nil, success: self.onRequestTokenSuccess, failure: self.onRequestTokenError)
    }
    
    private func onRequestTokenSuccess(requestToken:BDBOAuth1Credential!) -> Void {
        self.requestToken = requestToken
        println("request token retrieved")
    }
    
    private func onRequestTokenError(error:NSError!) -> Void {
        println("request token failed")
    }
}
