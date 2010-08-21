/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Payment.h"

#import "TiUtils.h"

@implementation Payment

@synthesize payment;


- (SKPayment*)payment
{
	if(payment==nil) {
		self.payment = [[[SKMutablePayment alloc] init] autorelease];
	}
	return [[payment retain] autorelease];
}

- (id)product
{
	return [[self.payment.productIdentifier retain] autorelease];
}

- (void)setProduct:(id)arg
{
	ENSURE_SINGLE_ARG_OR_NIL(arg, NSString);
	self.payment.productIdentifier = arg;
}


@end
