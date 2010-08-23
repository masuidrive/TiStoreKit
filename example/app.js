// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

// open a single logger window
var window = Ti.UI.createWindow({
  backgroundColor: 'white'
});
var logger = Ti.UI.createTextArea({value: "Testing...\n", editable: false});
window.add(logger);
window.open();

// load UnitTest
Titanium.include("jsunity-0.6.js");
 jsUnity.log = function(message) {
     Titanium.API.info(message);
     logger.value = logger.value + message + "\n";
};

// Start!
var ModuleTestSuite = (function(){
    var StoreKit = require("jp.masuidrive.ti.storekit");
    return {
	suiteName: "Module Test Suite",
	StoreKit: undefined,
	
	testModuleToString: function() {
	    jsUnity.assertions.assertEqual("[object JpMasuidriveTiStorekitModule]", StoreKit.toString());
	}
    };
})();

var PaymentTestSuite = (function() {
    var StoreKit = require("jp.masuidrive.ti.storekit");
    return {
	suiteName: "Payment Test Suite",
	testCanMakePayments: function() {
	    jsUnity.assertions.assertEqual(true, StoreKit.canMakePayments);
	},
	testCreatePayment: function() {
	    var payment = StoreKit.createPayment();
	    jsUnity.assertions.assertEqual("[object Payment]", payment.toString());
	},
	testFindProduct: function() {
	    StoreKit.findProducts("jp.masuidrive.ti.storekit.example1", function(products, invalid){
		for(i in products) {
		    var p = products[i];
		    jsUnity.log(p.productIdentifier);
		}
		jsUnity.log(invalid);
	    });
	},
	testPaymentProduct: function() {
	    var payment = StoreKit.createPayment({product: "jp.masuidrive.ti.storekit.example1", quantity: 10});
	    jsUnity.assertions.assertEqual("jp.masuidrive.ti.storekit.example1", payment.product);
	},
	testPaymentProductProperty: function() {
	    var payment = StoreKit.createPayment();
	    payment.product = "jp.masuidrive.ti.storekit.example2";
	    jsUnity.assertions.assertEqual("jp.masuidrive.ti.storekit.example2", payment.product);
	    payment.quantity = 12;
	    jsUnity.assertions.assertEqual(12, payment.quantity);
	},
	testPaymentAddQueue: function() {
	    var payment = StoreKit.createPayment();
	    StoreKit.defaultPaymentQueue.addEventListener("restoreFinished", function(e) {
		jsUnity.log(">>restoreFinished");
		jsUnity.log(e);
	    });
	    StoreKit.defaultPaymentQueue.addEventListener("restoreFailed", function(e) {
		jsUnity.log(">>restoreFailed");
		jsUnity.log(e);
	    });

	    StoreKit.defaultPaymentQueue.addEventListener("purchasing", function(e) {
		jsUnity.log(">>purchasing");
		jsUnity.log(e.transaction);
	    });
	    
	    StoreKit.defaultPaymentQueue.addEventListener("purchased", function(e) {
		jsUnity.log(">>purchased");
		jsUnity.log(e.transaction);
		jsUnity.log(e.transaction.identifier);
		jsUnity.log(e.transaction.receipt);
		StoreKit.defaultPaymentQueue.finishTransaction(e.transaction);
	    });
	    
	    StoreKit.defaultPaymentQueue.addEventListener("failed", function(e) {
		jsUnity.log(">>failed !!!");
		jsUnity.log(e.transaction.error.message);
		StoreKit.defaultPaymentQueue.finishTransaction(e.transaction);
	    });
	    payment.product = "jp.masuidrive.ti.storekit.example1";
	    payment.quantity = 10;
	    StoreKit.defaultPaymentQueue.addPayment(payment);
	}
    };
})();

jsUnity.run(ModuleTestSuite, PaymentTestSuite);
