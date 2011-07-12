//
//  UserProfileViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//

@interface UserProfileViewController : UITableViewController <UIAlertViewDelegate> {
}

@property (nonatomic, retain) NSString *userScreenName;
@property (nonatomic, retain) NSMutableArray *userTweetStream;

-(void) returnToMainScreen;

@end
