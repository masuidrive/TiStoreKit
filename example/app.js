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
	testCreatePayment: function() {
	    var payment = StoreKit.createPayment();
	    jsUnity.assertions.assertEqual("[object Payment]", payment.toString());
	}
    };
})();

jsUnity.run(ModuleTestSuite, PaymentTestSuite);
