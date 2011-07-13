//
//  TweetFeedViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//


@class UserProfileViewController;

@interface TweetFeedViewController : UITableViewController  { 
	// JSS:x no need for ivars
}

// JSS:x properties should be declared "nonatomic" unless you have a specific
// reason to make them atomic
@property (nonatomic, retain) NSMutableArray *tweets;


@end
