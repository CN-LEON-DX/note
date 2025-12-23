# Test db init RDS
root@ip-172-31-78-209:~/vprofile-project# history
    1  apt update && apt install mysql-client git -y
    2  mysql -h project01-rds-rearch.c2pwokiwe4rt.us-east-1.rds.amazonaws.com -u admin -p
    # template
    3  git clone https://github.com/hkhcoder/vprofile-project/tree/main
    4  git clone https://github.com/hkhcoder/vprofile-project.git
    5  cd vprofile-project/
    6  git checkout awsrefactor
    7  ls
    8  lsr src/main/resources/
    9  ls src/main/resources/
   10  mysql -h project01-rds-rearch.c2pwokiwe4rt.us-east-1.rds.amazonaws.com -u admin -p
   11  mysql   -h project01-rds-rearch.c2pwokiwe4rt.us-east-1.rds.amazonaws.com   -u admin   -p   < src/main/resources/db_backup.sql
   12  mysql   -h project01-rds-rearch.c2pwokiwe4rt.us-east-1.rds.amazonaws.com   -u admin   -p  -db accounts  < src/main/resources/db_backup.sql
   13  mysql   -h project01-rds-rearch.c2pwokiwe4rt.us-east-1.rds.amazonaws.com   -u admin   -p   accounts   < src/main/resources/db_backup.sql
   14  history

# after login
mysql> use accounts
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+--------------------+
| Tables_in_accounts |
+--------------------+
| role               |
| user               |
| user_role          |
+--------------------+
3 rows in set (0.00 sec)

mysql>