//
//  Candidate.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Candidate : NSObject {
    NSURL *photoSource;
	NSString *screenName;
	NSString *tweetText;
	UIImage *userPhoto;
	NSMutableData *photoData;
	id responseData; //Debug: Can I have this here? Can I synthesize an id? I think not...
}

@property (retain) NSURL *photoSource;
@property (retain) NSString *screenName;
@property (retain) NSString *tweetText;
@property (retain) UIImage *userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL; 


-(NSString *) description;
@end
