#include "CinderFlurry.h"

std::string i_to_string(int i)
{
    std::stringstream ss;
    std::string s;
    ss << i;
    s = ss.str();
    
    return s;
}


namespace pollen { namespace flurry {
	Flurry*	Flurry::flurry = 0;

    NSString* string2NSString(string str) {
        return [NSString stringWithCString:str.c_str() encoding:[NSString defaultCStringEncoding]];
    }
    
    void uncaughtExceptionHandler(NSException *exception) {
        [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
    }

    void Flurry::init(string app_id) {
		NSSetUncaughtExceptionHandler(&pollen::flurry::uncaughtExceptionHandler);
        [FlurryAPI setSessionReportsOnPauseEnabled:YES];
		[FlurryAPI startSession:string2NSString(app_id)];
	}
    
    void Flurry::logEvent(string eventName) {
        [[FlurryAPI class] performSelectorOnMainThread:@selector(logEvent:) withObject: string2NSString(eventName) waitUntilDone:false];
	}	
    
    void Flurry::logEvent(string eventName, std::map<string, string>& parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (std::map<string, string>::iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: string2NSString(iter->first) forKey: string2NSString(iter->second) ];
        }
        
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation setTarget: [FlurryAPI class]];
        [invocation setSelector:@selector(logEvent:withParameters:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        [invocation setArgument:params atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];

//		[FlurryAPI logEvent:string2NSString(eventName) withParameters: params];
	}	

    void Flurry::startTimeEvent(string eventName) {
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation setTarget: [FlurryAPI class]];
        [invocation setSelector:@selector(logEvent:timed:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        BOOL wait = YES;
        [invocation setArgument:&wait atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];
        
//		[FlurryAPI logEvent:string2NSString(eventName) timed:TRUE];
	}	
    
    void Flurry::startTimeEvent(string eventName, std::map<string, string>& parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (std::map<string, string>::iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: string2NSString(iter->first) forKey: string2NSString(iter->second) ];
        }
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation setTarget: [FlurryAPI class]];
        [invocation setSelector:@selector(logEvent:withParameters:timed:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        [invocation setArgument:params atIndex:1];
        BOOL wait = YES;
        [invocation setArgument:&wait atIndex:2];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];
        
//		[FlurryAPI logEvent:string2NSString(eventName) withParameters: params timed:TRUE];
	}	
    
    void Flurry::stopTimeEvent(string eventName) {
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation setTarget: [FlurryAPI class]];
        [invocation setSelector:@selector(endTimedEvent:withParameters:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        
        [invocation setArgument:nil atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];

//		[FlurryAPI endTimedEvent:string2NSString(eventName) withParameters: [[NSMutableDictionary alloc] init]];
	}	
    
    void Flurry::stopTimeEvent(string eventName, std::map<string, string>& parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (std::map<string, string>::iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: string2NSString(iter->first) forKey: string2NSString(iter->second) ];
        }
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation setTarget: [FlurryAPI class]];
        [invocation setSelector:@selector(endTimedEvent:withParameters:)];
        [invocation setArgument:string2NSString(eventName) atIndex:0];
        [invocation setArgument:params atIndex:1];
        [invocation performSelectorOnMainThread:@selector(invoke) withObject:Nil waitUntilDone:false];
        
//		[FlurryAPI endTimedEvent:string2NSString(eventName) withParameters: params];
	}	
    
    void Flurry::incrementActivity() {
        [[FlurryAPI class] performSelectorOnMainThread:@selector(logPageView) withObject: nil waitUntilDone:false];
	}	
	
	void setUserId(string userId) {
        [[FlurryAPI class] performSelectorOnMainThread:@selector(setUserID:) withObject: string2NSString(userId) waitUntilDone:false];
	}

	void setAge(int age) {
        
		[FlurryAPI setAge: age];
	}
	
	void setGender(string gender) {
        [FlurryAPI performSelectorOnMainThread:@selector(setGender:) withObject: string2NSString(gender) waitUntilDone:false];
	}

	void setLocation(double latitude, double longitude, float horizontalAccuracy, float verticalAccuracy) {
		[FlurryAPI setLatitude: latitude longitude: longitude horizontalAccuracy: horizontalAccuracy verticalAccuracy: verticalAccuracy];
	}
}}