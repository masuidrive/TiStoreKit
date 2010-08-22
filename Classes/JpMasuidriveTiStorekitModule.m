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
	[paymentQueue release];
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

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"> paymentQueue:updatedTransactions:transactions ??");
	// TODO
	for (SKPaymentTransaction *transaction in transactions) {
		NSDictionary* evt = [NSDictionary dictionaryWithObject:transaction forKey:@"transaction"];
		
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
				[self fireEvent:@"puchasing" withObject:evt];
				break;
			
			case SKPaymentTransactionStatePurchased:
				[self fireEvent:@"puchased" withObject:evt];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				[self fireEvent:@"failed" withObject:evt];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				[self fireEvent:@"restored" withObject:evt];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
		}
	}
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	NSLog(@"> paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue");
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSLog(@"> paymentQueue:restoreCompletedTransactionsFailedWithError:");
}

#pragma Public APIs

-(id)createPayment:(id)args
{
	return [[[Payment alloc] _initWithPageContext:[self executionContext] args:args] autorelease];
}

-(id)paymentQueue
{
	if(paymentQueue==nil) {
		paymentQueue = [[PaymentQueue alloc] initWithTransactionObserver:self];
	}
	return paymentQueue;
}

@end
