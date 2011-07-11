//
//  TweetFeedViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "URLWrapper.h"
#import "UserProfileViewController.h"

@interface TweetFeedViewController : UITableViewController <UIAlertViewDelegate> { 
	NSMutableArray *tweetTexts;
	UserProfileViewController *userProfileViewController;
}

@property (retain) NSMutableArray *tweets;

- (void) loadUniversalTweetStream;

@end
