#include "CinderFlurry.h"
#import "FlurryAnalytics.h"

using std::map;
using std::string;

namespace bloom { namespace flurry {
    NSString* string2NSString(string str);
    void uncaughtExceptionHandler(NSException *exception);
} }

namespace bloom { namespace flurry {
    
	Flurry*	Flurry::flurry = 0;

    NSString* string2NSString(string str) {
        // TODO: we might want UTF8 here and we might want to do initWith and release manually
        return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
    }
    
    void uncaughtExceptionHandler(NSException *exception) {
        [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
    }

    void Flurry::init(const string &app_id) {
		NSSetUncaughtExceptionHandler(&bloom::flurry::uncaughtExceptionHandler);
        [FlurryAnalytics setSessionReportsOnPauseEnabled:YES];
		[FlurryAnalytics startSession:string2NSString(app_id)];
	}
    
    void Flurry::logEvent(const string &eventName) {
        [[FlurryAnalytics class] performSelectorOnMainThread:@selector(logEvent:) withObject: string2NSString(eventName) waitUntilDone:false];
	}	
    
    void Flurry::logEvent(const string &eventName, const map<string, string> &parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (map<string, string>::const_iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: string2NSString(iter->first) forKey: string2NSString(iter->second) ];
        }
        
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation retainArguments];
        [invocation setTarget: [FlurryAnalytics class]];
        [invocation setSelector:@selector(logEvent:withParameters:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        [invocation setArgument:params atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];
        
        [params release];
        
//		[FlurryAnalytics logEvent:string2NSString(eventName) withParameters: params];
	}	

    void Flurry::startTimeEvent(const string &eventName) {
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation retainArguments];        
        [invocation setTarget: [FlurryAnalytics class]];
        [invocation setSelector:@selector(logEvent:timed:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        BOOL wait = YES;
        [invocation setArgument:&wait atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];
        
//		[FlurryAnalytics logEvent:string2NSString(eventName) timed:TRUE];
	}	
    
    void Flurry::startTimeEvent(const string &eventName, const map<string, string> &parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (map<string, string>::const_iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: string2NSString(iter->first) forKey: string2NSString(iter->second) ];
        }
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation retainArguments];        
        [invocation setTarget: [FlurryAnalytics class]];
        [invocation setSelector:@selector(logEvent:withParameters:timed:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        [invocation setArgument:params atIndex:1];
        BOOL wait = YES;
        [invocation setArgument:&wait atIndex:2];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];

        [params release];
                
//		[FlurryAnalytics logEvent:string2NSString(eventName) withParameters: params timed:TRUE];
	}	
    
    void Flurry::stopTimeEvent(const string &eventName) {
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation retainArguments];        
        [invocation setTarget: [FlurryAnalytics class]];
        [invocation setSelector:@selector(endTimedEvent:withParameters:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        
        [invocation setArgument:nil atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];

//		[FlurryAnalytics endTimedEvent:string2NSString(eventName) withParameters: [[NSMutableDictionary alloc] init]];
	}	
    
    void Flurry::stopTimeEvent(const string &eventName, const map<string, string> &parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (map<string, string>::const_iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: string2NSString(iter->first) forKey: string2NSString(iter->second) ];
        }
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation retainArguments];        
        [invocation setTarget: [FlurryAnalytics class]];
        [invocation setSelector:@selector(endTimedEvent:withParameters:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        [invocation setArgument:params atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];

        [params release];
        
//		[FlurryAnalytics endTimedEvent:string2NSString(eventName) withParameters: params];
	}	
    
    void Flurry::incrementActivity() {
        [[FlurryAnalytics class] performSelectorOnMainThread:@selector(logPageView) withObject: nil waitUntilDone:false];
	}	
	
	void Flurry::setUserId(const string &userId) {
        [[FlurryAnalytics class] performSelectorOnMainThread:@selector(setUserID:) withObject: string2NSString(userId) waitUntilDone:false];
	}

	void Flurry::setAge(const int &age) {
		[FlurryAnalytics setAge: age];
	}
	
	void Flurry::setGender(const string &gender) {
        [FlurryAnalytics performSelectorOnMainThread:@selector(setGender:) withObject: string2NSString(gender) waitUntilDone:false];
	}

	void Flurry::setLocation(const double &latitude, const double &longitude, const float &horizontalAccuracy, const float &verticalAccuracy) {
		[FlurryAnalytics setLatitude: latitude longitude: longitude horizontalAccuracy: horizontalAccuracy verticalAccuracy: verticalAccuracy];
	}
    
} } // namespacen