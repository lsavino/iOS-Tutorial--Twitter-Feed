//
//  TweetFeedViewController.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//


#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

#import "UserProfileViewController.h"
#import "TweetFeedViewController.h"
#import "JSONKit.h"
#import "Tweet.h"
#import "URLWrapper.h"

@interface TweetFeedViewController () <UIAlertViewDelegate>

@property (nonatomic, retain) NSString *alertTextReload;
@property (nonatomic) BOOL didLoadInitialData;
@property (nonatomic, retain) NSMutableArray *tweetTexts;
@property (nonatomic, retain) UserProfileViewController *userProfileViewController;

- (void) loadUniversalTweetStream;
- (void)releaseProperties;

@end


@implementation TweetFeedViewController

@synthesize tweets = m_tweets;
@synthesize tweetTexts = m_tweetTexts;
@synthesize userProfileViewController = m_userProfileViewController;
@synthesize alertTextReload = m_alertTextReload;
@synthesize didLoadInitialData = m_didLoadInitialData;

- (id)init{
	self = [self initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style{
	if((self = [super initWithStyle:style])){
		self.alertTextReload = @"retry";
		self.didLoadInitialData = NO;
	}
	return self;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if([buttonTitle isEqualToString:self.alertTextReload]){
		[self loadUniversalTweetStream];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.tweetTexts count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView 
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier = @"UITableViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease]; 
	}
	
	if([indexPath row] < [self.tweetTexts count]){
		Tweet *tweetText = [self.tweetTexts objectAtIndex:[indexPath row]];

		cell.textLabel.text = tweetText.screenName;
		cell.imageView.image = tweetText.userPhoto;

		cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.detailTextLabel.numberOfLines = 3;
		cell.detailTextLabel.text = tweetText.tweetText;

	}

	return cell;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(self.userProfileViewController == nil){
		self.userProfileViewController = [[[UserProfileViewController alloc] init] autorelease];
	}
	
	NSInteger row = [indexPath row];
	Tweet *currentTweet = [self.tweetTexts objectAtIndex:row];
	self.userProfileViewController.userScreenName = [currentTweet screenName];

	[self.navigationController pushViewController:self.userProfileViewController animated:YES];

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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if(!self.didLoadInitialData){
		[self loadUniversalTweetStream];
		self.didLoadInitialData = YES;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Recent tweets";
}


- (void) loadUniversalTweetStream{
	NSURL *feedURL = [NSURL URLWithString:@"https://api.twitter.com/statuses/public_timeline.json"];
//	NSURL *feedURL = [NSURL URLWithString:@"https://awefawoeighlariueghiaeruksiergh.com"];
	NSURLRequest *twitterRequest = [NSURLRequest requestWithURL:feedURL];
	
	//Callback when Twitter feed data is complete
	void (^tweetFeedBlock)(NSData*) = ^(NSData *data){
		dispatch_queue_t photoQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		
		self.tweets = [data objectFromJSONData];

		self.tweetTexts = [[[NSMutableArray alloc] init] autorelease];

		//Fill tweetTexts from tweets:
		int tweetIndex = 0;
		for(NSDictionary *tweetCurrent in self.tweets){
			NSDictionary *user = [tweetCurrent objectForKey:@"user"];
			NSURL *photoURL = [NSURL URLWithString:[user objectForKey:@"profile_image_url"]];
			Tweet *tweetText = [[Tweet alloc] initWithName:[user objectForKey:@"screen_name"] tweetTextContent:[tweetCurrent objectForKey:@"text"] URL:photoURL];
			
			URLWrapper *tweetURLRequest = [[URLWrapper alloc] initWithURLRequest:[NSURLRequest requestWithURL:photoURL] connectionCompleted:^(NSData *data){

				dispatch_async(photoQueue,^{
					UIImage *userPhoto = [[UIImage alloc] initWithData:data];
					tweetText.userPhoto = userPhoto;
					dispatch_async( dispatch_get_main_queue(), ^{
						NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tweetIndex inSection:0];
						NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
						[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
					});
					[userPhoto release];
				}); 
				
			}];
			
			[tweetURLRequest start];			
			[tweetURLRequest release];

			[self.tweetTexts addObject:tweetText];
			[tweetText release];
			tweetIndex++;
		}
		
		[self.tableView reloadData];

	};
	
	// JSS: what if one of your specific tweet requests fails?
	void (^failBlock)() = ^(){
		NSLog(@"Fail callback.");
		UIAlertView *tweetConnectionFail = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error; please try again." delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:self.alertTextReload, nil];
		[tweetConnectionFail show];
		[tweetConnectionFail release];
		
	};
	
	URLWrapper *tweetFeedRequest = [[URLWrapper alloc] initWithURLRequest:twitterRequest connectionCompleted:tweetFeedBlock connectionFailed:failBlock];
	[tweetFeedRequest start];
	[tweetFeedRequest release];
	

}

- (void)releaseProperties{
	self.tweetTexts = nil;
	self.tweets = nil;
	self.userProfileViewController = nil;
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
