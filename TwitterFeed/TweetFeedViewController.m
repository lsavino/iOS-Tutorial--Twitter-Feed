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

/*
 * Collection of 20 most recent tweets from public timeline. 
 * Each tweet is an NSDictionary object with information 
 * about the specific tweet as well as the user account.
 */
@property (nonatomic, retain) NSMutableArray *tweets;

/*
 * Button text for failed connection; clicking this button will attempt to reload data without changing parameters.
 */
@property (nonatomic, retain) NSString *alertTextReload;

/*
 * This app only requests the most recent 20 tweets once; this ensures the table isn't reloaded with a fresh request.
 */
@property (nonatomic) BOOL didLoadInitialData;

- (void) loadUniversalTweetStream;
- (void)releaseProperties;

@end


@implementation TweetFeedViewController

@synthesize tweets = m_tweets;
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

/*
 * If user selected option to reload data, attempt connection again.
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if([buttonTitle isEqualToString:self.alertTextReload]){
		[self loadUniversalTweetStream];
	}
}

/*
 * Display one row per tweet returned (usually 20).
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.tweets count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView 
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *cellIdentifier = @"UITableViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease]; 
	}
	
	//Populate cell with data from URL connection only if the data has already been successfully returned.
	if([indexPath row] < [self.tweets count]){
		Tweet *currentTweet = [self.tweets objectAtIndex:[indexPath row]];
		NSDictionary *currentTweetData = currentTweet.tweetData;
		cell.textLabel.text = [[currentTweetData objectForKey:@"user"] objectForKey:@"screen_name"];
		cell.imageView.image = currentTweet.userPhoto;

		cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
		cell.detailTextLabel.numberOfLines = 3;
		cell.detailTextLabel.text = [currentTweet.tweetData objectForKey:@"text"];

	}

	return cell;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UserProfileViewController *userProfileViewController = [[UserProfileViewController alloc] init];
	NSInteger row = [indexPath row];
	Tweet *currentTweet = [self.tweets objectAtIndex:row];
	userProfileViewController.userScreenName = [[currentTweet.tweetData objectForKey:@"user"] objectForKey:@"screen_name"];

	[self.navigationController pushViewController:userProfileViewController animated:YES];
	[userProfileViewController release];

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
	
	//Block to call when Twitter feed data is completely returned
	void (^tweetFeedBlock)(NSData*) = ^(NSData *data){
		dispatch_queue_t photoQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		self.tweets = [[[NSMutableArray alloc] init] autorelease];
		
		NSArray *tweetDataFromConnection = [data objectFromJSONData];

		//Fill tweetTexts from tweets:
		int tweetIndex = 0;
		for(NSDictionary *tweetCurrent in tweetDataFromConnection){
			NSDictionary *user = [tweetCurrent objectForKey:@"user"];
			NSURL *photoURL = [NSURL URLWithString:[user objectForKey:@"profile_image_url"]];
			Tweet *tweetText = [[Tweet alloc] initWithDictionary:tweetCurrent];
			
			void (^tweetConnectionCompletedBlock)(NSData*) = ^(NSData *data){
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
			};
			
			void (^tweetConnectionFailedBlock)(NSError*) = ^(NSError *error){
				NSLog(@"Tweet image load error: %@", error);
			};
			
			URLWrapper *tweetURLRequest = [[URLWrapper alloc] initWithURLRequest:[NSURLRequest requestWithURL:photoURL] connectionCompleted:tweetConnectionCompletedBlock connectionFailed:tweetConnectionFailedBlock];
			
			[tweetURLRequest start];			
			[tweetURLRequest release];
			
			[self.tweets addObject:tweetText];
			[tweetText release];
			tweetIndex++;
		}
		
		[self.tableView reloadData];

	};
	
	void (^failBlock)(NSError*) = ^(NSError *error){
		NSLog(@"Tweet connection error: %@", error);
		UIAlertView *tweetConnectionFail = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error; please try again." delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:self.alertTextReload, nil];
		[tweetConnectionFail show];
		[tweetConnectionFail release];
		self.tweets = nil;
		
	};
	
	URLWrapper *tweetFeedRequest = [[URLWrapper alloc] initWithURLRequest:twitterRequest connectionCompleted:tweetFeedBlock connectionFailed:failBlock];
	[tweetFeedRequest start];
	[tweetFeedRequest release];
	

}

- (void)releaseProperties{
	self.tweets = nil;
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
