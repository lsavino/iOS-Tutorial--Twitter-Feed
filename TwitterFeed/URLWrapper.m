//
//  URLWrapper.m
//  TwitterFeed
//
//  Created by Laura Savino on 7/6/11.
//

#import "URLWrapper.h"


@implementation URLWrapper

@synthesize connectionDidFinishBlock = m_connectionDidFinishBlock;
@synthesize connectionDidFailBlock = m_connectionDidFailBlock;
@synthesize URLData = m_URLData;
@synthesize URLConnection = m_URLConnection;

-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock connectionFailed: (void (^)()) connectionFailedBlock{
	if(self = [super init]){
		// JSS: you can use dot-syntax for these, if you'd like
		[self setConnectionDidFinishBlock:connectionCompletedBlock];
		[self setURLConnection:[NSURLConnection connectionWithRequest:request delegate:self]];
		[self setConnectionDidFailBlock:connectionFailedBlock];
	}
	
	return self;
}


-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock{
	return [self initWithURLRequest:request connectionCompleted:connectionCompletedBlock connectionFailed:nil];
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
//	[self connectionDidFinishBlock:[self URLData]];
}



-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	//DEBUG: Cocoa documentation says to release the connection & data here, but then my app crashes with a double release. 
//	[connection release];
//	[self.URLData release];
	if(self.connectionDidFailBlock){
		self.connectionDidFailBlock();
	}
	NSLog(@"error~~~~~~~");
}


-(void) dealloc{
	// JSS: this is an extremely unorthodox and actually *dangerous* way to
	// release properties -- instead, just set it to nil and let its memory
	// management policy take care of it for you
	[self.URLData release];
	[[self connectionDidFinishBlock] release];
	[self.URLConnection release];
	[super dealloc];
}

@end
