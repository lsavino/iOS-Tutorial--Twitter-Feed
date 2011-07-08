//
//  Candidate.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import "Candidate.h"


@implementation Candidate

@synthesize photoSource, screenName, tweetText, userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL{
	if(self = [super init]){
		[self setScreenName:name];
		[self setTweetText:tweetTextContent];
		[self setPhotoSource:URL];
//		NSURLRequest *photoRequest = [NSURLRequest requestWithURL:url];
//		NSURLConnection *photoConnection = [NSURLConnection connectionWithRequest:photoRequest delegate:self];
//		[photoConnection start];
	}
	
	return self;
}

//-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//	if(!photoData){
//		photoData = [[NSMutableData alloc] init];
//	}
//	[photoData appendData:data];
//}
//
//-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
//	[self setUserPhoto:[[UIImage alloc] initWithData:photoData]];
//	[photoData release];
//}

-(NSString *) description{
	return [NSString stringWithFormat:@"photoSource: %@, screenName: %@, tweetText: %@", photoSource, screenName, tweetText];
}


-(void) dealloc{
	[userPhoto release];
	[super dealloc];
}

@end
