#pragma once

#include "FlurryAPI.h"

#include <string>
#include <sstream>
#include <ostream>
#include <map>

using std::string;
using std::map;

std::string i_to_string(int i);

namespace pollen { namespace flurry {

class Flurry {
private:
	Flurry() {};
    Flurry(Flurry& ) {};
//    Flurry& operator=(Flurry const&) { };
    ~Flurry() {};
	static Flurry *flurry;
public:
	static Flurry*   getInstrumentation() {
		if (!flurry) {
			flurry = new Flurry;
		}
		return flurry;
	}
	
	void init(string app_id);
    void logEvent(string eventName);
	void logEvent(string eventName, std::map<string, string>& parameters);
	
	void startTimeEvent(string eventName);
	void startTimeEvent(string eventName, std::map<string, string>& parameters);
	void stopTimeEvent(string eventName);
	void stopTimeEvent(string eventNAme, std::map<string, string>& parameters);	

	void incrementActivity();

	void setUserId(string userId);
	void setAge(int age);
	void setGender(string gender);

	void setLatitude(double latitude, double longitude, float horizontalAccuracy, float verticalAccuracy);
};

}}