//
//  URLWrapper.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/6/11.
//  Copyright 2011 Ubermind. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLWrapper : NSObject {

}

@property (copy) void (^connectionDidFinishBlock)(NSData *data);
@property (copy) void (^connectionDidFailBlock)();
@property (retain) NSMutableData *URLData;
@property (retain) NSURLConnection *URLConnection;

-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock;

-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock connectionFailed: (void (^)()) connectionFailedBlock;
-(void) start;
-(void) cancel;

@end
