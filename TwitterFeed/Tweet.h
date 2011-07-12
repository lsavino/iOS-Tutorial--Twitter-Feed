//
//  Tweet.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
	// JSS: no need for ivars
    NSURL *photoSource;
	NSString *screenName;
	NSString *tweetText;
	UIImage *userPhoto;
}

// JSS: properties should be declared "nonatomic" unless you have a specific
// reason to make them atomic (like if this class were meant to be thread-safe)
@property (retain) NSURL *photoSource;
@property (retain) NSString *screenName;
@property (retain) NSString *tweetText;
@property (retain) UIImage *userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL; 
-(id) initWithTweetText: (NSString*) tweetTextContent;

-(NSString *) description;
@end
