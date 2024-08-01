
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
const char BUILDNUMHEADER [] = "constant BuildNum : std_logic_vector(31 downto 0) := x\"";
// =================================================================
// main pgoram
int main(int argc, char** argv) 
{
	char line[2048];

	// They should pass us one argument.. the name of the executable being built
	if (argc != 2) {
		// otherwise gracefully exit.
		cout << "-1" << endl;
		return 1;
	}

	// Get the name of the project we're building for
	string fileName = argv[1];

	unsigned long buildNumber = 0;
	bool BuildNumFound = false;
	bool BuildTimeFound = false;
	char* strposBuildNumHeader;
	char* strposBuildTimeHeader;

	// See if it has a build count file already
	ifstream In(fileName.c_str());

	if (In.is_open()) {

		while (!In.eof()) {

			//Get line
			In.getline(line, 2048);

			strposBuildNumHeader = strstr(line, BUILDNUMHEADER);

			//is it one of our "magic" lines?
			if (0 != strposBuildNumHeader) {

				//get to the meat of the line!
				strposBuildNumHeader += strlen(BUILDNUMHEADER);

				//~ cout << "Found BuildNum line, incrementing...\n";
				BuildNumFound = true;

				int found = sscanf(strposBuildNumHeader, "%lX", &buildNumber);

				if (found <= 0) {
					//~ cout << "BuildNum line found, but no value to extract!  Using 0!\n";
				}

				// Output the build count
				cout << buildNumber << endl;
				//~ cout << buildNumber;
			}
		}

		//EOF:
		if (!BuildNumFound) {
			cout << "-2";
		}
	}

	else { //if (In.is_open)

		cout << "-3";
	}

	// peace
	return 0;
}
