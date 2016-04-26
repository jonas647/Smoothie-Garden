//
//  IAPHelper.m
//
//  Created by Jonas C Björkell on 2014-11-03.
//  Copyright (c) 2014 Jonas C Björkell. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductTransactionNotification = @"IAPHelperProductTransactionNotification";
NSString *const IAPHelperProductResponseForTransaction = @"IAPHelperProductResponseForTransaction"; //Used for updating that we have connection with the appstore. Used for removing a running activity indicator for exemple

// 2
@interface IAPHelper () <SKProductsRequestDelegate>
@end

@implementation IAPHelper {
    // 3
    SKProductsRequest * _productsRequest;
    // 4
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
            
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    if ([[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers]) {
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }
    
    
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    
    
    if ([SKPayment paymentWithProduct:product]) {
        
        NSLog(@"Add payment to queue: %@", product);
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        [self notificationForResponseFromStore];
        
    }
    
    
}



#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
    //TODO
    //Post notification that the in app purchases couldn't be loaded
    [self notificationForResponseForTransaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self notificationForResponseFromStore];
}

#pragma mark -  SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction failed");
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
    
    //Notify that the transaction has been completed
    //[self notificationForResponseForTransaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        UIAlertView *errorView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"LOCALIZE_No Purchase Header", nil) message:NSLocalizedString(@"LOCALIZE_No Purchase Text", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"LOCALIZE_OK", nil) otherButtonTitles: nil];
        [errorView show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [self notificationForResponseFromStore];
    
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}

- (void) notificationForResponseForTransaction {
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductTransactionNotification object:nil userInfo:nil];
}

- (void) notificationForResponseFromStore{
    //TODO
    //Is this needed?
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductResponseForTransaction object:nil userInfo:nil];
}

@end
