//
//  TwitterFeedAppDelegate.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/1/11.
//



@class TweetFeedViewController;
@class UserProfileViewController;

@class TweetFeedViewController;

@interface TwitterFeedAppDelegate : NSObject <UIApplicationDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TweetFeedViewController *viewController;
@property (nonatomic, retain) IBOutlet UserProfileViewController *userProfileViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
