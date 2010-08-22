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

-(id)initWithTransactionObserver:(id < SKPaymentTransactionObserver >)observer_
{
	if (self = [super init])
	{
		observer = [observer_ retain];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
	}
	return self;
}

-(void)dealloc
{
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:observer];
	[observer release];
	[super dealloc];
}

-(void)addPayment:(id)arg
{
	ENSURE_SINGLE_ARG_OR_NIL(arg, Payment);
	Payment* payment = (Payment*)arg;
	[[SKPaymentQueue defaultQueue] addPayment:payment.payment];
}

-(void)finishTransaction:(id)arg
{
	ENSURE_SINGLE_ARG_OR_NIL(arg, PaymentTransaction);
	PaymentTransaction* pt = arg;
	[[SKPaymentQueue defaultQueue] finishTransaction:pt.transaction];
}

-(void)restoreCompletedTransactions:(id)arg
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(id)canMakePayments
{
	return NUMBOOL([SKPaymentQueue canMakePayments]);
}

@end
