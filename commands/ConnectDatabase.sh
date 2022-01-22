    #!/bin/bash
    
function ConnectMenu {
    echo "Successfully connected to $DatabaseConnect database"
    echo "Connect Menu:"
    select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Go to Main Menu"
    do    
    case $choice in
        "Create Table" ) CreateTable ;;
        "List Tables" ) listTables ;;
        "Drop Table" ) DropTable ;;
        "Insert into Table" ) InsertIntoTable;;
        "Select From Table" ) echo Select ;;
        "Delete From Table" ) echo Delete ;;
        "Go to Main Menu" ) cd .. ; MainMenu ;;
        * ) echo $REPLY is not one of the choices ;;
    esac
    done
}
    
    
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
