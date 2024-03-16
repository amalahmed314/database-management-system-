#! /bin/bash

main_dir="./DB"
database=""


 if [ ! -d "$main_dir" ];then

       mkdir -p "$main_dir"
 fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${BLUE}<<* Welcome to A&A DataBase *>>${RESET}"



# Main Menu

main_menu() {
while true;do
echo -e "\nMain Menu: "
echo "1) Create Database"
echo "2) List Databases"
echo "3) Connect to Database"
echo "4) Drop Database"
echo "5) Quit"
echo "-------------------------------"

read -p "Enter your choice: " choice

case $choice in
1)create_database;;
2)list_databases;;
3)connect_to_database;;
4)drop_database;;
5)echo "GoodBye!";exit;;
*)echo -e "${RED}Invalid option :( Please Try Again !!${RESET}";;
esac
done
}

connect_menu(){
while true;do
echo "1) Create Table"
echo "2) List Tables"
echo "3) Drop Tables"
echo "4) Insert into Table"
echo "5) Select from Table"
echo "6) Delete from Table"
echo "7) Update Raw"
echo "8) Exit From Database"
echo "-------------------------------"
read -p "Enter your choice: " choice


case $choice in
1)create_table;;
2)list_tables;;
3)drop_table;;
4)insert_into_table;;
5)select_from_table;;
6)delete_from_table;;
7)update_raw;;
8)exit_from_database;
	break;;
*)echo -e "${RED}Invalid option :( Please Try Again !!${RESET}";;
esac
done

}

#  >> FUNCTIONS <<
create_database(){
read -p "Enter Name Of DataBase You Want To Add: " database

       invalid_char=$(echo "$database" | grep -o '(?i)[-!@#$%^&*()]') 
       if [ -n "$invalid_char" ];then
            echo "<<----------------->>"
             echo -e "${RED}Error: Invalid characters found in database name: $invalid_char ${RESET}"
             echo "<<----------------->>"
             return 1
       fi
       if [[ $database =~ ^[0-9] ]];then 
             echo "<<----------------->>"
             echo -e "${RED}Error: The first character cannot be a number.${RESET}"
             echo "<<----------------->>"
             return 1 
       fi  
       if [ -z "$database" ]; then
            echo "<<----------------->>"
            echo -e "${RED}Error:  Name of DataBase cannot be empty.${RESET}"
            echo "<<----------------->>"
            return
       fi
       database_lower=$(echo "$database" | tr '[:upper:]' '[:lower:]')
       database_upper=$(echo "$database" | tr '[:lower:]' '[:upper:]')

       if [ -d "$main_dir/$database_lower" ] || [ -d "$main_dir/$database_upper" ]; then
             echo "<<----------------->>"     
             echo -e "${MAGENTA}$database_lower is already exists${RESET}"
             echo "<<----------------->>"
       else 
             mkdir -p "$main_dir/$database_lower"
             echo -e "${GREEN}<<<< $database_lower is created successfully :) >>>>${RESET}"
       fi
}

