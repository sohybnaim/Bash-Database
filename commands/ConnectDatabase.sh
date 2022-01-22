    echo "Enter the Database you want to connect to:"
    read DatabaseConnect

    findRes=`find -name $DatabaseConnect`

    if [ "./$DatabaseConnect" = "$findRes" ] 
        then 
            cd $DatabaseConnect
            ConnectMenu
    else
        echo "This database doesn't exist"
    fi