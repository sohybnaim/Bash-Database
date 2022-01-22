#!/bin/bash
# A simple databases management system using Bash Shell scripting 
mkdir DBMS 2>> ./.error.log
clear
echo "Welcome To DBMS"
function Menu {
  echo -e "\n+-------------Menu--------------+"
  echo "    1- Create DB                 "
  echo "    2- Select DB                 "
  echo "    3- Drop DB                   "
  echo "    4- Show DBs                  "
  echo "    5- Exit                      "
  echo "+-------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1)  createDataBase ;;
    2)  selectDataBase;;
    3)  dropDataBase ;;
    4)  ls ./DBMS ; Menu;;
    5) exit ;;
    *) echo " Wrong Choice " ; Menu;
  esac
}

function createDataBase {
  echo -e "Enter Database Name: \c"
  read dbName
  mkdir ./DBMS/$dbName
  if [[ $? == 0 ]]
  then
    echo "Database Created Successfully"
  else
    echo "Error Creating Database $dbName"
  fi
  Menu
}

function selectDataBase {
  echo -e "Enter Database Name: \c"
  read dbName
  cd ./DBMS/$dbName 2>>./.error.log
  if [[ $? == 0 ]]; then
    echo "Database $dbName was Successfully Selected"
    optionsMenu
  else
    echo "Database $dbName wasn't found"
    Menu
  fi
}

function dropDataBase {
  echo -e "Enter Database Name: \c"
  read dbName
  rm -r ./DBMS/$dbName 2>>./.error.log
  if [[ $? == 0 ]]; then
    echo "Database Dropped Successfully"
  else
    echo "Database Not found"
  fi
  Menu
}

function optionsMenu {
  echo -e "\n+--------Options Menu------------+"
  echo "    1- Show Existing Tables       "
  echo "    2- Create New Table           "
  echo "    3- Insert Into Table          "
  echo "    4- Select From Table          "
  echo "    5- Update Table               "
  echo "    6- Delete From Table          "
  echo "    7- Drop Table                 "
  echo "    8- Back To Main Menu          "
  echo "    9- Exit                       "
  echo "+-------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1)  ls .; optionsMenu ;;
    2)  createTable ;;
    3)  insert;;
    4)  clear; selectMenu ;;
    5)  updateTable;;
    6)  deleteFromTable;;
    7)  dropTable;;
    8) clear; cd ../.. 2>>./.error.log; Menu ;;
    9) exit ;;
    *) echo " Wrong Choice " ; optionsMenu;
  esac

}

function createTable {
  echo -e "Table Name: \c"
  read tableName
  if [[ -f $tableName ]]; then
    echo "table already existed ,choose another name"
    optionsMenu
  fi
  echo -e "Number of Columns: \c"
  read colsNum
  counter=1
  sep="|"
  rSep="\n"
  pKey=""
  metaData="Field"$sep"Type"$sep"key"
  while [ $counter -le $colsNum ]
  do
    echo -e "Name of Column No.$counter: \c"
    read colName

    echo -e "Type of Column $colName: "
    select var in "int" "varchar"
    do
      case $var in
        int ) colType="int";break;;
        varchar ) colType="varchar";break;;
        * ) echo "Wrong Choice" ;;
      esac
    done
    if [[ $pKey == "" ]]; then
      echo -e "Make PrimaryKey ? "
      select var in "yes" "no"
      do
        case $var in
          yes ) pKey="PK";
          metaData+=$rSep$colName$sep$colType$sep$pKey;
          break;;
          no )
          metaData+=$rSep$colName$sep$colType$sep""
          break;;
          * ) echo "Wrong Choice" ;;
        esac
      done
    else
      metaData+=$rSep$colName$sep$colType$sep""
    fi
    if [[ $counter == $colsNum ]]; then
      temp=$temp$colName
    else
      temp=$temp$colName$sep
    fi
    ((counter++))
  done
  touch .$tableName
  echo -e $metaData  >> .$tableName
  touch $tableName
  echo -e $temp >> $tableName
  if [[ $? == 0 ]]
  then
    echo "Table Created Successfully"
    optionsMenu
  else
    echo "Error Creating Table $tableName"
    optionsMenu
  fi
}

function dropTable {
  echo -e "Enter Table Name: \c"
  read tName
  rm $tName .$tName 2>>./.error.log
  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $tName"
  fi
  optionsMenu
}

