//
//  UserProfileViewController.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserProfileViewController : UIViewController {
    
}

@property (nonatomic, retain) NSString *userScreenName;
@property (nonatomic, retain) IBOutlet UILabel *userScreenNameDisplayed;

@end
