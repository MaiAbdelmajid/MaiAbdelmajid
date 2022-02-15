#!/bin/bash
sep=, #declaring var sep to make tables in csv file
DB=./Database/

function createtable {
 read -p "Enter Table name: " tbname

 if [ -f "DB$tbname.csv" ]
       then
	echo this table already exist
       elif [ -z "$tbname.csv" ]
        then echo table name cannot be null.
       else
        touch $tbname.csv
        read -p " Enter Column number: " colnum

  for (( i=0 ; i<$colnum ;i+=1 ))
      do	
	echo metadata of column $((i+1)) = 
	read value
	metadata[$i]="${value} $sep"
      done

echo table name is $tbname >> $tbname.csv
echo number of columns are $colnum >> $tbname.csv
echo columns names are  ${metadata[*]} >> $tbname.csv
echo ${metadata[*]} >> $tbname.csv
fi
maintable
}

function listtable {
 echo "Enter the Table's name:"
 read listname 2> /dev/null
 if [ -f "$listname.csv" ]
   then
     awk -F, '{print $0}' $listname.csv
 else 
     echo $listname not available
fi
maintable
}
function deletefromtable {
   read -p "Enter table name to delete: " delname
    if [ -f "$delname.csv" ]
      then
     read -p "Enter primary key of the table row: " pk
     row=`awk -F, '{{if(($1=='$pk')){print NR}}}' $delname.csv`
      sed -i ''$row'd' $delname.csv
       echo line $row deleted successfully
       else
       echo $delname not a table 
    fi
maintable
}
function inserttotable {
read -p "Enter table's name: " tb

   if [ -f "$tb.csv" ]
    then
     colno=`awk -F, 'END {print NF}' $tb.csv`
     read -p "Enter number of rows: " rows

     for (( i=0; i<$rows ;i+=1))
        do
	for (( j=0; j<$colno-1 ; j+=1 ))
	do
         if [[ j -eq 0 ]]
           then 
           echo enter primary key in first column
           echo data of column $((j+1)) =
             typeset -i coldt
             typeset -i ch
  	while  [ true ]
	do 
	 read coldt
	 case $coldt in
          *[0-9]*)

	     ch=0
	     ch=`awk -F, '{if ($1=='$coldt'){ print $1 }}' $tb.csv`
	      if test $ch -ne $coldt
	      then data[$j]="${coldt} $sep"
               break
	      else    echo primary key must be unique!
                       
              fi;;

            *) echo not valid primary key enter only numbers;;
           esac
	       
  done
	    
   else
		echo enter data of column $((j+1))
		read dt
		data[$j]="${dt} $sep"
	fi		
          done
echo  ${data[*]} >> $tb.csv
done
if test  $? == 0 
then
	echo data added successfully
else
	echo couldn\'t add this data please try again
fi
else echo $tb not a table 2> /dev/null
fi
maintable
}
function droptable {
#read -p "Enter Database name to drop it: " dbname
read -p "Enter table name to drop it: " dropname
 if [ -f "$dropname.csv" ] 
  then
   rm $dropname.csv
   echo $dropname dropped successfully!
else
	echo $dropname not a table 2> /dev/null
fi
maintable
}
function selectfromtable {
read -p "Enter table name: " selectname
   if [ -f "$selectname.csv" ]
   then
    read -p "Enter pk of the row: " rowpk
   clear
  echo your selection is:
echo *_______________________________________________________________*
awk -F, '{{if(($1=='$rowpk')){print $0 }}}' $selectname.csv
echo *_______________________________________________________________*
else 
	echo $selectname not a table 2> /dev/null
fi
maintable
}

function maintable {
PS3="Enter one choice :"
select choice in "Create table" "List tables" "Drop table" "Insert into table" "Select from table" "Delete from table"
do
   case $REPLY in
     1) createtable;;
     2) listtable;;
     3) droptable;;
     4) inserttotable;;
     5) selectfromtable;;
     6) deletefromtable;;
     *)echo Invalid choice;;
   esac
done
}
function createDB {
 read -p "Enter Database name:" dbname

if [ -d ./Database/$dbname ]
     then
      echo $dbname already exists
   else
      mkdir -p ./Database/$dbname
      echo $dbname Created Successfully!
fi
menu
}


function connectDB {
read -p "Enter Database name: " connectDB_name
  cd ./Database/$connectDB_name

  if [ $? -eq 0 ]
     then
      echo Connected to $connectedDB_name successfully
      maintable
     else
      echo Database $connectedDB_name not found
menu
  fi
}

function dropDB {
read -p "Please Enter the Database name: " dropdb_name
if [ -d Database/$dropdb_name ]
 then
	echo "Are you Sure You Want To drop $dropdb_name Database? y/n"
	read choice;
	case $choice in
		 [Yy]* ) 
			rm -r Database/$dropdb_name
                        echo $dropdb_name successfully deleted
                        ;;
		 [Nn]* ) 
			echo "Operation Canceled"
			;;
		* ) 
			echo "Invalid Input 0 DataBases changed"
			;;
	esac
else
	echo "$dropdb_name doesn't exist"
fi
menu
}

function menu {

echo Hello Dear..&&
echo ------------------------------------------------------
PS3="Choose one of the above: "
select Choose in "Create Database" "List Database" "Connect to Database" "Drop Database"
do 
  case $REPLY in
    1)createDB ;;
    2)ls ./Database;;
    3)connectDB ;;
    4)dropDB ;;
    *)echo $REPLY not available
esac
done }
menu
