//
//  TweetFeedViewController.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/3/11.
//

#import "TwitterFeedAppDelegate.h" //Debug: is this a bad idea? How do we know we're not creating a retain cycle by referencing the parent?
#import "TweetFeedViewController.h"
#import "JSONKit.h"


@implementation TweetFeedViewController

@synthesize tweets;

- (id)init{
	[super initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style{
	return [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [tweetTexts count];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 1){
		[self loadUniversalTweetStream];
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView 
		  cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"] autorelease]; 
	}
	
	if([indexPath row] < [tweetTexts count]){
		Tweet *tweetText = [tweetTexts objectAtIndex:[indexPath row]];

		[[cell textLabel] setText:tweetText.screenName];
		[[cell imageView] setImage:tweetText.userPhoto];

		[cell.detailTextLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[cell.detailTextLabel setNumberOfLines:3];
		[[cell detailTextLabel] setText:tweetText.tweetText];

	}

	return cell;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 100;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	TwitterFeedAppDelegate *appDelegate = (TwitterFeedAppDelegate*)[[UIApplication sharedApplication] delegate];
	UINavigationController *navigationController = appDelegate.navigationController;
	if(userProfileViewController == nil){
		userProfileViewController = [[UserProfileViewController alloc] init];
	}
	
	[userProfileViewController setUserScreenName:[[tweetTexts objectAtIndex:[indexPath row]] screenName]];
	[navigationController pushViewController:userProfileViewController animated:YES];
	[userProfileViewController release];
	userProfileViewController = nil;

}

- (void)dealloc
{
	[tweetTexts release];
	[tweets release];
	[userProfileViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{//Debug: I'd actually like this to run before the view loads, and for the table view to load after this method returns. Is there a method to that effect?
    [super viewDidLoad];
	[self setTitle:@"Recent tweets"];
	[self loadUniversalTweetStream];
}


- (void) loadUniversalTweetStream{
	NSURL *feedURL = [NSURL URLWithString:@"https://api.twitter.com/statuses/public_timeline.json"];
	//NSURL *feedURL = [NSURL URLWithString:@"https://awefawoeighlariueghiaeruksiergh.com"];
	NSURLRequest *twitterRequest = [NSURLRequest requestWithURL:feedURL];
	
	//Callback when Twitter feed data is complete
	void (^tweetFeedBlock)(NSData*) = ^(NSData *data){
		[self setTweets:[data objectFromJSONData]];
		tweetTexts = [[NSMutableArray alloc] init];
		
		NSDictionary *tweetCurrent;
		NSDictionary *user;
		Tweet *tweetText;
		NSURL *photoURL;
		URLWrapper *tweetURLRequest;
		//Fill tweetTexts from tweets:
		for(int i = 0; i < [tweets count]; i++){
			tweetCurrent = [tweets objectAtIndex:i];
			user = [tweetCurrent objectForKey:@"user"];
			photoURL = [NSURL URLWithString:[user objectForKey:@"profile_image_url"]];
			tweetText = [[Tweet alloc] initWithName:[user objectForKey:@"screen_name"] tweetTextContent:[tweetCurrent objectForKey:@"text"] URL:photoURL];
			
			tweetURLRequest = [[URLWrapper alloc] initWithURLRequest:[NSURLRequest requestWithURL:photoURL] connectionCompleted:^(NSData *data){
				UIImage *userPhoto = [[UIImage alloc] initWithData:data];
				[tweetText setUserPhoto:userPhoto];
				[userPhoto release];
				[[self tableView] reloadData];
			}];
			
			[tweetURLRequest start];
			
			[tweetTexts addObject:tweetText];
			[tweetText release];
			
			[tweetURLRequest release]; 
			
		}
	};
	
	void (^failBlock)() = ^(){
		NSLog(@"Fail callback.");
		UIAlertView *tweetConnectionFail = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error; please try again." delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"retry", nil];
		[tweetConnectionFail show];
		[tweetConnectionFail release];
		
	};
	
	URLWrapper *tweetFeedRequest = [[URLWrapper alloc] initWithURLRequest:twitterRequest connectionCompleted:tweetFeedBlock connectionFailed:failBlock];
	[tweetFeedRequest start];
	[tweetFeedRequest release];
	

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[userProfileViewController release];
	userProfileViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
