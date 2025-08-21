//
//  NEPhotoTakingWrapper.h
//  manikincreation
//
//  Created by Remy Blanchard on 03/01/2022.
//

#ifndef NEPhotoTakingWrapper_h
#define NEPhotoTakingWrapper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoTakingResultEnum) {
    PhotoTakingResult_Ok,
    PhotoTakingResult_NotEnoughData,
    PhotoTakingResult_InvalidData,
    PhotoTakingResult_UserCancel
};

@class NEPhotoTakingWrapper;

@protocol NEPhotoTakingDelegate <NSObject>

- (void) leavingWithReason:(NSString *) key;

@end

@interface NEPhotoTakingWrapper : NSObject

- (instancetype)initWithDelegate:(id<NEPhotoTakingDelegate>)delegate;

// This function configures the SDK, pass the Tokens and other app related informations here
- (PhotoTakingResultEnum) setConfiguration: (NSDictionary *)config;

// This function provides the controller to display on screen, returns null if delegate was not set at initialization state
- (void) getViewController:(void(^)(UIViewController *))complete;

// Optionnal call: you can call this function before pushing the viewcontroller of getViewController to gain time, this will check the user informations, it helps avoiding incorrect user informations befor pusing the VC
// Call with nil if everything when ok
// ortherwise NSError
- (void) runPreFlightWithCompletion:(void(^)(NSError *))complete;

// Use this function to push user information (name, stature, weight, ...)
- (PhotoTakingResultEnum) setUserInformation: (NSDictionary *)info;

@end


#endif /* NEPhotoTakingWrapper_h */
