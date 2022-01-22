    #!/bin/bash
    
    
    echo "Enter the table you want to drop:"
    read TableName
    
    flag_d=0
    
    dropT_arr=(`ls`)
    for i in $(seq ${#dropT_arr[@]})
    do  
        if [ "${dropT_arr[i-1]}" = "$TableName" ]
        then
            flag_d=1
        fi
    done

    if [ $flag_d -eq 1 ]
    then
        rm $TableName
        echo "$TableName table is dropped"
    else
        echo "This table name doesn't exist"
    fi