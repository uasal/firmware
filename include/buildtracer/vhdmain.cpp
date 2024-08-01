
/*

  Programmer:  Tyler Newton

  Date:        August 06, 2004

  E-mail:      itsari@users.sourceforge.net

  Tested
  Platforms:   - Microsoft Windows XP Professional
	           - Redhat Linux 9.0

  Compilers:   - MSVC++ 6.0
	           - g++

  Project:     Build Tracer

  Version:     1.0

  Description:

	     Build Tracer keeps track of build counts for your programming projects.



  NOTE:  This program HAS to return an integer value.. otherwise VS will throw a cmd.exe error.  no kidding.


*/


// =================================================================
// INCLUDES
// =================================================================
#include <string>
#include <string.h>
#include <fstream>
#include <iostream>
#include <climits>
#include <time.h>
using namespace std;
// =================================================================
// CONSTANTS
// =================================================================
// Edit these messages if you'd like to change what Build Tracer echos during
// compilation
const string BUILD_TITLE = "Build Tracer Active:";		// Output Line 1
const string BUILD_MSG = " current build number:";		// Output Line 2
const char BUILDNUMHEADER [] = "constant BuildNum : std_logic_vector(31 downto 0) := x\"";
const char BUILDTIMEHEADER [] = "constant BuildTime : std_logic_vector(31 downto 0) := x\"";
// =================================================================
// main pgoram
int main(int argc, char** argv) {

	// echo the build title
	cout << BUILD_TITLE << endl;

	char line[2048];

	// They should pass us one argument.. the name of the executable being built
	if (argc != 2) {
		// otherwise gracefully exit.
		cout << "Invalid number of command line parameters.. exiting" << endl;
		return 1;
	}

	// Get the name of the project we're building for
	string fileName = argv[1];
	string ofileName = fileName + ".tmp";

	unsigned long buildNumber = 0;
	bool BuildNumFound = false;
	bool BuildTimeFound = false;
	char* strposBuildNumHeader;
	char* strposBuildTimeHeader;

	// See if it has a build count file already
	ifstream In(fileName.c_str());
	ofstream Out(ofileName.c_str());

	if (In.is_open()) {

		while (!In.eof()) {

			//Get line
			In.getline(line, 2048);

			strposBuildNumHeader = strstr(line, BUILDNUMHEADER);
			strposBuildTimeHeader = strstr(line, BUILDTIMEHEADER);

			//is it one of our "magic" lines?
			if (0 != strposBuildNumHeader) {

				//get to the meat of the line!
				strposBuildNumHeader += strlen(BUILDNUMHEADER);

				cout << "Found BuildNum line, incrementing...\n";
				BuildNumFound = true;

				int found = sscanf(strposBuildNumHeader, "%lX", &buildNumber);

				if (found <= 0) {
					cout << "BuildNum line found, but no value to extract!  Using 0!\n";
				}

				// Increment our build number
				buildNumber++;

				// Output the build count
				cout << "Build number: " << buildNumber << endl;

				char temp[17];
				sprintf(temp, "%.8lX", buildNumber);

				//Set up the new line to write out:
				strcpy(strposBuildNumHeader, temp);
				strcat(strposBuildNumHeader, "\"; -- (");
				sprintf(temp, "%ld", buildNumber);
				strcat(strposBuildNumHeader, temp);
				strcat(strposBuildNumHeader, " decimal)");
			}

			//is it one of our "magic" lines?
			if ( 0 != strposBuildTimeHeader ) {

				//get to the meat of the line!
				strposBuildTimeHeader += strlen(BUILDTIMEHEADER);

				cout << "Found BuildTime line, replacing with current time...\n";
				BuildTimeFound = true;

				//Get buildtime
				time_t rawtime;
				time ( &rawtime );
				
				//convert to ascii
				tm* ptm = gmtime ( &rawtime );
				char* asc = asctime(ptm);
				unsigned int crlfpos = strcspn(asc, "\r\n");
				char ascwocrlf[1024];
				if (crlfpos >= 1023) { crlfpos = 1023; }
				strncpy(ascwocrlf, asc, crlfpos);
				ascwocrlf[crlfpos] = '\0';
				
				char temp[17];
				sprintf(temp, "%.8lX", rawtime);

				//Set up the new line to write out:
				strcpy(strposBuildTimeHeader, temp);
				strcat(strposBuildTimeHeader, "\"; -- (seconds since 01/01/1970 -> ");
				strcat(strposBuildTimeHeader, ascwocrlf);
				strcat(strposBuildTimeHeader, ")");
			}

			//write the line to the output file
			Out << line << endl;
		}

		//EOF:
		if (!BuildNumFound) {
			cout << "!BuildNum line not found in " << fileName << " (we were looking for a line starting with \"" << BUILDNUMHEADER << "\"\n";
		}
		if (!BuildTimeFound) {
			cout << "!BuildTime line not found in " << fileName << " (we were looking for a line starting with \"" << BUILDTIMEHEADER << "\"\n";
		}
	}

	else { //if (In.is_open)

		cout << "Input filename invalid, not found, or locked.\n";
	}

	cout << "Moving old file to new." << endl;

	if ( 0 != remove(fileName.c_str()) ) {
		cout << "Error deleting origonal file." << endl;
	}

	if ( 0 != rename( ofileName.c_str() , fileName.c_str()) ) {
		cout << "Error moving new file to origonal file." << endl;
	}

	cout << "Done." << endl;

	// peace
	return 0;
}
