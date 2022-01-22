echo "~~~ MENU ~~~"
echo "Please enter the number of choice:"
options=("Create DataBase" "List" "Connect To DB" "Drop DB" "Exit")
select val in "${options[@]}"
do
    case $val in
        "Create DataBase")
           clear ; . commands/CreateDatabase.sh ; . backTOmenu.sh
            ;;
        "List")
           clear ; . commands/ListDataBase.sh ; . backTOmenu.sh
            ;;
        "Connect To DB")
            clear ; . commands/ConnectDatabase.sh ; . backTOmenu.sh
           ;;
        "Drop DB")
            clear ; . commands/DeletDatabase.sh ; . backTOmenu.sh
           ;;  
        "Exit")
            echo "Goodbye 😘" ; exit
            ;;
        *) clear ; echo "invalid option" ; . select.sh ;;
    esac
done