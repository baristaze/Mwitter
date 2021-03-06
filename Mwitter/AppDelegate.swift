//
//  AppDelegate.swift
//  Mwitter
//
//  Created by Baris Taze on 5/22/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TwitterClientProtocol {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var user = Account.currentUser()
        if(user != nil) {
            self.startTweetoStoryBoard()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        TwitterClient.sharedInstance.delegate = self
        TwitterClient.sharedInstance.openUrl(url)
        return true
    }
    
    func onLoginTwitter() {
        TwitterClient.sharedInstance.getCurrentAccount({ (account:Account?) -> Void in
            if(account != nil){
                account!.saveAsCurrentUser()
                self.startTweetoStoryBoard()
            }
        })
    }
    
    func startTweetoStoryBoard() {
        var tweeto = UIStoryboard(name: "Tweeto", bundle: nil)
        let viewcontroller: UIViewController = tweeto.instantiateInitialViewController() as! UIViewController
        //let viewcontroller: UIViewController = tweeto.instantiateViewControllerWithIdentifier("timelineVC") as! UIViewController
        self.window!.rootViewController = viewcontroller
    }
    
    func startLoginStoryBoard() {
        var loginSB = UIStoryboard(name: "Login", bundle: nil)
        let viewcontroller: UIViewController = loginSB.instantiateInitialViewController() as! UIViewController
        //let viewcontroller: UIViewController = loginSB.instantiateViewControllerWithIdentifier("loginVC") as! UIViewController
        self.window!.rootViewController = viewcontroller
    }
}

