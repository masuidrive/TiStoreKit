/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "PaymentQueue.h"
#import "Payment.h"
#import "TiUtils.h"

#import <StoreKit/StoreKit.h>


@implementation PaymentQueue

-(id)initWithTransactionObserver:(id < SKPaymentTransactionObserver >)observer_
{
	if (self = [super init])
	{
		observer = [observer_ retain];
	}
	return self;
}

-(void)dealloc
{
	[observer release];
	[super dealloc];
}


-(void)addPayment:(id)arg
{
	ENSURE_SINGLE_ARG_OR_NIL(arg, Payment);
	Payment* payment = (Payment*)arg;
	[[SKPaymentQueue defaultQueue] addPayment:payment.payment];
}

-(id)canMakePayments
{
	return NUMBOOL([SKPaymentQueue canMakePayments]);
}

@end
