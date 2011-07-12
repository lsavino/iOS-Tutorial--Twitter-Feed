//
//  UserProfileViewController.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/8/11.
//

#import "UserProfileViewController.h"
#import "URLWrapper.h"

// JSS: As a rule of thumb, almost all imports should be private. Header files
// can use the @class statement when they need to reference other classes.
#import "JSONKit.h" //Debug: These aren't part of the public 'interface'--so should they be in the header or here?

@implementation UserProfileViewController

@synthesize userScreenName = m_userScreenName;
@synthesize userTweetStream = m_userTweetStream;


- (id)init{
	// JSS: initializers are allowed to return an object different from the
	// current value of "self" -- consequently, you should ALWAYS assign the
	// result to "self" (which is, after all, just a variable)
	[super initWithStyle:UITableViewStyleGrouped];
	return self;
}

- (id) initWithStyle:(UITableViewStyle)style{
	// JSS: perhaps it makes sense to reverse these two initializers, such that
	// -init calls -initWithStyle: with a predefined style?
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
	// JSS: this is an extremely unorthodox and actually *dangerous* way to
	// release properties -- instead, just set it to nil and let its memory
	// management policy take care of it for you
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
	// JSS: this is more of a style thing, but try to be consistent in your
	// usage of property dot-syntax and message send syntax
	return [[self userTweetStream] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	// JSS: usually, reuse identifiers are pulled out into a single variable
	// (rather than passed in as literal strings) so that they only have to be
	// changed or defined in one place
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if(cell == nil){
		// JSS: NEVER bracket an assignment in a message send -- extremely
		// offputting and may not do what you expect
		[cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"] autorelease];
	}
	
	if([indexPath row] < [[self userTweetStream] count]){
		NSString *tweetCurrent = [[[self userTweetStream] objectAtIndex:[indexPath row]] tweetText];

		// JSS: you can use dot-syntax for these too, if you'd like
		[cell.detailTextLabel setText: tweetCurrent];
		[cell.detailTextLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[cell.detailTextLabel setNumberOfLines:3];
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

	// JSS: long line alert!
	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", [self userScreenName]]]];
	
//	NSURLRequest *tweetStreamRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1/statuses/user_timeline/%@.json", @"LeonardoDoreen4"]]];
	
	// JSS: leak!
	self.userTweetStream = [[NSMutableArray alloc] init];
	
	URLWrapper *tweetStreamConnection = [[URLWrapper alloc] initWithURLRequest:tweetStreamRequest connectionCompleted:^(NSData *data){
		
		NSMutableArray *tweetStreamFull = [data objectFromJSONData];
		
		//If error was returned (because user is blocked or other reason), JSON comes back as a dictionary object of the form {error = "message", request = "/request.json"}. Otherwise, data is an array.
		//
		// JSS: respondsToSelector: is valuable when you're checking for
		// functionality, but looking for a specific class is better modeled
		// with -isKindOfClass:
		//
		// JSS: if a value might be any one of a number of classes, use "id"
		// rather than the specific type, and then you can always assign it to
		// a more specific variable once you know (thus avoiding the warning
		// here about using -objectForKey: on an array)
		if ([tweetStreamFull respondsToSelector:@selector(objectForKey:)] && [tweetStreamFull objectForKey:@"error"]){
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
	
	
	// JSS: for construction and appearance methods, calls to super should come
	// FIRST, unless you have a specific reason to do otherwise
	[super viewWillAppear:animated];

}

// JSS: view controllers should generally be agnostic as to how or from where
// they're presented (i.e., it might not be the main screen you're returning to)
- (void)returnToMainScreen{
	
}

- (void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	// JSS: calls to super in destruction and disappearance methods should be at
	// the end (the opposite order of construction/appearance)
    [super viewDidUnload];

	// JSS: if you find yourself with a lot of cleanup shared between
	// -viewDidUnload and -dealloc, it can make sense to abstract it out into
	// a single method
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
