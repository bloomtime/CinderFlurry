#pragma once

#include "FlurryAnalytics.h"

#include <string>
#include <sstream>
#include <ostream>
#include <map>

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
	
	void init(const std::string &app_id);
    void logEvent(const std::string &eventName);
	void logEvent(const std::string &eventName, const std::map<std::string, std::string> &parameters);
	
	void startTimeEvent(const std::string &eventName);
	void startTimeEvent(const std::string &eventName, const std::map<std::string, std::string> &parameters);
	void stopTimeEvent(const std::string &eventName);
	void stopTimeEvent(const std::string &eventNAme, const std::map<std::string, std::string> &parameters);	

	void incrementActivity();

	void setUserId(const std::string &userId);
	void setAge(const int &age);
	void setGender(const std::string &gender);

	void setLocation( const double &latitude, 
                      const double &longitude, 
                      const float &horizontalAccuracy, 
                      const float &verticalAccuracy );
};

}}