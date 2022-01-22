    echo "Enter the table you want to insert into:"
    read TableName
    # check if table exists
    echo "Enter the number of table columns:"
    read no_cols

    for i in $(seq $no_cols)
    do
        echo "Enter the name of column number $i:"
        read col_$i
        meta+= echo col_$i  
    done

    # echo $col_1
    
    echo $meta