#---------->>LIST DATABASES<<-----------#
list_databases(){

    if [ -d "$main_dir" ] && [ "$(ls -A "$main_dir")" ]; then
        echo -e "${MAGENTA}<<---Your DataBaes---->>${RESET}"
        ls -d "$main_dir"/* | sed 's/^.*\///'
    else
        echo -e "${MAGENTA}<<<<No databases added yet!.>>>>${RESET}"
    fi

}

#---------->>CONNECT TO DATABASE<<------#
connect_to_database(){

read -p "Enter Name of DataBase You Want To Connect: " database
echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
invalid_char=$(echo "$database" | grep -o '(?i)[-!@#$%^&*()]')
       if [ -n "$invalid_char" ];then
             echo "<<----------------->>" 
             echo -e "${RED}Error: Invalid characters found in database name: $invalid_char${RESET}"
             echo "<<----------------->>"
             return 1
       fi
       if [[ $database =~ ^[0-9] ]];then 
             echo "<<----------------->>"
             echo -e "${RED}Error: The first character cannot be a number.${RESET}"
             echo "<<----------------->>"
             return 1
       fi
       if [ -z "$database" ]; then
            echo "<<----------------->>"
            echo -e "${RED}Error:  Name of DataBase cannot be empty.${RESET}"
            echo "<<----------------->>"
            return
       fi
       database_lower=$(echo "$database" | tr '[:upper:]' '[:lower:]')
       database_upper=$(echo "$database" | tr '[:lower:]' '[:upper:]')

      if [ -d "$main_dir/$database_lower" ] || [ -d "$main_dir/$database_upper" ]; then
            echo -e "${GREEN}Connecting To $database_lower ....${RESET}"
                 cd "$main_dir/$database_lower"
                 connect_menu;
      else
            echo -e "${RED}<<<< This Database $database_lower Does not exist :( >>>>${RESET}"
      fi
}

#---------->>DROP DATABASE<<-----------#
drop_database(){
read -p "Enter Name Of Dtabase You Want To Drop: " database
echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

      # Validation for empty input
  if [ -z "$database" ]; then
    echo -e "${RED}Error: Name of Database cannot be empty.${RESET}"
    return 1
  fi

  # Validation for invalid characters
  if [[ "$database" =~ [^a-zA-Z0-9_] ]]; then
    echo -e "${RED}Error: Database name contains invalid characters.${RESET}"
    return 1
  fi

  # Validation for numeric start
  if [[ "$database" =~ ^[0-9] ]]; then
    echo -e "${RED}Error: Database name cannot start with a number.${RESET}"
    return 1
  fi

  # Convert to lowercase for case insensitivity
  database_lower=$(echo "$database" | tr '[:upper:]' '[:lower:]')
  database_dir="$main_dir/$database_lower"

  # Check if the directory exists and remove
  if [ -d "$database_dir" ]; then
    rm -rf "$database_dir"
    echo -e "${GREEN}$database has been dropped successfully :)${RESET}"
  else
    echo -e "${RED}$database does not exist :(${RESET}"
  fi
}

#---------->>CREATE TABLE<<-----------#
create_table(){
read -p "Please Enter The Name Of Table: " nameOfTable
echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

      
       if [ -z "$nameOfTable" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Table name cannot be empty.${RESET}"
        echo "<<----------------->>"
        return
       fi
invalid_characters=$(echo "$nameOfTable" | grep -o '(?i)[-!@#$%^&*()]')
       if [ -n "$invalid_characters" ]; then
             echo "<<----------------->>"
             echo -e "${RED}Error: Invalid characters found in Table name: $invalid_characters${RESET}"
             echo "<<----------------->>"
             return 1
       fi
       if [[ $nameOfTable =~ ^[0-9] ]]; then
             echo "<<----------------->>"
             echo -e "${RED}Error: The first character cannot be a number.${RESET}"
             echo "<<----------------->>"
             return 1
       fi
tableNaame_lower=$(echo "$nameOfTable" | tr '[:upper:]' '[:lower:]')
tableName_upper=$(echo "$nameOfTable" | tr '[:lower:]' '[:upper:]')
       if [ -f "$tableNaame_lower.text" ] || [ -f "$tableName_upper.text" ]; then
             echo -e "${MAGENTA}<<<< $tableNaame_lower is already exists >>>>${RESET}"
             return 
       
       else
           
             read -p "Please Enter The Number Of Columns: " numOfColumns
             echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

             if ! [[ "$numOfColumns" =~ ^[1-9][0-9]*$ ]]; then 
                      echo "<<----------------->>"
                      echo -e "${RED}Invalid input for the number of columns. Please enter a positive integer.${RESET}"
                      echo "<<----------------->>"
                      return
             else
                      pk_set=false
                      pk_column=""
                      column_names=() 
                      for (( i=1 ; i <=$numOfColumns ;i++ ))
                          do
                              read -p "Enter The Name Of Column No.$i : " name1
                              echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                                    
                                    if [ -z "$name1" ]; then
                                       echo "<<----------------->>"
                                       echo -e "${RED}Error:  Name of Column cannot be empty.${RESET}"
                                       echo "<<----------------->>"
                                       return
                                    fi
                                    invalid_char1=$(echo "$name1" | grep -o '(?i)[-!@#$%^&*()]')
                                                 if [ -n "$invalid_char1" ];then
                                                      echo "<<----------------->>"
                                                      echo -e "${RED}Error: Invalid characters found in Column name: $invalid_char1${RESET}"
                                                      echo "<<----------------->>"
                                                      return 1
                                                 fi
                                                 if [[ $name1 =~ ^[0-9] ]];then
                                                      echo "<<----------------->>"
                                                      echo -e "${RED}Error: The first character cannot be a number.${RESET}"
                                                      echo "<<----------------->>"
                                                      return 1
                                                 fi
                                    name1_lower=$(echo "$name1" | tr '[:upper:]' '[:lower:]')
                                    if [[ " ${column_names[@]} " =~ " $name1_lower " ]]; then
                                            echo "<<----------------->>"
                                            echo -e "${RED}Error: Duplicate column name '$name1'. Column names must be unique.${RESET}"
                                            echo "<<----------------->>"
                                            return
                                    fi
                                    
                                     read -p "Enter the Type of This Column (Text/Int)" columnType
                                     echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                                             if [ -z "$columnType" ]; then
                                                echo "<<----------------->>"
                                                echo -e "${RED}Error: Column type cannot be empty.${RESET}"
                                                echo "<<----------------->>"
                                                return
                                             fi
                                    columnType_lower=$(echo "$columnType" | tr '[:upper:]' '[:lower:]')
                                             if [ "$columnType_lower" != "text" ] && [ "$columnType_lower" != "int" ]; then
                                             echo "<<----------------->>"
                                                echo -e "${RED}Error: Invalid column type. Please enter 'Text' or 'Int'.${RESET}"
                                                echo "<<----------------->>"
                                                return
                                             fi
                              column_names+=("$name1_lower($columnType_lower)")
                               if [ "$pk_set" = false ]; then   
                              read -p "Do you Want To Set This Column As PK ? y/n " answer
                              echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                                   if [ -z "$answer" ]; then
                                      echo "<<----------------->>"
                                   echo -e "${RED}Error:This Field cannot be empty.${RESET}"
                                   echo "<<----------------->>"
                                   return
                                   fi
                                   
                                    if [ "$answer" = Y ] || [ "$answer" = y ]; then
                                       if [ "$columnType_lower" = "int" ]; then
                                          pk_set=true
                                          pk_column="$name1_lower"
                                       else
                                          echo "<<----------------->>" 
                                          echo -e "${RED}Unfortunately~ PK must be of type Int :( .${RESET}"
                                          echo "<<----------------->>"
                                          return
                                       fi    
                                    elif [ "$answer" = N ] || [ "$answer" = n ]; then
                                         echo "OK"
                                    else
                                         echo "<<----------------->>"
                                         echo -e "${RED}Error: Invalid choice. Please enter 'y' or 'n'.${RESET}"
                                         echo "<<----------------->>"
                                         return 
                                    fi
                               fi
                
                          done
                               if [ "$pk_set" = false ]; then
                                  pk_column="my_pk"
                                  column_names+=("$pk_column(int)")
                                  echo -e "${GREEN}Generating default PK column...${RESET}"
                               fi
                             
             fi
              echo "Table Name: $tableNaame_lower" > $tableNaame_lower.text
              echo "Number of Columns: $numOfColumns " >> $tableNaame_lower.text
              echo "pk:$pk_column" >> $tableNaame_lower.text
              echo "${column_names[@]}" >> $nameOfTable.text #columns 
              touch raw_data_$tableNaame_lower.text
              echo -e "${GREEN}$tableNaame_lower is created successfully :)${RESET}"
       fi
echo "<<----------------->>"
read -p "Press Enter to continue..."

}

#---------->>LIST TABLES<<-----------#

list_tables(){
table_files="*.text"

   if [ -n "$(ls $table_files 2>/dev/null)" ]; then
        echo "Tables in the $database database:"
        for table in $table_files; do
             if [[ "$table" != "raw_data_"* ]]; then
                table_name=$(basename -- "$table")
                echo "${table_name%.*}"
            fi
        done
   else
        echo "<<----------------->>"
        echo -e "${MAGENTA}There are No Tables to list yet!${RESET}"
        echo "<<----------------->>"
   fi 
        
  
}

#---------->>INSERT INTO TABLE<<-----------#
insert_into_table(){

  read -p "Enter the Name of the Table: " tableName
  echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

  ##validation##
  if [ -z "$tableName" ]; then
    echo "<<----------------->>"
    echo -e "${RED}Error:  Name of Table cannot be empty.${RESET}"
    echo "<<----------------->>"
    return
  fi
  invalid_char1=$(echo "$tableName" | grep -o '(?i)[-!@#$%^&*()]')
  if [ -n "$invalid_char1" ];then
    echo "<<----------------->>"
    echo -e "${RED}Error: Invalid characters found in Table name: $invalid_char1${RESET}"
    echo "<<----------------->>"
    return 1
  fi
  if [[ $tableName =~ ^[0-9] ]];then
    echo "<<----------------->>"
    echo -e "${RED}Error: The first character cannot be a number.${RESET}"
    echo "<<----------------->>"
    return 1
  fi
tableName_lower=$(echo "$tableName" | tr '[:upper:]' '[:lower:]')

  table_file="${tableName_lower}.text"

  if [ ! -f "$table_file" ]; then
    echo "<<----------------->>"
    echo -e "${RED}Error: Table '$tableName' does not exist.${RESET}"
    echo "<<----------------->>"
    return
  fi

  declare -a column_arr
  read -r numColumns < <(awk -F ' ' '/Number of Columns:/ {print $NF}' "$table_file")
  read -r pk_column < <(awk 'BEGIN{FS=":";}{if(NR==3){print $2};}' "$table_file")
  read -ra column_arr < <(awk 'BEGIN{FS="  ";}{if(NR==4){print $0};}' "$table_file")
# Find the position of the primary key column
  pk_column_position=$(awk -F ' ' -v pk="$pk_column" 'NR==4 {for (i=1; i<=NF; i++) if ($i ~ pk) print i; exit;}' "$table_file")
# echo "$pk_column_position"
  values=()
  pk_column_found=false
  
         for ((i=0; i<numColumns; i++));
          do  
               column_name=$(echo "${column_arr[i]}" | awk -F '(' '{print $1}') 
               column_type=$(echo "${column_arr[i]}" | awk -F '(' '{print tolower($2)}' | tr -d ')')
               if [[ "$column_name" == "$pk_column" ]]; then
                   pk_column_found=true
                   
                   read -p "Enter Value for ${column_arr[i]}: " value
                   echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                       if ! [[ "$value" =~ ^[0-9]+$ ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Invalid input. Please enter a valid integer.${RESET}"
                            echo "<<----------------->>"
                            return 1
            
                       fi
                       if [ -z "$value" ]; then
                           echo "<<----------------->>"
                           echo -e "${RED}Error: Value for primary key '$pk_column' cannot be empty.${RESET}"
                           echo "<<----------------->>"
                           return 1
                       fi
 
     if awk -F '[= ]' -v pos="$pk_column_position" -v val="$value" '$(pos*2) == val' "raw_data_${tableName_lower}.text" | grep -q .; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Duplicate value found for primary key '$pk_column'.${RESET}"
        echo "<<----------------->>"
        return 1
    fi              
                   values+=("${column_arr[i]}=$value")
                 
               else
                case $column_type in 
                   text)    
                      read -p "Enter Value for ${column_arr[i]}: " value
                      echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                               if [ -z "$value" ]; then
                                     value="null"
                               fi
                     ;;
                    int) 
                      read -p "Enter Value for ${column_arr[i]}: " value
                       echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                       if ! [[ "$value" =~ ^[0-9]+$ ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Invalid input. Please enter a valid integer.${RESET}"
                            echo "<<----------------->>"
                            return 1
                       fi
                     ;;
                    *)
                      echo "<<----------------->>"
                      echo -e "${RED}Error: Invalid column type.${RESET}"
                      echo "<<----------------->>"
                      return 1
                     ;;
               esac 
                     values+=("${column_arr[i]}=$value")
                
               
                     
               fi  
          done
               if ! $pk_column_found; then
                   if [ "$pk_column" == "my_pk" ]; then
                        #echo "inside my_pk"
                        latest_pk_value=$(awk -F '=' '{print $NF}' "raw_data_${tableName_lower}.text" | sort -n | tail -n 1)
                         if [ -z "$latest_pk_value" ]; then
                              pk_value=1
                         else
                              pk_value=$((latest_pk_value + 1))
                         fi
                         values+=("my_pk(int)=$pk_value")
                  else
                    echo "<<----------------->>"
                    echo -e "${RED}Error: PK column not fount.${RESET}"
                    echo "<<----------------->>"
                    return 1
                  fi
               fi
  columns_values=$(IFS=' '; echo "${values[*]}")
  echo -e "${CYAN}INSERT INTO ${table_file} VALUES ( $columns_values )${RESET}"

  echo "$columns_values" >> "raw_data_${table_file}"
  echo -e "${GREEN}<<<< Record inserted successfully.>>>>${RESET}"
}

#---------->>Drop TABLE<<-----------#
drop_table() {
    read -p "Enter the Name of the Table You Want to Drop: " table_name
    table_name_lower=$(echo "$table_name" | tr '[:upper:]' '[:lower:]')
    table_file="$table_name_lower.text"
    raw_file="raw_data_${table_name_lower}.text"

    if [ ! -f "$table_file" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Table '$table_name' does not exist.${RESET}"
        echo "<<----------------->>"
        return
    fi

    read -p "Are you sure you want to drop the table '$table_name'? (y/n): " answer
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

    if [ "$answer" = Y ] || [ "$answer" = y ]; then
        rm "$table_file" "$raw_file"
        echo -e "${GREEN}<<<< Table '$table_name' dropped successfully. >>>>${RESET}"
    elif [ "$answer" = N ] || [ "$answer" = n ]; then
        echo "Table '$table_name' not dropped."
    else
        echo "<<----------------->>"
        echo -e "${RED}Error: Invalid choice. Please enter 'y' or 'n'.${RESET}"
        echo "<<----------------->>"
        return
    fi
}

#---------->>DELETE FROM TABLE<<-----------#
delete_from_table() {
    read -p "Enter the Name of the Table: " tableName
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

    ## Validation ##
    if [ -z "$tableName" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Name of Table cannot be empty.${RESET}"
        echo "<<----------------->>"
        return
    fi

    invalid_char1=$(echo "$tableName" | grep -o '[^a-zA-Z0-9_]')
    if [ -n "$invalid_char1" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Invalid characters found in Table name: $invalid_char1${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    if [[ $tableName =~ ^[0-9] ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: The first character cannot be a number.${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    # Convert table name to lower case for consistent file naming
    tableName_lower=$(echo "$tableName" | tr '[:upper:]' '[:lower:]')
    metadata_file="${tableName_lower}.text"

    if [ ! -f "$metadata_file" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Table '$tableName' does not exist.${RESET}"
        echo "<<----------------->>"
        return
    fi

    start_line=4
    columns_line=$(sed -n "${start_line}p" "$metadata_file")
    columns=$(echo "$columns_line" | awk '{for (i=1; i<=NF; i++) if ($i != "pk:") { gsub(/\([^()]*\)/,"",$i); printf "%s ", $i } }')
    columns_array=($columns)

    # Display column names
    echo "<<----------------->>"
    echo -e "${GREEN}Column Names: ${columns_array[@]}${RESET}"
    echo "<<----------------->>"

    # Ask the user for the column to delete from
    read -p "Enter the name of the column to delete from: " columnToDelete
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

    # Check if the input is empty
    if [ -z "$columnToDelete" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Name of column cannot be empty.${RESET}"
        echo "<<----------------->>"
        return
    fi


    # Ensure the column name does not start with a number
    if [[ $columnToDelete =~ ^[0-9] ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: The first character cannot be a number.${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    # Ensure the column name is not entirely numeric
    if [[ $columnToDelete =~ ^[0-9]+$ ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Column name cannot be entirely numeric.${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    # Check if the column name is valid (only letters and underscores)
    if ! [[ "$columnToDelete" =~ ^[a-zA-Z_]+$ ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Invalid column name. Only letters and underscores are allowed.${RESET}"
        echo "<<----------------->>"
        return
    fi

    # Check if the column exists in the table
    if [[ ! " ${columns_array[@]} " =~ " ${columnToDelete} " ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Column '$columnToDelete' does not exist in the table.${RESET}"
        echo "<<----------------->>"
        return
    fi

    echo -e "${BLUE}Choose The Value To Delete Please :${RESET}"
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
    cat "raw_data_${metadata_file}"
    echo "<<------------------->>"

    read -p "Enter the value of the column to delete: " valueToDelete
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

    # Validation
    if [ -z "$valueToDelete" ]; then
        echo -e "${RED}Error: Value to delete cannot be empty.${RESET}"
        return
    fi

    # Check for invalid characters
    invalid_char=$(echo "$valueToDelete" | grep -o '[^a-zA-Z0-9_]')
    if [ -n "$invalid_char" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Invalid characters found in value to delete: $invalid_char${RESET}"
        echo "<<----------------->>"
        return 1
    fi

#Define the data file
data_file="raw_data_${metadata_file}"

echo -e "${GREEN}Deleting row with value '$valueToDelete' from column '$columnToDelete' in table '$tableName'.${RESET}"

# Check if the specified column exists in the data file
if grep -q "$columnToDelete([^)]*)" "$data_file"; then
    # Constructing the pattern to match both text and int values
    pattern="$columnToDelete(\(text\|int\))=$valueToDelete"
    if grep -q "$pattern" "$data_file"; then
        # Using sed to delete the matching line
        sed -i "/$pattern/d" "$data_file"
        echo -e "${GREEN}Row with value '$valueToDelete' deleted from column '$columnToDelete' in table '$tableName'.${RESET}"
    else
        echo -e "${RED}Error: Value '$valueToDelete' does not exist in column '$columnToDelete'.${RESET}"
    fi
else
    echo -e "${RED}Error: Column '$columnToDelete' does not exist in the data file.${RESET}"
fi

}

#---------->>SELECT FROM TABLE<<-----------#
select_from_table() {
    read -p "Enter the Name of the Table: " tableName
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

    ## Validation ##
    if [ -z "$tableName" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Name of Table cannot be empty.${RESET}"
        echo "<<----------------->>"
        return
    fi

    invalid_char1=$(echo "$tableName" | grep -o '[^a-zA-Z0-9_]')
    if [ -n "$invalid_char1" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Invalid characters found in Table name: $invalid_char1${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    if [[ $tableName =~ ^[0-9] ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: The first character cannot be a number.${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    # Convert table name to lower case for consistent file naming
    tableName_lower=$(echo "$tableName" | tr '[:upper:]' '[:lower:]')
    metadata_file="${tableName_lower}.text"

    if [ ! -f "$metadata_file" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Table '$tableName' does not exist.${RESET}"
        echo "<<----------------->>"
        return
    fi

    start_line=4
    columns_line=$(sed -n "${start_line}p" "$metadata_file")
    columns=$(echo "$columns_line" | awk '{for (i=1; i<=NF; i++) if ($i != "pk:") { gsub(/\([^()]*\)/,"",$i); printf "%s ", $i } }')
    columns_array=($columns)

    # Display column names
    echo -e "${BLUE}Column Names: ${columns_array[@]}${RESET}"

    # Ask the user if they want to select from all columns or a specific column
    while true; do
        read -p "Do you want to select from all columns? (yes/no): " selectAll
        case $selectAll in
            [Yy][Ee][Ss])
                if [ -s "raw_data_${metadata_file}" ]; then
                    # File has content
                    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                    awk '{for (i=1; i<=NF; i++) gsub(/\(text\)|\(int\)/, "", $i)}1' "raw_data_${metadata_file}"
                    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                else
                    # File is empty, print the header
                    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                    sed -n '2p;4p' "${metadata_file}"
                    echo "<<--------------------------------------------------------->>"
                    echo -e "${RED}<<----- The Table Is Empty. Not Data Yet !! ------>>${RESET}"
                    echo "<<----- ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* ------>>"
                fi
                break;;
            [Nn][Oo])
                # Menu for selection options
                echo "Please select an option:"
                echo "1) Select from a single column"
                echo "2) Select from multiple columns"
                echo "3) Select from a single row"
                echo "4) Exit"
                read -p "Enter your choice (1/2/3/4): " selectionOption

                case $selectionOption in
                    1)
                        # Code for selecting from a single column
                        read -p "Enter the name of the column to select from: " columnToSelect
                        echo -e "${GREEN}Selected Column: $columnToSelect${RESET}"

                        ## Validations ##
                        # Check if the input is empty
                        if [ -z "$columnToSelect" ]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Name of column cannot be empty.${RESET}"
                            echo "<<----------------->>"
                            return
                        fi

                        # Check for invalid characters
                        invalid_char=$(echo "$columnToSelect" | grep -o '[^a-zA-Z0-9_]')
                        if [ -n "$invalid_char" ]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Invalid characters found in column name: $invalid_char${RESET}"
                            echo "<<----------------->>"
                            return 1
                        fi

                        # Ensure the column name does not start with a number
                        if [[ $columnToSelect =~ ^[0-9] ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: The first character cannot be a number.${RESET}"
                            echo "<<----------------->>"
                            return 1
                        fi

                        # Ensure the column name is not entirely numeric
                        if [[ $columnToSelect =~ ^[0-9]+$ ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Column name cannot be entirely numeric.${RESET}"
                            echo "<<----------------->>"
                            return 1
                        fi

                        # Check if the column name is valid (only letters and underscores)
                        if ! [[ "$columnToSelect" =~ ^[a-zA-Z_]+$ ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Invalid column name. Only letters and underscores are allowed.${RESET}"
                            echo "<<----------------->>"
                            return
                        fi

                        # Check if the column exists in the table
                        if [[ ! " ${columns_array[@]} " =~ " ${columnToSelect} " ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Column '$columnToSelect' does not exist in the table.${RESET}"
                            echo "<<----------------->>"
                            return
                        fi

                        if [[ " ${columns_array[@]} " =~ " ${columnToSelect} " ]]; then
                            # Extract and display the data for the selected column
                            echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                            awk -F' ' -v col="$columnToSelect" '{for(i=1;i<=NF;i++) {if($i ~ col) {gsub(/\(text\)|\(int\)/, "", $i); print $i}}}' "raw_data_${metadata_file}"
                            echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                        fi
                        break
                        ;;
                    2)
                        while true; do
                            # Prompt the user to enter column names separated by space
                            read -p "Enter the names of the columns to select from (separated by space): " columnsToSelect
                            if [ -z "$columnsToSelect" ]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Name of columns cannot be empty.${RESET}"
                            echo "<<----------------->>"
                            return
                            fi

                            echo -e "${GREEN}Selected Columns: $columnsToSelect${RESET}"

                            # Initialize the validity flag
                            isValid=true

                            # Check if the input column names are valid
                            for col in $columnsToSelect; do
                                # Check if the column name is entirely numeric
                                if [[ $col =~ ^[0-9]+$ ]]; then
                                    echo "<<----------------->>"
                                    echo -e "${RED}Error: Column name cannot be entirely numeric.${RESET}"
                                    echo "<<----------------->>"
                                    isValid=false
                                    break
                                fi

                                # Check for invalid characters in the column name
                                if [[ $col =~ [^a-zA-Z0-9_] ]]; then
                                    echo "<<----------------->>"
                                    echo -e "${RED}Error: Invalid characters found in column name: $col${RESET}"
                                    echo "<<----------------->>"
                                    isValid=false
                                    break
                                fi
                            done

                            # Check if the columns entered by the user exist in the table
                            for col in $columnsToSelect; do
                                if [[ ! " ${columns_array[@]} " =~ " ${col} " ]]; then
                                    echo "<<----------------->>"
                                    echo -e "${RED}Error: Column '$col' does not exist in the table.${RESET}"
                                    echo "<<----------------->>"
                                    isValid=false
                                    break
                                fi
                            done

                            # If all column names are valid, break the loop
                            if [[ $isValid == true ]]; then
                                # Construct the awk command to print the selected columns
                                awkCommand='{'
                                for col in $columnsToSelect; do
                                    for i in "${!columns_array[@]}"; do
                                        if [[ "${columns_array[$i]}" == "$col" ]]; then
                                            awkCommand="$awkCommand printf \"%s \", \$(($i + 1));"
                                        fi
                                    done
                                done
                                awkCommand="$awkCommand print \"\";}"

                                # Check if the data file is not empty
                                if [ -s "raw_data_${metadata_file}" ]; then
                                    # File has content, extract and display the data for the selected columns
                                    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                                    awk "$awkCommand" "raw_data_${metadata_file}"
                                    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                                else
                                    # File is empty, print the header
                                    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                                    sed -n '2p;4p' "${metadata_file}"
                                    echo "<<-------------------------------------------------------->>"
                                    echo -e "${RED}<<----- The Table Is Empty. No Data Yet !! ------>>${RESET}"
                                    echo "<<----- ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* ------>>"
                                fi
                                break
                            fi
                        done
                        break
                        ;;
                    3)
                        # Code for selecting from a single row
                        read -p "Enter the row number to select: " rowNumber

                        # Validation: Check if the input is a valid positive integer
                        if ! [[ $rowNumber =~ ^[1-9][0-9]*$ ]]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Please enter a positive number only.${RESET}"
                            echo "<<----------------->>"
                            return
                        fi

                        # Get the selected row using sed
                        selectedRow=$(sed -n "${rowNumber}p" "raw_data_${metadata_file}")

                        # Check if the selected row is empty
                        if [ -z "$selectedRow" ]; then
                            echo "<<----------------->>"
                            echo -e "${RED}Error: Row $rowNumber does not exist in the table.${RESET}"
                            echo "<<----------------->>"
                            return
                        fi

                        # Print the selected row
                        echo -e "${GREEN}Selected row $rowNumber:${RESET}"
                        echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                        echo -e "${GREEN}$selectedRow${RESET}"
                        echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
                        break
                        ;;
                    4)
                        # Exit option
                        echo -e "${GREEN}Exiting the selection menu.${RESET}"
                        break
                        ;;
                    *)
                        echo -e "${RED}Error: Invalid selection. Please enter a valid option.${RESET}"
                        ;;
                esac
                ;;
            *)
                echo -e "${RED}Error: Invalid input. Please enter 'yes' or 'no'.${RESET}"
                ;;
        esac
    done
}

#---------->>Update Raw IN TABLE<<-----------#
update_raw() {
    read -p "Enter the Name of the Table: " tableName
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

    ## Validation ##
    if [ -z "$tableName" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Name of Table cannot be empty.${RESET}"
        echo "<<----------------->>"
        return
    fi

    invalid_char1=$(echo "$tableName" | grep -o '[^a-zA-Z0-9_]')
    if [ -n "$invalid_char1" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Invalid characters found in Table name: $invalid_char1${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    if [[ $tableName =~ ^[0-9] ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: The first character cannot be a number.${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    # Convert table name to lower case for consistent file naming
    tableName_lower=$(echo "$tableName" | tr '[:upper:]' '[:lower:]')
    metadata_file="${tableName_lower}.text"

    if [ ! -f "$metadata_file" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Table '$tableName' does not exist.${RESET}"
        echo "<<----------------->>"
        return
    fi

    start_line=4
    columns_line=$(sed -n "${start_line}p" "$metadata_file")
    columns=$(echo "$columns_line" | awk '{for (i=1; i<=NF; i++) if ($i != "pk:") { gsub(/\([^()]*\)/,"",$i); printf "%s ", $i } }')
    columns_array=($columns)

    # Display column names
    echo -e "${GREEN}Column Names: ${columns_array[@]}${RESET}"
    echo "<<----------------->>"

    echo -e "${BLUE}Choose The Columns To Update :${RESET}"
    echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"
    cat "raw_data_${metadata_file}"

    # Ask the user for the column to update
    read -p "Enter the name of the column to update: " columName

 columnToUpdate=$(echo "$columName" | tr '[:upper:]' '[:lower:]')

    ## Validations ##
    # Check if the input is empty
    if [ -z "$columnToUpdate" ]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Name of column cannot be empty.${RESET}"
        echo "<<----------------->>"
        return
    fi


    # Ensure the column name does not start with a number
    if [[ $columnToUpdate =~ ^[0-9] ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: The first character cannot be a number.${RESET}"
        echo "<<----------------->>"
        return 1
    fi

    # Ensure the column name is not entirely numeric
    if [[ $columnToUpdate =~ ^[0-9]+$ ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Column name cannot be entirely numeric.${RESET}"
        echo "<<----------------->>"
        return 1
    fi


    # Check if the column exists in the table
    if [[ ! " ${columns_array[@]} " =~ " ${columnToUpdate} " ]]; then
        echo "<<----------------->>"
        echo -e "${RED}Error: Column '$columnToUpdate' does not exist in the table.${RESET}"
        echo "<<----------------->>"
        return
    fi

    # Check if input is in columns_array
    found=0
    for column in ${columns_array[@]}; do
        if [ "$column" == "$columnToUpdate" ]; then
            found=1
            break
        fi
    done

    if [ $found -eq 1 ]; then
          if [ "$columnToUpdate" == "my_pk" ]; then 
		  echo -e "${RED}The default Pk can't be update :)${RESET}"
	  else	  
         		  
        echo "<<----------------->>"
        echo -e "${BLUE}$columnToUpdate exists in the column list.${RESET}"
        echo "<<----------------->>"
        read -p "Enter the old value to update: " oldValue

        # Validation
        if [ -z "$oldValue" ]; then
            echo "<<----------------->>"
            echo -e "${RED}Error: Old value cannot be empty.${RESET}"
            echo "<<----------------->>"
            return
        fi

        # Check for invalid characters
        invalid_char=$(echo "$oldValue" | grep -o '[^a-zA-Z0-9_]')
        if [ -n "$invalid_char" ]; then
            echo "<<----------------->>"
            echo -e "${RED}Error: Invalid characters found in value to delete: $invalid_char${RESET}"
            echo "<<----------------->>"
            return 1
	fi
        
          
        # Check the data type of the column
        column_type=$(awk -v col="$columnToUpdate" 'NR==4{match($0, col "\\(([^)]+)\\)"); if(RSTART){print substr($0, RSTART+length(col)+1, RLENGTH-length(col)-2); exit}}' "$metadata_file")
        echo -e "${BLUE}Column type for '$columnToUpdate': $column_type${RESET}"

        # Prompt for the new value based on the data type
        case $column_type in 
            text)    
                read -p "Enter new Value for $columnToUpdate: " newValue
                echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                # Check if the new value is empty
                if [ -z "$newValue" ]; then
                    echo "<<----------------->>"
                    echo -e "${RED}Error: New Value cannot be empty.${RESET}"
                    echo "<<----------------->>"
                    return 1
                fi

                # Validate that the input is text
                if ! [[ "$newValue" =~ ^[a-zA-Z_]+$ ]]; then
                    echo "<<----------------->>"
                    echo "${RED}Error: Invalid input. Only letters and underscores are allowed.${RESET}"
                    echo "<<----------------->>"
                    return 1
                fi
                ;;
            int) 
                read -p "Enter New Value for $columnToUpdate: " newValue
                echo "~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*"

                # Check if the new value is empty
                if [ -z "$newValue" ]; then
                    echo "<<----------------->>"
                    echo -e "${RED}Error: New value cannot be empty.${RESET}"
                    echo "<<----------------->>"
                    return 1
                fi

                # Validate that the input is an integer
                if ! [[ "$newValue" =~ ^[0-9]+$ ]]; then
                    echo "<<----------------->>"
                    echo -e "${RED}Error: Invalid input. Please Enter a Valid Integer.${RESET}"
                    echo "<<----------------->>"
                    return 1
                fi
                ;;
            *)
                echo "<<----------------->>"
                echo -e "${RED}Error: Invalid column type.${RESET}"
                echo "<<----------------->>"
                return 1
                ;;
        esac

        # Define the data file
        data_file="raw_data_${metadata_file}"

        # Check if the old value exists in the column for the specified data type
        if grep -q "${columnToUpdate}(${column_type})=${oldValue}" "$data_file"; then
            # Check if the new value is the same as any existing primary key value
            if [ "${column_type}" = "int" ] && grep -q "${columns_array[0]}(int)=${newValue}" "$data_file"; then
                echo -e "${RED}Error: New value cannot be the same as any existing primary key value.${RESET}"
                return 1
            fi

            # Create a backup of the data file
            cp "$data_file" "${data_file}.bak"
            
            # Update the specific value from the specified column
            sed -i "s/${columnToUpdate}(${column_type})=${oldValue}/${columnToUpdate}(${column_type})=${newValue}/g" "$data_file"
            
            # Check if the update was successful
            if grep -q "${columnToUpdate}(${column_type})=${newValue}" "$data_file" && ! grep -q "${columnToUpdate}(${column_type})=${oldValue}" "$data_file"; then
                echo "Value '${oldValue}' updated to '${newValue}' in column '${columnToUpdate}' in table '${tableName}'."
                # Display the updated data file
                cat "$data_file"
            else
                echo -e "${RED}Error: Update failed! Rolling back changes.${RESET}"
                # Restore the backup file
                mv "${data_file}.bak" "$data_file"
            fi
        else
            echo -e "${RED}Error: Old value '${oldValue}' not found in column '${columnToUpdate}' of table '${tableName}'.${RESET}"
        fi
    fi
    fi
}
#---------->>Exit from A DATABASE<<-----------#
exit_from_database(){
if [ "$(pwd)" != "$main_dir" ]; then
    cd ../..
#echo "Current directory after exiting: $(pwd)"
    echo -e "${GREEN}<<<<Exited database successfully.>>>>${RESET}"
  else
    echo -e "${RED}You are not inside a database.${RESET}"
  fi 
}

main_menu;  
