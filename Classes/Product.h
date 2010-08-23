/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <StoreKit/StoreKit.h>

@interface Product : TiProxy {

@private
	SKProduct* product;
}

-(id)_initWithPageContext:(id<TiEvaluator>)context product:(SKProduct*)product_;
-(id)id;

@end
