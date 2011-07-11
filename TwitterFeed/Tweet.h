//
//  Tweet.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
    NSURL *photoSource;
	NSString *screenName;
	NSString *tweetText;
	UIImage *userPhoto;
}

@property (retain) NSURL *photoSource;
@property (retain) NSString *screenName;
@property (retain) NSString *tweetText;
@property (retain) UIImage *userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL; 
-(id) initWithTweetText: (NSString*) tweetTextContent;

-(NSString *) description;
@end
