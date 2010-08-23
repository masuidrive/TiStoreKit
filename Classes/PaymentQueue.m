/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "PaymentQueue.h"
#import "PaymentTransaction.h"
#import "Payment.h"
#import "TiUtils.h"

#import <StoreKit/StoreKit.h>


@implementation PaymentQueue

-(id)_initWithPageContext:(id<TiEvaluator>)context
				    queue:(SKPaymentQueue*)queue_
{
	if (self = [super _initWithPageContext:context]) {
		queue = [queue_ retain];
		[queue addTransactionObserver:self];
	}
	return self;
}

-(void)dealloc
{
	[queue removeTransactionObserver:self];
	[queue release];
	[super dealloc];
}

- (SKPaymentQueue*)queue
{
	if(queue==nil) {
		queue = [[[SKPaymentQueue alloc] init] autorelease];
		[queue addTransactionObserver:self];
	}
	return [[queue retain] autorelease];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions) {
		PaymentTransaction* t = [[[PaymentTransaction alloc] _initWithPageContext:[self pageContext] transaction:transaction] autorelease];
		NSDictionary* evt = [NSDictionary dictionaryWithObject:t forKey:@"transaction"];
		
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
				[self fireEvent:@"purchasing" withObject:evt];
				break;
				
			case SKPaymentTransactionStatePurchased:
				[self fireEvent:@"purchased" withObject:evt];
				[[self queue] finishTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				[self fireEvent:@"failed" withObject:evt];
				[[self queue] finishTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				[self fireEvent:@"restored" withObject:evt];
				[[self queue] finishTransaction:transaction];
				break;
		}
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue
 removedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions) {
		PaymentTransaction* t = [[[PaymentTransaction alloc] _initWithPageContext:[self pageContext] transaction:transaction] autorelease];
		[self fireEvent:@"removed" withObject:[NSDictionary dictionaryWithObject:t forKey:@"transaction"]];
	}
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	[self fireEvent:@"restoreFinished" withObject:nil];
}

#define SETOBJ(dict, obj, key) if(obj){[dict setObject:obj forKey:key];};

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSMutableDictionary* ret = [NSMutableDictionary dictionaryWithObjectsAndKeys:NUMINT(error.code), @"code",nil];
	SETOBJ(ret, error.domain, @"domain");
	SETOBJ(ret, error.helpAnchor, @"helpAnchor");
	SETOBJ(ret, error.localizedDescription, @"message");
	SETOBJ(ret, error.localizedDescription, @"localizedDescription");
	SETOBJ(ret, error.localizedFailureReason, @"localizedFailureReason");
	SETOBJ(ret, error.localizedRecoveryOptions, @"localizedRecoveryOptions");
	SETOBJ(ret, error.localizedRecoverySuggestion, @"localizedRecoverySuggestion");
	
	[self fireEvent:@"restoreFailed" withObject:[NSDictionary dictionaryWithObjectsAndKeys:ret, @"error", nil]];
}


#pragma Public API

-(void)addPayment:(id)arg
{
	ENSURE_SINGLE_ARG_OR_NIL(arg, Payment);
	Payment* payment = (Payment*)arg;
	[[self queue] addPayment:payment.payment];
}

-(void)finishTransaction:(id)arg
{
	ENSURE_SINGLE_ARG_OR_NIL(arg, PaymentTransaction);
	PaymentTransaction* pt = arg;
	[[self queue] finishTransaction:pt.transaction];
}

-(void)restoreCompletedTransactions:(id)arg
{
	[[self queue] restoreCompletedTransactions];
}

@end
