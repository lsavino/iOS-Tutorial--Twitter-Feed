//
//  UserProfileViewController.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import "UserProfileViewController.h"


@implementation UserProfileViewController

@synthesize userScreenName = m_userScreenName;
@synthesize userScreenNameDisplayed = m_userScreenNameDisplayed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		NSLog(@"initializing with nibName: %@", nibNameOrNil);
    }
    return self;
}

- (void)dealloc
{
	[self.userScreenName release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"userProfile viewDidLoad");
}

- (void) viewWillAppear:(BOOL)animated{
	NSLog(@"view will appear");
	[self.userScreenNameDisplayed setText:self.userScreenName];
//	[m_userScreenNameDisplayed setText:@"setting text on m_"];
	[super viewWillAppear:animated];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[self setUserScreenName:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
