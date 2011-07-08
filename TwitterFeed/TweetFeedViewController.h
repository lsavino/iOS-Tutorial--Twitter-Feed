//
//  TweetFeedViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "URLWrapper.h"

@interface TweetFeedViewController : UITableViewController {
	NSMutableArray *candidates;
}

@property (retain) NSMutableArray *tweets;

@end
