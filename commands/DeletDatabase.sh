    echo "Enter the database you want to drop:"
    read DB
    
    findRes=`find -name $DB`

    if [ "./$DB" = "$findRes" ] 
        then
        echo "print yes or no to confirm droping"
            rm -Ir $DB  
    else
        echo "$DB database doesn't exist"
    fi