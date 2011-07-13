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

// JSS:x As a rule of thumb, almost all imports should be private. Header files
// can use the @class statement when they need to reference other classes.

@interface UserProfileViewController ()  <UIAlertViewDelegate>{
	
}
@property (nonatomic, retain) NSMutableArray *userTweetStream;
@end

@implementation UserProfileViewController

@synthesize userScreenName = m_userScreenName;
@synthesize userTweetStream = m_userTweetStream;


- (id)init{
	// JSS:x initializers are allowed to return an object different from the
	// current value of "self" -- consequently, you should ALWAYS assign the
	// result to "self" (which is, after all, just a variable)
	self = [self initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style{
	// JSS:x perhaps it makes sense to reverse these two initializers, such that
	// -init calls -initWithStyle: with a predefined style?
	self = [super initWithStyle:style];
	return self;;
}

- (void)dealloc
{
	// JSS:x this is an extremely unorthodox and actually *dangerous* way to
	// release properties -- instead, just set it to nil and let its memory
	// management policy take care of it for you
	self.userScreenName = nil;
	self.userTweetStream = nil;
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
	// JSS:x this is more of a style thing, but try to be consistent in your
	// usage of property dot-syntax and message send syntax
	return [self.userTweetStream count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	// JSS:x usually, reuse identifiers are pulled out into a single variable
	// (rather than passed in as literal strings) so that they only have to be
	// changed or defined in one place
	static NSString *cellIdentifier = @"UITableViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		// JSS:x NEVER bracket an assignment in a message send -- extremely
		// offputting and may not do what you expect
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	
	if([indexPath row] < [self.userTweetStream count]){
		NSString *tweetCurrent = [[self.userTweetStream objectAtIndex:[indexPath row]] tweetText];

		// JSS:x you can use dot-syntax for these too, if you'd like
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
	// JSS:x for construction and appearance methods, calls to super should come
	// FIRST, unless you have a specific reason to do otherwise
	[super viewWillAppear:animated];
	
	self.title = self.userScreenName;

	// JSS:x long line alert!
	NSString *tweetStreamSource = [NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", self.userScreenName];
	NSURL *tweetStreamURL = [NSURL URLWithString:tweetStreamSource];
	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:tweetStreamURL];
	
//	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", @"LeonardoDoreen4"]]];
	
	// JSS:x leak!
	self.userTweetStream = [[[NSMutableArray alloc] init] autorelease];
	
	URLWrapper *tweetStreamConnection = [[URLWrapper alloc] initWithURLRequest:tweetStreamRequest connectionCompleted:^(NSData *data){
		
		id tweetStreamFull = [data objectFromJSONData];
		
		//If error was returned (because user is blocked or other reason), JSON comes back as a dictionary object of the form {error = "message", request = "/request.json"}. Otherwise, data is an array.
		//
		// JSS:x respondsToSelector: is valuable when you're checking for
		// functionality, but looking for a specific class is better modeled
		// with -isKindOfClass:
		//
		// JSS:x if a value might be any one of a number of classes, use "id"
		// rather than the specific type, and then you can always assign it to
		// a more specific variable once you know (thus avoiding the warning
		// here about using -objectForKey: on an array)
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

// JSS:x view controllers should generally be agnostic as to how or from where
//// they're presented (i.e., it might not be the main screen you're returning to)
//
//Removing this function; may add functionality later to dismiss user profile view on alert view dismissal
//- (void)returnToMainScreen{
//	
//}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{


	// JSS: if you find yourself with a lot of cleanup shared between
	// -viewDidUnload and -dealloc, it can make sense to abstract it out into
	// a single method
	self.userScreenName = nil;

	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	// JSS:x calls to super in destruction and disappearance methods should be at
	// the end (the opposite order of construction/appearance)
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
