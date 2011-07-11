//
//  TweetFeedViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "URLWrapper.h"
#import "UserProfileViewController.h"

@interface TweetFeedViewController : UITableViewController {
	NSMutableArray *tweetTexts;
	UserProfileViewController *userProfileViewController;
}

@property (retain) NSMutableArray *tweets;

@end
