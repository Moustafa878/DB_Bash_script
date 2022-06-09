#!/bin/bash

# Create database

mysql -uroot -p -e " DROP DATABASE IF EXISTS employees_info;
                                CREATE DATABASE employees_info;" &> /dev/null



# Get first column to create table with primary key  

Fcol=$(awk -F ',' '{ print $1}' employees.csv |head -1)
mysql -uroot -p -e " USE employees_info;
                            CREATE TABLE IF NOT EXISTS  emp_info($Fcol INT, PRIMARY KEY ($Fcol));" &> /dev/null



# This for loop to add the rest of column to table

for i in $(head -1 employees.csv | sed 's/[,]/ /g')
   do
     if [ "$i" == "$Fcol" ]
      then
         continue
      else
           mysql -uroot -p -e "USE employees_info;
                                    ALTER TABLE emp_info 
                                       ADD $i varchar(50) NOT NULL;" &> /dev/null
      fi
   done 



 
# This for loop to insert the data to table

for((i=2;i<=`sed -n '$=' employees.csv`;i++))
do
   mysql -uroot -p -e "USE employees_info;
                                  INSERT INTO emp_info
                                   VALUES($(sed -n "$i p" employees.csv | sed "s/,/','/g" | sed "s/^/'/g")""');" &> /dev/null

    
done


# Display table content from Database
 
mysql -uroot -p -e "USE employees_info;
                                  SELECT * FROM emp_info;" 2> /dev/null




echo " Data are loaded successfully "

