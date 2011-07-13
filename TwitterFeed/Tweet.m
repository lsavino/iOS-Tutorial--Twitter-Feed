//
//  Tweet.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import "Tweet.h"


@implementation Tweet

@synthesize photoSource, screenName, tweetText, userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL{
	if((self = [super init])){
		self.screenName = name;
		self.tweetText = tweetTextContent;
		self.photoSource = URL;
	}
	
	return self;
}

-(id) initWithTweetText: (NSString*) tweetTextContent{
	// JSS: initializers are allowed to return an object different from the
	// current value of "self" -- consequently, you should ALWAYS assign the
	// result to "self" (which is, after all, just a variable)
	[self initWithName:nil tweetTextContent:tweetTextContent URL:nil];
	return self;
}

-(NSString *) description{
	return [NSString stringWithFormat:@"screenName: %@, tweetText: %@", screenName, tweetText];
}


-(void) dealloc{
	// JSS:x prefer setting properties to nil to calling -release (since it stays
	// correct regardless of the property's memory management semantics)
	//
	// JSS:x missing any properties here?
	self.userPhoto = nil;
	self.tweetText = nil;
	self.photoSource = nil;
	[super dealloc];
}

@end
