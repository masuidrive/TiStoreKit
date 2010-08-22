/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "JpMasuidriveTiStorekitModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "Payment.h"
#import "PaymentTransaction.h"
#import "Product.h"


@implementation JpMasuidriveTiStorekitModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b0c990ec-bb25-4627-9994-1f11f5076375";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"jp.masuidrive.ti.storekit";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	productRequestCallback = [NSMutableArray array];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[defaultPaymentQueue release];
	[productRequestCallback release];
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}


#pragma mark Delegates

- (void)productsRequest:(SKProductsRequest *)request
	 didReceiveResponse:(SKProductsResponse *)response
{
	KrollCallback* callback = nil;
	for(NSArray* line in productRequestCallback) {
		if([line objectAtIndex:0] == request) {
			callback = [[[line objectAtIndex:1] retain] autorelease];
			[productRequestCallback removeObject:line];
			break;
		}
	}
	if(callback) {	   
		NSMutableArray* products = [NSMutableArray array];
		for(SKProduct* product in response.products) {
			[products addObject:[[Product alloc] _initWithPageContext:[self pageContext] product:product]];
		}
		[callback call:[NSArray arrayWithObjects:products, response.invalidProductIdentifiers, nil] thisObject:self];
	}
}

#pragma Public APIs

-(id)createPayment:(id)args
{
	return [[[Payment alloc] _initWithPageContext:[self executionContext] args:args] autorelease];
}

-(void)findProducts:(id)args
{
	ENSURE_ARG_COUNT(args, 2);
	id arg0 = [args objectAtIndex:0];
	NSSet* productIds = nil;
	if([arg0 isKindOfClass:[NSString class]]) {
		productIds = [NSSet setWithObject:arg0];
	}
	else if([arg0 isKindOfClass:[NSArray class]]) {
		productIds = [NSSet setWithArray:arg0];
	}
	else {
		[self throwException:TiExceptionInvalidType subreason:[NSString stringWithFormat:@"expected: Array or Stinrg, was: %@",[arg0 class]] location:CODELOCATION]; \
	}
	
	id callback = [args objectAtIndex:1];
	ENSURE_TYPE(callback, KrollCallback);
	SKProductsRequest *req = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIds] autorelease];
	req.delegate = self;
	[req start];
	[productRequestCallback addObject:[NSArray arrayWithObjects: req, callback, nil]];
}

-(id)defaultPaymentQueue
{
	if(defaultPaymentQueue==nil) {
		defaultPaymentQueue = [[PaymentQueue alloc] _initWithPageContext:[self pageContext] queue:[SKPaymentQueue defaultQueue]];
	}
	return defaultPaymentQueue;
}

@end
