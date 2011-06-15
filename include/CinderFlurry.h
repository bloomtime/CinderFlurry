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
	
	void init(const string &app_id);
    void logEvent(const string &eventName);
	void logEvent(const string &eventName, const std::map<string, string> &parameters);
	
	void startTimeEvent(const string &eventName);
	void startTimeEvent(const string &eventName, const std::map<string, string> &parameters);
	void stopTimeEvent(const string &eventName);
	void stopTimeEvent(const string &eventNAme, const std::map<string, string> &parameters);	

	void incrementActivity();

	void setUserId(const string &userId);
	void setAge(const int &age);
	void setGender(const string &gender);

	void setLatitude( const double &latitude, 
                      const double &longitude, 
                      const float &horizontalAccuracy, 
                      const float &verticalAccuracy );
};

}}