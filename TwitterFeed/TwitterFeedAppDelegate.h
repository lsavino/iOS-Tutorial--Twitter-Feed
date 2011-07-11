//
//  TwitterFeedAppDelegate.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/1/11.
//

#import <UIKit/UIKit.h>
#import "TweetFeedViewController.h"
#import "UserProfileViewController.h"

@class TweetFeedViewController;

@interface TwitterFeedAppDelegate : NSObject <UIApplicationDelegate> {
	
	TweetFeedViewController *viewController;
	UserProfileViewController *userProfileViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TweetFeedViewController *viewController;
@property (nonatomic, retain) IBOutlet UserProfileViewController *userProfileViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
