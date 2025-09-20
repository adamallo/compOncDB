#!/bin/bash

##############################################################################
# This script will install scripts for the compOncDB package.
# 
# Required programs:	Go 1.16+
##############################################################################

MAIN="componcdb"

prepareModule () {
	echo "Setting go.mod"
	go mod init github.com/icwells/compOncDB
	MYSQL="github.com/go-sql-driver/mysql@v1.5"
#	ETREE="github.com/beevik/etree"
#	DATAFRAME="github.com/icwells/go-tools/dataframe"
#	FRACTION="github.com/icwells/go-tools/fraction"
#	IOTOOLS="github.com/icwells/go-tools/iotools"
#	STRARRAY="github.com/icwells/go-tools/strarray"
#	KINGPIN="github.com/alecthomas/kingpin/v2"
#	MUX="github.com/gorilla/mux"
#	SCHEMA="github.com/gorilla/schema"
#	COOKIE="github.com/gorilla/securecookie"
#	SEESSIONS="github.com/gorilla/sessions"
#	DBIO="github.com/icwells/dbIO"
#	SIMPLESET="github.com/icwells/simpleset"
#	FUZZY="github.com/lithammer/fuzzysearch/fuzzy"
#	ASPELL="github.com/trustmaster/go-aspell"
	deps=($MYSQL)
	for I in $deps; do
		go get $I
	done
	echo ""
	go mod tidy
}

installPackages () {
	for I in scikit-learn tensorflow tensorflow_hub; do
		pip install $I
	done
}

installMain () {
	# compOncDB 
	echo "Installing $MAIN and its dependencies..."
	go install ./...
	mv $GOPATH/bin/src $GOPATH/bin/$MAIN ##I should refactor the code to solve this, but I do not want to spend the time right now
	echo ""
}

echo ""
echo "Preparing compOncDB package..."
echo "GOPATH identified as $GOPATH"
echo ""

if [ $# -eq 0 ]; then
	installMain
elif [ $1 = "module" ]; then
	prepareModule
elif [ $1 = "main" ]; then
	installMain
elif [ $1 = "all" ]; then
	if [ ! -f go.mod ]; then
		prepareModule
	fi
	installPackages
	installMain
elif [ $1 = "help" ]; then
	echo "Installs Go scripts for compOnDB"
	echo ""
	echo "main	Installs scripts to GOBIN only."
	echo "module	Prepares the module (for development only)"
	echo "all	Prepares the module if needed, installs all scripts and dependencies."
	echo "help	Prints help text and exits."
	echo ""
fi

echo "Finished"
echo ""
