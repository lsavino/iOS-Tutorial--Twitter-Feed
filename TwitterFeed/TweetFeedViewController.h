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
	// JSS: no need for ivars
	NSMutableArray *tweetTexts;
	UserProfileViewController *userProfileViewController;
}

// JSS: properties should be declared "nonatomic" unless you have a specific
// reason to make them atomic
@property (retain) NSMutableArray *tweets;

- (void) loadUniversalTweetStream;

@end
