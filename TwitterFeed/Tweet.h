//
//  Tweet.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
}

/*
 * Data pulled from Twitter about this particular tweet; includes things like tweet created date, tweet text, user name, user account creation date, etc. See Twitter API for full documentation.
 */

@property (nonatomic, retain) NSDictionary *tweetData;


/*
 * Photo created from user's photo URL (in profile_image_url)
 */
@property (nonatomic, retain) UIImage *userPhoto;

/*
 * Initializes Tweet object with data from Twitter's feed.
 *
 * This is the designated initializer.
 */
- (id)initWithDictionary: (NSDictionary *)dataDictionary;


@end
