
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
// =================================================================
// main pgoram
int main(int argc, char** argv) {

	// echo the build title
	cout << BUILD_TITLE << endl;

	// They should pass us one argument.. the name of the executable being built
	if (argc != 2) {
		// otherwise gracefully exit.
		cout << "Invalid number of command line parameters.. exiting" << endl;
		return 1;
	}

	// Get the name of the project we're building for
	string projectName = argv[1];
	projectName += "BuildNum";

	long int buildNumber = 1;

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

		// Increment our build number
		buildNumber++;

		// Output the build count
		cout << "Build number: " << buildNumber;
	}
	else {

		buildNumber = 0;

		// Otherwise it's our first build
		cout << "Build number: 0" << endl;

		// Ok, this is the first time.  Create the file.
		ofstream Out(projectName.c_str());
		Out << projectName << BUILD_MSG << endl
			<< "0" << endl;
	}

	//Get buildtime
	time_t rawtime;
	tm * ptm;
	time ( &rawtime );
	ptm = gmtime ( &rawtime );
	char* asc = asctime(ptm);
	unsigned int crlfpos = strcspn(asc, "\r\n");
	char ascwocrlf[1024];
	if (crlfpos >= 1023) { crlfpos = 1023; }
	strncpy(ascwocrlf, asc, crlfpos + 1);
	ascwocrlf[crlfpos] = '\0';

	// Now re-open that file and output the changed count
	ofstream Out(projectName.c_str());

	Out << "//\n"
		<< "// " << projectName << "\n"
		<< "// " << BUILD_MSG << "\n"
		<< "//\n\n"
		<< "#pragma once\n"
		<< "static const unsigned int BuildNum = " << buildNumber << ";\n"
		<< "static const time_t BuildTimeT = " << rawtime << ";\n"
		<< "static const char BuildTimeStr[] = \"" << ascwocrlf << "\";\n"
		<< "\n//EOF\n";

	// peace
	return 0;
}
