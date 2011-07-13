//
//  UserProfileViewController.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "UserProfileViewController.h"
#import "URLWrapper.h"
#import "JSONKit.h" 

@interface UserProfileViewController ()  <UIAlertViewDelegate>{
	
}
@property (nonatomic, retain) NSMutableArray *userTweetStream;

- (void)releaseProperties;

@end

@implementation UserProfileViewController

@synthesize userScreenName = m_userScreenName;
@synthesize userTweetStream = m_userTweetStream;


- (id)init{
	self = [self initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style{
	self = [super initWithStyle:style];
	return self;;
}

- (void)dealloc
{
	[self releaseProperties];
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
	return [self.userTweetStream count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"UITableViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	
	if([indexPath row] < [self.userTweetStream count]){
		NSString *tweetCurrent = [[self.userTweetStream objectAtIndex:[indexPath row]] tweetText];

		cell.detailTextLabel.text = tweetCurrent;
		cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.detailTextLabel.numberOfLines = 3;
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
	[super viewWillAppear:animated];
	
	self.title = self.userScreenName;

	NSString *tweetStreamSource = [NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", self.userScreenName];
	NSURL *tweetStreamURL = [NSURL URLWithString:tweetStreamSource];
	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:tweetStreamURL];
	
//	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", @"LeonardoDoreen4"]]];
	
	self.userTweetStream = [[[NSMutableArray alloc] init] autorelease];
	
	URLWrapper *tweetStreamConnection = [[URLWrapper alloc] initWithURLRequest:tweetStreamRequest connectionCompleted:^(NSData *data){
		
		id tweetStreamFull = [data objectFromJSONData];
		
		//If error was returned (because user is blocked or other reason), JSON comes back as a dictionary object of the form {error = "message", request = "/request.json"}. Otherwise, data is an array.

		if ([tweetStreamFull isKindOfClass:[NSDictionary class]] && [tweetStreamFull objectForKey:@"error"]){
			UIAlertView *userProfileAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loading the requested user. Please choose another user." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[userProfileAlert show];
			[userProfileAlert release];
		}
		else{
			NSMutableArray *tweetStreamFullArray = tweetStreamFull;
			for(NSMutableDictionary *tweetDataFull in tweetStreamFullArray){
				Tweet *tweet = [[Tweet alloc] initWithTweetText: [tweetDataFull objectForKey:@"text"]];
				[self.userTweetStream addObject:tweet];
				[tweet release];
			}
			[self.tableView reloadData];
			tweetStreamFullArray = nil;
		}
	}];
	
	[tweetStreamConnection start];
	[tweetStreamConnection release];

}

- (void)releaseProperties{
	self.userScreenName = nil;
	self.userTweetStream = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[self releaseProperties];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
