
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
// =================================================================
// main pgoram
int main(int argc, char** argv) {

	// They should pass us one argument.. the name of the executable being built
	if (argc != 2) {
		// otherwise gracefully exit.
		cout << "-1" << endl;
		return 1;
	}

	// Get the name of the project we're building for
	string projectName = argv[1];
	projectName += "BuildNum";

	long buildNumber;

	// See if it has a build count file already
	ifstream In(projectName.c_str());

	if (In) {
		// Ok, it had one
		// Get the build number (on the fifth line)
		In.ignore(INT_MAX, '\n');
		In.ignore(INT_MAX, '\n');
		In.ignore(INT_MAX, '\n');
		In.ignore(INT_MAX, '\n');
		In.ignore(INT_MAX, '\n');
		In.ignore(INT_MAX, '\n');
		In.ignore(strlen("static const unsigned int BuildNum = "), '\n');
		In >> buildNumber;
		In.close();

		// Output the build count
		cout << buildNumber << endl;
	}

	// peace
	return 0;
}
