//
//  TimelineViewController.swift
//  Mwitter
//
//  Created by Baris Taze on 5/22/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    var infiniteLoadingStarted = false
    
    private var tweets = [Tweet]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // create refreshing control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        self.loadMoreTweets(false, endInfiniteLoad:false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        (UIApplication.sharedApplication().delegate as! AppDelegate).startLoginStoryBoard()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("tweet.cell", forIndexPath: indexPath) as! TweetCell
        var tweet = self.tweets[indexPath.row]
        cell.reloadDataFrom(tweet)
        
        //if(!self.infiniteLoadingStarted && indexPath.row == (self.tweets.count-1)){
        //    self.loadMoreTweets(false, endInfiniteLoad: true)
        //}
        
        return cell
    }
    
    func onRefresh() {
        self.loadMoreTweets(true, endInfiniteLoad: false);
    }
    
    func loadMoreTweets(endRefreshing:Bool, endInfiniteLoad:Bool){
        
        let showSpinner = !endRefreshing && !endInfiniteLoad
        var sinceId:Int64? = self.tweets.count > 0 ? self.tweets[0].id : nil
        TwitterClient.sharedInstance.getHomeTimelineSince(sinceId) { (tweets:[Tweet]?) -> Void in
            if(tweets != nil){
                if(endRefreshing){
                    var index = 0
                    for tweet in tweets! {
                        self.tweets.insert(tweet, atIndex: index++)
                    }
                }
                else {
                    for tweet in tweets! {
                        self.tweets.append(tweet)
                    }
                }
                
                self.tableView.reloadData()
            }
            
            if(endRefreshing){
                self.refreshControl.endRefreshing()
            }
            
            if(endInfiniteLoad){
                self.infiniteLoadingStarted = false;
            }
        }
    }
}

