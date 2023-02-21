//
//  ReceiptValidator.h
//  TikKid
//
//  Created by Christina Santana on 20/2/23.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface ReceiptValidator : NSObject
-(void)helloWorld;
- (BOOL)verifyReceipt:(SKPaymentTransaction *)transaction;
@end

NS_ASSUME_NONNULL_END
