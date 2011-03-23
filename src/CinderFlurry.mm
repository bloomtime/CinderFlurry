#include "CinderFlurry.h"

namespace pollen { namespace flurry {
	Flurry*	Flurry::flurry = 0;

    void uncaughtExceptionHandler(NSException *exception) {
        [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
    }

    void Flurry::init(string app_id) {
		NSSetUncaughtExceptionHandler(&pollen::flurry::uncaughtExceptionHandler);
		[FlurryAPI startSession:[NSString stringWithCString:app_id.c_str() encoding:[NSString defaultCStringEncoding]]];
	}
    
    void Flurry::logEvent(string eventName) {
		[FlurryAPI logEvent:[NSString stringWithCString:eventName.c_str() encoding:[NSString defaultCStringEncoding]]];
	}	
    
    void Flurry::logEvent(string eventName, std::map<string, string>& parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (std::map<string, string>::iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: [NSString stringWithCString:iter->first.c_str() encoding:[NSString defaultCStringEncoding]] forKey: [NSString stringWithCString:iter->second.c_str() encoding:[NSString defaultCStringEncoding]] ];
        }
		[FlurryAPI logEvent:[NSString stringWithCString:eventName.c_str() encoding:[NSString defaultCStringEncoding]] withParameters: params];
	}	

    void Flurry::startTimeEvent(string eventName) {
		[FlurryAPI logEvent:[NSString stringWithCString:eventName.c_str() encoding:[NSString defaultCStringEncoding]] timed:TRUE];
	}	
    
    void Flurry::startTimeEvent(string eventName, std::map<string, string>& parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (std::map<string, string>::iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: [NSString stringWithCString:iter->first.c_str() encoding:[NSString defaultCStringEncoding]] forKey: [NSString stringWithCString:iter->second.c_str() encoding:[NSString defaultCStringEncoding]] ];
        }
		[FlurryAPI logEvent:[NSString stringWithCString:eventName.c_str() encoding:[NSString defaultCStringEncoding]] withParameters: params timed:TRUE];
	}	
    
    void Flurry::stopTimeEvent(string eventName) {
		[FlurryAPI endTimedEvent:[NSString stringWithCString:eventName.c_str() encoding:[NSString defaultCStringEncoding]] withParameters: [[NSMutableDictionary alloc] init]];
	}	
    
    void Flurry::stopTimeEvent(string eventName, std::map<string, string>& parameters) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (std::map<string, string>::iterator iter = parameters.begin(); iter != parameters.end(); iter++) {
            [params setObject: [NSString stringWithCString:iter->first.c_str() encoding:[NSString defaultCStringEncoding]] forKey: [NSString stringWithCString:iter->second.c_str() encoding:[NSString defaultCStringEncoding]] ];
        }
		[FlurryAPI endTimedEvent:[NSString stringWithCString:eventName.c_str() encoding:[NSString defaultCStringEncoding]] withParameters: params];
	}	
    
    void Flurry::incrementActivity() {
		[FlurryAPI logPageView];
	}	
	
	void setUserId(string userId) {
		[FlurryAPI setUserId:[NSString stringWithCString:userId.c_str() encoding:[NSString defaultCStringEncoding]]];
	}

	void setAge(int age) {
		[FlurryAPI setAge: age];
	}
	
	void setGender(string gender) {
		[FlurryAPI setGender: [NSString stringWithCString:gender.c_str() encoding:[NSString defaultCStringEncoding]]];
	}

	void setLocation(double latitude, double longitude, float horizontalAccuracy, float verticalAccuracy) {
		[FlurryAPI setLatitude: latitude longitude: longitude horizontalAccuracy: horizontalAccuracy verticalAccuracy: verticalAccuracy];
	}
}}