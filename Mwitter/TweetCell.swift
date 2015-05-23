//
//  TweetCell.swift
//  Mwitter
//
//  Created by Baris Taze on 5/23/15.
//  Copyright (c) 2015 Baris Taze. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearSpaceBeforeRowLine()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadDataFrom(tweet:Tweet) {
        
        self.userPhotoView.setImageWithURL(NSURL(string:tweet.user!.profileImageUrl))
        self.nameLabel.text = tweet.user!.name
        self.screenNameLabel.text = "@" + tweet.user!.name
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
}
