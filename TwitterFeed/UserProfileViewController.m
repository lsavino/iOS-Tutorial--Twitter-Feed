//
//  UserProfileViewController.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import "UserProfileViewController.h"
#import "URLWrapper.h"
#import "JSONKit.h" //Debug: These aren't part of the public 'interface'--so should they be in the header or here?

@implementation UserProfileViewController

@synthesize userScreenName = m_userScreenName;
@synthesize userTweetStream = m_userTweetStream;


- (id)init{
	[super initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style{
	return [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[self userTweetStream] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if(cell == nil){
		[cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"] autorelease];
	}
	
	if([indexPath row] < [[self userTweetStream] count]){
		NSString *tweetCurrent = [[[self userTweetStream] objectAtIndex:[indexPath row]] tweetText];
		[cell.detailTextLabel setText: tweetCurrent];
		[cell.detailTextLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[cell.detailTextLabel setNumberOfLines:0];
	}
	
	return cell;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated{
	[self setTitle:self.userScreenName];
	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", [self userScreenName]]]];
	
//	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", @"LeonardoDoreen4"]]];
	
	
	self.userTweetStream = [[NSMutableArray alloc] init];
	
	URLWrapper *tweetStreamConnection = [[URLWrapper alloc] initWithURLRequest:tweetStreamRequest connectionCompleted:^(NSData *data){
		NSArray *tweetStreamFull = [data objectFromJSONData];
		if ([(NSDictionary*)tweetStreamFull objectForKey:@"error"]) {
			UIAlertView *userProfileAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loading the requested user. Please choose another user." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[userProfileAlert show];
			[userProfileAlert release];
		}
		else{
			NSMutableDictionary *tweetDataFull;
			Tweet *tweet;
			for(int i = 0; i < [tweetStreamFull count]; i++){
				tweetDataFull = [tweetStreamFull objectAtIndex:i];
				tweet = [[Tweet alloc] initWithTweetText: [tweetDataFull objectForKey:@"text"]];
				[self.userTweetStream addObject:tweet];
				[tweet release];
			}
			[[self tableView] reloadData];
			tweetStreamFull = nil;
		}
	}];
	
	[tweetStreamConnection start];
	[tweetStreamConnection release];
	
	
	[super viewWillAppear:animated];

}

- (void)returnToMainScreen{
	
}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.userScreenName = nil;
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
