//
//  UserProfileViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//

/*
 * Displays user name with user's 20 most recent tweets
 */

@interface UserProfileViewController : UITableViewController {
}


/*
 * Screen name used to pull user's most recent tweets from Twitter.
 *
 * No default value.
 */
@property (nonatomic, copy) NSString *userScreenName;


/*
 * This is the designated initializer for the class.
 */
- (id) initWithStyle:(UITableViewStyle)style;


/*
 * Initializes the view with style: UITableViewStyleGrouped; provided as convenience method.
 */
- (id) init;

@end
