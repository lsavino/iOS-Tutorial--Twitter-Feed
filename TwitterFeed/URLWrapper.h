//
//  URLWrapper.h
//  TwitterFeed
//
//  Created by Laura Savino on 7/6/11.
//

#import <Foundation/Foundation.h>


@interface URLWrapper : NSObject {

}


/*
 * This block is called when the connection successfully finishes; data is passed from the completed connection.
 */
@property (nonatomic, copy) void (^connectionDidFinishBlock)(NSData *data);


/*
 * This block is called if the connection fails with an error; error is passed from the connection failure.
 */

@property (nonatomic, copy) void (^connectionDidFailBlock)(NSError *error);


/*
 * Initializes with URL request, block to call on connection completion, and block to call on connection failure.
 *
 * This is the designated initializer.
 */
-(id) initWithURLRequest: (NSURLRequest*) request connectionCompleted: (void (^)(NSData* id)) connectionCompletedBlock connectionFailed: (void (^)(NSError*)) connectionFailedBlock;

/*
 * Begins connection to designated URLRequest.
 */

-(void) start;


/*
 * Cancels connection; does not provide cleanup, so user must still release the URLWrapper instance.
 */

-(void) cancel;

@end
