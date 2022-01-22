#!/bin/bash

    echo "Enter the Database Name:"
    read databaseName

    findRes=`find -name $databaseName 2>>/dev/null`

    if [ "./$databaseName" = "$findRes" ]
        then 
        echo "This Database name already exists"
    else
        mkdir $databaseName
        echo "$databaseName database is created successfully" 
    fi
