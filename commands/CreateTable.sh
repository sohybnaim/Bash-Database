#!/bin/bash    
    
    
    echo "Enter the Table Name:"
    read TableName
    flag=0

    createT_arr=(`ls`)
    for i in $(seq 1 ${#createT_arr[@]})
    do  
        if [ "${createT_arr[i-1]}" = "$TableName" ]
        then 
            echo "This table name already exists"
            flag=1
        fi
    done

    if [ $flag -ne 1 ]
    then
        touch $TableName
        echo "$TableName table is created successfully"
    fi