#!/bin/bash
#  function CreateTable {
#     echo "Enter the Table Name:"
#     read TableName
#     flag=0

#     createT_arr=(`ls`)
#     for i in $(seq 1 ${#createT_arr[@]})
#     do  
#         if [ "${createT_arr[i-1]}" = "$TableName" ]
#         then 
#             echo "This table name already exists"
#             flag=1
#         fi
#     done

#     if [ $flag -ne 1 ]
#     then
#         touch $TableName
#         echo "$TableName table is created successfully"
#     fi
# }

echo "~~~ MENU ~~~"
echo "Please enter the number of choice:"
options=("Create DataBase" "List" "Connect To DB" "Drop DB" "Exit")
select val in "${options[@]}"
do
    case $val in
        "Create DataBase")
           clear ; . CreateDatabase.sh ; . backTOmenu.sh
            ;;
        "List")
           clear ; . ListDataBase.sh ; . backTOmenu.sh
            ;;
        "Connect To DB")
            clear ; . ConnectDatabase.sh ; . backTOmenu.sh
           ;;
        "Drop DB")
            clear ; . DeletDatabase.sh ; . backTOmenu.sh
           ;;  
        "Exit")
            echo "Goodbye 😘" ; exit
            ;;
        *) clear ; echo "invalid option" ; . select.sh ;;
    esac
done