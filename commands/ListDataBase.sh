    dbs=`ls -A | wc -l`

    if [ $dbs -eq 0 ]
        then 
            echo "No Databases found"
    else
        ls -d */
    fi