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
    
    private init(baseUrl:NSURL!, consumerKey:String, consumerSecret:String) {
        super.init(baseURL:baseUrl, consumerKey:consumerKey, consumerSecret:consumerSecret)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let sharedInstance = TwitterClient(baseUrl:NSURL(string:kBaseUrl), consumerKey:kConsumerKey, consumerSecret:kConsumerSecret)
    
    func requestAccessToken() {
        
        self.requestSerializer.removeAccessToken()
        
        self.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string:"cptwitterdemo://oath"),
            scope: nil,
            success: self.onRequestTokenSuccess,
            failure: self.onRequestTokenError)
    }
    
    func fetchAuthorizeToken(requestToken:BDBOAuth1Credential!) {
        
        self.fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: self.onAccessTokenSuccess,
            failure: self.onAccessTokenError)
    }
    
    func getCurrentAccount(callback:((Account?)->Void)){
        
        self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("account retrieved successfully");
            let a = Account().initWithDictionary(response as! NSDictionary)
            callback(a);
            
        }) { (AFHTTPRequestOperation, NSError) -> Void in
            callback(nil);
            println("retrieving account failed");
        }
    }
    
    func getHomeTimeline(callback:(([Tweet]?)->Void)) {
        
        // ?count=20&since_id=12345
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("timeline retrieved successfully");
            let tweets = Tweet.fromArray(response as! NSArray)
            callback(tweets);
            
            }) { (AFHTTPRequestOperation, NSError) -> Void in
                callback(nil);
                println("retrieving timeline failed");
        }
    }
    
    private func onRequestTokenSuccess(requestToken:BDBOAuth1Credential!) {
    
        println("request token retrieved")
        let urlString = String(format: "%@/oauth/authorize?oauth_token=%@", TwitterClient.kBaseUrl, requestToken.token)
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    private func onRequestTokenError(error:NSError!) {
        
        UIAlertView(title: "Error", message: "request token failed", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    private func onAccessTokenSuccess(accessToken:BDBOAuth1Credential!) {
        
        println("access token retrieved")
        self.requestSerializer.saveAccessToken(accessToken)
        //let urlString = String(format: "%@/oauth/authorize?oauth_token=%@", TwitterClient.kBaseUrl, requestToken)
        //let url = NSURL(string: urlString)
        //UIApplication.sharedApplication().openURL(url!)
        
        self.getCurrentAccount { (account:Account?) -> Void in
            println(account == nil ? "no Account" : ("there we go Account: " + account!.screenName))
        }
        
        self.getHomeTimeline { (tweets: [Tweet]?) -> Void in
            let count = tweets?.count ?? 0
            println(tweets == nil ? "no tweets" : ("there we go tweets: " + count.description))
            if tweets != nil {
                for tweet in tweets! {
                    println(String(format:"%@ - %@", tweet.createdAt!.timeAgo(), tweet.text))
                }
            }
        }
    }
    
    private func onAccessTokenError(error:NSError!) {
        
        UIAlertView(title: "Error", message: "access token failed", delegate: nil, cancelButtonTitle: "OK").show()
    }
}
