//
//  Tweet.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import "Tweet.h"

@interface Tweet ()
-(NSString *) description;
@end

@implementation Tweet

@synthesize photoSource = m_photoSource;
@synthesize screenName = m_screenName;
@synthesize tweetText = m_tweetText;
@synthesize userPhoto = m_userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL{
	if((self = [super init])){
		self.screenName = name;
		self.tweetText = tweetTextContent;
		self.photoSource = URL;
	}
	
	return self;
}

-(id) initWithTweetText: (NSString*) tweetTextContent{
	self = [self initWithName:nil tweetTextContent:tweetTextContent URL:nil];
	return self;
}

-(NSString *) description{
	return [NSString stringWithFormat:@"screenName: %@, tweetText: %@", self.screenName, self.tweetText];
}


-(void) dealloc{
	self.userPhoto = nil;
	self.tweetText = nil;
	self.photoSource = nil;
	[super dealloc];
}

@end
