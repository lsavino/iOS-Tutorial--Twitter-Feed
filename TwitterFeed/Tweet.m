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

@synthesize tweetData = m_tweetData;
@synthesize userPhoto = m_userPhoto;

- (id)initWithDictionary: (NSDictionary *) dataDictionary{
	if((self = [super init])){
		self.tweetData = dataDictionary;
	}
	
	return self;
}

-(NSString *) description{
	NSDictionary *user = [self.tweetData objectForKey:@"user"];
	NSString *userName = [user objectForKey:@"screen_name"];
	NSString *tweetText = [self.tweetData objectForKey:@"text"];
	return [NSString stringWithFormat:@"screenName: %@, tweetText: %@", userName, tweetText];
}


-(void) dealloc{
	self.userPhoto = nil;
	self.tweetData = nil;
	[super dealloc];
}

@end
