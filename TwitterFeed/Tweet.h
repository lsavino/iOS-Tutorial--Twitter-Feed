//
//  Tweet.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
	// JSSx: no need for ivars
}

// JSS:x properties should be declared "nonatomic" unless you have a specific
// reason to make them atomic (like if this class were meant to be thread-safe)
@property (nonatomic, retain) NSURL *photoSource;
@property (nonatomic, retain) NSString *screenName;
@property (nonatomic, retain) NSString *tweetText;
@property (nonatomic, retain) UIImage *userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL; 
-(id) initWithTweetText: (NSString*) tweetTextContent;


@end
