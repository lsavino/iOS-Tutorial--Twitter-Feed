//
//  Tweet.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
}

@property (nonatomic, retain) NSURL *photoSource;
@property (nonatomic, retain) NSString *screenName;
@property (nonatomic, retain) NSString *tweetText;
@property (nonatomic, retain) UIImage *userPhoto;

-(id) initWithName: (NSString*) name tweetTextContent:(NSString*) tweetTextContent URL:(NSURL*) URL; 
-(id) initWithTweetText: (NSString*) tweetTextContent;


@end
