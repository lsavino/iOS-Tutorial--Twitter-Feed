//
//  URLWrapper.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/6/11.
//

#import "URLWrapper.h"

@interface URLWrapper (){
	
}

@property (nonatomic, retain) NSMutableData *URLData;
@property (nonatomic, retain) NSURLConnection *URLConnection;

@end

@implementation URLWrapper

@synthesize connectionDidFinishBlock = m_connectionDidFinishBlock;
@synthesize connectionDidFailBlock = m_connectionDidFailBlock;
@synthesize URLData = m_URLData;
@synthesize URLConnection = m_URLConnection;

-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock connectionFailed: (void (^)(NSError*)) connectionFailedBlock{
	if((self = [super init])){
		self.connectionDidFinishBlock = connectionCompletedBlock;
		self.URLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
		self.connectionDidFailBlock = connectionFailedBlock;
	}
	
	return self;
}

-(void) start{
	[self.URLConnection start];
}

-(void) cancel{
	[self.URLConnection cancel];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	if(!self.URLData){
		[self setURLData:[NSMutableData dataWithData: data]];
	}
	else{
		[self.URLData appendData:data];
	}
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
	if(self.connectionDidFinishBlock){
		self.connectionDidFinishBlock(self.URLData);
	}
}



-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	//DEBUG: Cocoa documentation says to release the connection & data here, but then my app crashes with a double release. 
	
	if(self.connectionDidFailBlock){
		self.connectionDidFailBlock(error);
	}
	
	NSLog(@"error~~~~~~~");
}


-(void) dealloc{
	self.URLData = nil;
	self.connectionDidFinishBlock = nil;
	self.connectionDidFailBlock = nil;
	self.URLConnection = nil;
	[super dealloc];
}

@end
