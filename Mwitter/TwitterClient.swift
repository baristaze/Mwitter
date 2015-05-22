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
    
    func requestAccessToken() -> Void {
        
        self.requestSerializer.removeAccessToken()
        
        self.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string:"cptwitterdemo://oath"),
            scope: nil,
            success: self.onRequestTokenSuccess,
            failure: self.onRequestTokenError)
    }
    
    func fetchAuthorizeToken(requestToken:BDBOAuth1Credential!) -> Void {
        
        self.fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: self.onAccessTokenSuccess,
            failure: self.onAccessTokenError)
    }
    
    private func onRequestTokenSuccess(requestToken:BDBOAuth1Credential!) -> Void {
    
        println("request token retrieved")
        let urlString = String(format: "%@/oauth/authorize?oauth_token=%@", TwitterClient.kBaseUrl, requestToken.token)
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    private func onRequestTokenError(error:NSError!) -> Void {
        
        UIAlertView(title: "Error", message: "request token failed", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    private func onAccessTokenSuccess(accessToken:BDBOAuth1Credential!) -> Void {
        
        println("access token retrieved")
        self.requestSerializer.saveAccessToken(accessToken)
        //let urlString = String(format: "%@/oauth/authorize?oauth_token=%@", TwitterClient.kBaseUrl, requestToken)
        //let url = NSURL(string: urlString)
        //UIApplication.sharedApplication().openURL(url!)
    }
    
    private func onAccessTokenError(error:NSError!) -> Void {
        
        UIAlertView(title: "Error", message: "access token failed", delegate: nil, cancelButtonTitle: "OK").show()
    }
}
