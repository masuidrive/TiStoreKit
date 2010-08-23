/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "PaymentTransaction.h"
#import "Payment.h"

#import "TiBlob.h"
#import "TiUtils.h"

@implementation PaymentTransaction
@synthesize transaction;

-(id)_initWithPageContext:(id<TiEvaluator>)context
			  transaction:(SKPaymentTransaction*)transaction_
{
	if (self = [super _initWithPageContext:context]) {
		transaction = [transaction_ retain];
	}
	return self;
}

-(void)dealloc
{
	RELEASE_TO_NIL(transaction);
	[super dealloc];
}

- (id)state
{
	switch (transaction.transactionState) {
		case SKPaymentTransactionStatePurchasing:
			return @"purchasing";
		case SKPaymentTransactionStatePurchased:
			return @"purchased";
		case SKPaymentTransactionStateFailed:
			return @"failed";
		case SKPaymentTransactionStateRestored:
			return @"restored";
	}
	return @"Unknown";
}

#define SETOBJ(dict, obj, key) if(obj){[dict setObject:obj forKey:key];};

- (id)error
{
	if(transaction.error) {
		NSError* e = transaction.error;
		NSMutableDictionary* ret = [NSMutableDictionary dictionaryWithObjectsAndKeys:NUMINT(e.code), @"code",nil];
		SETOBJ(ret, e.domain, @"domain");
		SETOBJ(ret, e.helpAnchor, @"helpAnchor");
		SETOBJ(ret, e.localizedDescription, @"message");
		SETOBJ(ret, e.localizedDescription, @"localizedDescription");
		SETOBJ(ret, e.localizedFailureReason, @"localizedFailureReason");
		SETOBJ(ret, e.localizedRecoveryOptions, @"localizedRecoveryOptions");
		SETOBJ(ret, e.localizedRecoverySuggestion, @"localizedRecoverySuggestion");
		return ret;
	}
	else {
		return nil;
	}
}


-(id)originalTransaction
{
	return [[[PaymentTransaction alloc] _initWithPageContext:[self pageContext] transaction:transaction.originalTransaction] autorelease];
}

-(id)payment
{
	return [[[Payment alloc] _initWithPageContext:[self pageContext] payment:transaction.payment] autorelease];
}

-(id)receipt
{
	return [[[TiBlob alloc] initWithData:[transaction transactionReceipt] mimetype:@"application/octet-stream"] autorelease];
}

-(id)date
{
	return [transaction transactionDate];
}

-(id)identifier
{
	return [transaction transactionIdentifier];
}
@end
