//
//  TwitterFeedAppDelegate.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/1/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetFeedViewController.h"

@class TweetFeedViewController;

@interface TwitterFeedAppDelegate : NSObject <UIApplicationDelegate> {
	
	TweetFeedViewController* viewController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TweetFeedViewController *viewController;

@end
