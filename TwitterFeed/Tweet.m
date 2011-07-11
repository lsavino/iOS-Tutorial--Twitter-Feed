//
//  Tweet.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

@synthesize photoSource, screenName, tweetText, userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL{
	if(self = [super init]){
		[self setScreenName:name];
		[self setTweetText:tweetTextContent];
		[self setPhotoSource:URL];
	}
	
	return self;
}

-(NSString *) description{
	return [NSString stringWithFormat:@"screenName: %@, tweetText: %@", screenName, tweetText];
}


-(void) dealloc{
	[userPhoto release];
	[super dealloc];
}

@end
