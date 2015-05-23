//
//  TweetCell.swift
//  Mwitter
//
//  Created by Baris Taze on 5/23/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

protocol TweetUpdateDelegate {
    func onFavorited(tweet:Tweet, responseTweet:Tweet, sender:TweetCell)
    func onRetweeted(tweet:Tweet, responseTweet:Tweet, sender:TweetCell)
}

class TweetCell: UITableViewCell {

    @IBOutlet private weak var userPhotoView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var screenNameLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    @IBOutlet private weak var tweetContentLabel: UILabel!
    @IBOutlet private weak var favCountLabel: UILabel!
    @IBOutlet private weak var retweetCountLabel: UILabel!
    @IBOutlet private weak var favoriteIcon: UIImageView!
    @IBOutlet private weak var retweetIcon: UIImageView!
    
    static let favoriteImage = UIImage(named: "favorite_default")
    static let favoriteOnImage = UIImage(named: "favorite_on")
    
    static let retweetImage = UIImage(named: "retweet_default")
    static let retweetOnImage = UIImage(named: "retweet_on")
    
    private var favoriteTapRecognizer:UITapGestureRecognizer?
    private var retweetTapRecognizer:UITapGestureRecognizer?
    
    private var currentTweet:Tweet?
    
    var delegate:TweetUpdateDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.clearSpaceBeforeRowLine()
        
        self.favoriteTapRecognizer = UITapGestureRecognizer(target:self, action:Selector("onFav:"))
        self.retweetTapRecognizer = UITapGestureRecognizer(target:self, action:Selector("onRetweet:"))
        self.favoriteIcon.addGestureRecognizer(self.favoriteTapRecognizer!)
        self.retweetIcon.addGestureRecognizer(self.retweetTapRecognizer!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadDataFrom(tweet:Tweet) {
        
        self.currentTweet = tweet
        
        self.userPhotoView.setImageWithURL(NSURL(string:tweet.user!.profileImageUrl))
        self.nameLabel.text = tweet.user!.name
        self.screenNameLabel.text = "@" + tweet.user!.screenName
        self.createdAtLabel.text = tweet.createdAt!.timeAgoSimple()
        self.tweetContentLabel.text = tweet.text
        self.favCountLabel.text = tweet.favoritesCount.description
        self.retweetCountLabel.text = tweet.retweetCount.description
        
        if tweet.favorited {
            self.favoriteIcon.image = TweetCell.favoriteOnImage
        }
        else {
            self.favoriteIcon.image = TweetCell.favoriteImage
        }
        
        if tweet.retweeted {
            self.retweetIcon.image = TweetCell.retweetOnImage   
        }
        else {
            self.retweetIcon.image = TweetCell.retweetImage
        }
    }
    
    func clearSpaceBeforeRowLine() {
        
        if (self.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:"))){
            self.preservesSuperviewLayoutMargins = false
        }
        if (self.respondsToSelector(Selector("setSeparatorInset:"))){
            self.separatorInset = UIEdgeInsetsMake(0, 4, 0, 0)
        }
        if (self.respondsToSelector(Selector("setLayoutMargins:"))){
            self.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func onFav(recognizer:UITapGestureRecognizer){
        println("tap")
        TwitterClient.sharedInstance.favoriteById(self.currentTweet!.id, callback: { (updatedTweet:Tweet?) -> Void in
            if(updatedTweet != nil) {
                self.delegate?.onFavorited(self.currentTweet!, responseTweet: updatedTweet!, sender:self)
            }
        })
    }
    
    func onRetweet(recognizer:UITapGestureRecognizer){
        println("tap")
        TwitterClient.sharedInstance.retweetById(self.currentTweet!.id, callback: { (updatedTweet:Tweet?) -> Void in
            if(updatedTweet != nil) {
                self.delegate?.onRetweeted(self.currentTweet!, responseTweet: updatedTweet!, sender:self)
            }
        })
    }
}
