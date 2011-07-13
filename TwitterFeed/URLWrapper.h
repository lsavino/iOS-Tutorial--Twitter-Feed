//
//  URLWrapper.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/6/11.
//

#import <Foundation/Foundation.h>


@interface URLWrapper : NSObject {

}

@property (nonatomic, copy) void (^connectionDidFinishBlock)(NSData *data);
@property (nonatomic, copy) void (^connectionDidFailBlock)();
@property (nonatomic, retain) NSMutableData *URLData;
@property (nonatomic, retain) NSURLConnection *URLConnection;

-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock;

-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock connectionFailed: (void (^)()) connectionFailedBlock;
-(void) start;
-(void) cancel;

@end