function insert {
  echo -e "Table Name: \c"
  read tableName
  if ! [[ -f $tableName ]]; then
    echo "Table $tableName isn't existed ,choose another Table"
    optionsMenu
  fi
  colsNum=`awk 'END{print NR}' .$tableName`
  sep="|"
  rSep="\n"
  for (( i = 2; i <= $colsNum; i++ )); do
    colName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$tableName)
    colType=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName)
    colKey=$(awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName)
    echo -e "$colName ($colType) = \c"
    read data

    # Validate datatype
    if [[ $colType == "int" ]]; then
      while ! [[ $data =~ ^[0-9]*$ ]]; do
        echo -e "invalid DataType !!"
        echo -e "$colName ($colType) = \c"
        read data
      done
    fi

    if [[ $colKey == "PK" ]]; then
      while [[ true ]]; do
        if [[ $data =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tableName`]$ ]]; then
          echo -e "invalid input for Primary Key !!"
        else
          break;
        fi
        echo -e "$colName ($colType) = \c"
        read data
      done
    fi

    #Set row
    if [[ $i == $colsNum ]]; then
      row=$row$data$rSep
    else
      row=$row$data$sep
    fi
  done
  echo -e $row"\c" >> $tableName
  if [[ $? == 0 ]]
  then
    echo "Data Inserted Successfully"
  else
    echo "Error Inserting Data into Table $tableName"
  fi
  row=""
  optionsMenu
}

function updateTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Condition Column name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    optionsMenu
  else
    echo -e "Enter Condition Value: \c"
    read val
    res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tName 2>>./.error.log)
    if [[ $res == "" ]]
    then
      echo "Value Not Found"
      optionsMenu
    else
      echo -e "Enter FIELD name to set: \c"
      read setField
      setFid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$setField'") print i}}}' $tName)
      if [[ $setFid == "" ]]
      then
        echo "Not Found"
        optionsMenu
      else
        echo -e "Enter new Value to set: \c"
        read newValue
        NR=$(awk 'BEGIN{FS="|"}{if ($'$fid' == "'$val'") print NR}' $tName 2>>./.error.log)
        oldValue=$(awk 'BEGIN{FS="|"}{if(NR=='$NR'){for(i=1;i<=NF;i++){if(i=='$setFid') print $i}}}' $tName 2>>./.error.log)
        echo $oldValue
        sed -i ''$NR's/'$oldValue'/'$newValue'/g' $tName 2>>./.error.log
        echo "Row Updated Successfully"
        optionsMenu
      fi
    fi
  fi
}

function deleteFromTable {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Condition Column name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    optionsMenu
  else
    echo -e "Enter Condition Value: \c"
    read val
    res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tName 2>>./.error.log)
    if [[ $res == "" ]]
    then
      echo "Value Not Found"
      optionsMenu
    else
      NR=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print NR}' $tName 2>>./.error.log)
      sed -i ''$NR'd' $tName 2>>./.error.log
      echo "Row Deleted Successfully"
      optionsMenu
    fi
  fi
}

function selectMenu {
  echo -e "\n\n+--------------Select Menu--------------------+"
  echo "   1- Select All Columns of a Table              "
  echo "   2- Select Specific Column from a Table        "
  echo "   3- Select From Table under condition          "
  echo "   4- Aggregate Function for a Specific Column   "
  echo "   5- Back To Options Menu                       "
  echo "   6- Back To Main Menu                          "
  echo "   7- Exit                                       "
  echo "+-----------------------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1) selectAll ;;
    2) selectCol ;;
    3) clear; selectCon ;;
    4) ;;
    5) clear; optionsMenu ;;
    6) clear; cd ../.. 2>>./.error.log; Menu ;;
    7) exit ;;
    *) echo " Wrong Choice " ; selectMenu;
  esac
}

function selectAll {
  echo -e "Enter Table Name: \c"
  read tName
  column -t -s '|' $tName 2>>./.error.log
  if [[ $? != 0 ]]
  then
    echo "Error Displaying Table $tName"
  fi
  selectMenu
}

function selectCol {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Column Number: \c"
  read colNum
  awk 'BEGIN{FS="|"}{print $'$colNum'}' $tName
  selectMenu
}

function selectCon {
  echo -e "\n\n+--------Select Under Condition Menu---------+"
  echo "     1- Select All Columns Matching Condition    "
  echo "     2- Select Specific Column Matching Condition"
  echo "     3- Back To Selection Menu                   "
  echo "     4- Back To Main Menu                        "
  echo "     5- Exit                                     "
  echo "+---------------------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1) clear; allCond ;;
    2) clear; specCond ;;
    3) clear; selectCon ;;
    4) clear; cd ../.. 2>>./.error.log; Menu ;;
    5) exit ;;
    *) echo " Wrong Choice " ; selectCon;
  esac
}

function allCond {
  echo -e "Select all columns from TABLE Where FIELD(OPERATOR)VALUE \n"
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter required FIELD name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    selectCon
  else
    echo -e "\nSupported Operators: [==, !=, >, <, >=, <=] \nSelect OPERATOR: \c"
    read op
    if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
    then
      echo -e "\nEnter required VALUE: \c"
      read val
      res=$(awk 'BEGIN{FS="|"}{if ($'$fid$op$val') print $0}' $tName 2>>./.error.log |  column -t -s '|')
      if [[ $res == "" ]]
      then
        echo "Value Not Found"
        selectCon
      else
        awk 'BEGIN{FS="|"}{if ($'$fid$op$val') print $0}' $tName 2>>./.error.log |  column -t -s '|'
        selectCon
      fi
    else
      echo "Unsupported Operator\n"
      selectCon
    fi
  fi
}

function specCond {
  echo -e "Select specific column from TABLE Where FIELD(OPERATOR)VALUE \n"
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter required FIELD name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    selectCon
  else
    echo -e "\nSupported Operators: [==, !=, >, <, >=, <=] \nSelect OPERATOR: \c"
    read op
    if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
    then
      echo -e "\nEnter required VALUE: \c"
      read val
      res=$(awk 'BEGIN{FS="|"; ORS="\n"}{if ($'$fid$op$val') print $'$fid'}' $tName 2>>./.error.log |  column -t -s '|')
      if [[ $res == "" ]]
      then
        echo "Value Not Found"
        selectCon
      else
        awk 'BEGIN{FS="|"; ORS="\n"}{if ($'$fid$op$val') print $'$fid'}' $tName 2>>./.error.log |  column -t -s '|'
        selectCon
      fi
    else
      echo "Unsupported Operator\n"
      selectCon
    fi
  fi
}
Menu
