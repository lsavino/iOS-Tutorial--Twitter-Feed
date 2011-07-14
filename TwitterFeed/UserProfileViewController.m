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

- (void)fetchUserTweetStream;
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
    [super didReceiveMemoryWarning];
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
		NSDictionary *tweetCurrent = [self.userTweetStream objectAtIndex:[indexPath row]];

		cell.detailTextLabel.text = [tweetCurrent objectForKey:@"text"];
		cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.detailTextLabel.numberOfLines = 3;
	}
	
	return cell;
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	//Set view title with user screen name
	self.title = self.userScreenName;
	[self fetchUserTweetStream];

}

//Fetch stream of most recent tweets from designated user

- (void)fetchUserTweetStream{
		NSString *tweetStreamSource = [NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", self.userScreenName];
	NSURL *tweetStreamURL = [NSURL URLWithString:tweetStreamSource];
	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:tweetStreamURL];
	
	self.userTweetStream = [[[NSMutableArray alloc] init] autorelease];
	
	//Block for connection completion
	void (^tweetStreamConnectionSuccess)(NSData*) = ^(NSData *data){
		id tweetStreamFull = [data objectFromJSONData];
		
		//Error case: if user is blocked or other error occurs, JSON comes back as a dictionary object of the form {error = "message", request = "/request.json"}
		if ([tweetStreamFull isKindOfClass:[NSDictionary class]] && [tweetStreamFull objectForKey:@"error"]){
			UIAlertView *userProfileAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loading the requested user. Please choose another user." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
			[userProfileAlert show];
			[userProfileAlert release];
		}
		
		//Success case: data is array of NSDictionary objects. Set userTweetStream, which serves as data source for table rows
		else{
			self.userTweetStream = tweetStreamFull;
			[self.tableView reloadData];
		}
		
	};
	
	void (^tweetStreamConnectionFailBlock)(NSError*) = ^(NSError *error){
		NSLog(@"User stream load error: %@", error);
	};
	
	URLWrapper *tweetStreamConnection = [[URLWrapper alloc] initWithURLRequest:tweetStreamRequest connectionCompleted:tweetStreamConnectionSuccess connectionFailed:tweetStreamConnectionFailBlock];
	
	[tweetStreamConnection start];
	[tweetStreamConnection release];
}

- (void)releaseProperties{
	self.userScreenName = nil;
	self.userTweetStream = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
	[self releaseProperties];
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[self releaseProperties];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
