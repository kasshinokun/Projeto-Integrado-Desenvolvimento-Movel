#------------Teste Java MySQL
/*Java:

import java.util.Arrays;
public class user
{
	String name;
    String password;
    int level;
	public user(String name, String password, int level){
		this.name=name; 
        this.password=password; 
        this.level=level;
    }
}
public int getlevel(String name_level){
	String[] level = {"admin","technical","user"};
	return Arrays.asList(level).indexOf(name_level);
}
public void set_user(String name, String password, String level){
	user=new user(name,password,getlevel(level));
}
*/

#MySQL:
CREATE DATABASE IF NOT EXISTS db_test;
CREATE TABLE IF NOT EXISTS db_test.tbl_LVL(
	ID_LVL INT AUTO_INCREMENT,
    NM_LVL VARCHAR(200), # Helton de Oliveira
    PRIMARY KEY (ID_LVL),
    UNIQUE KEY (NM_LVL)
);
CREATE TABLE IF NOT EXISTS db_test.tbl_USER(
	ID_USER INT AUTO_INCREMENT,
    NM_USER VARCHAR(200),
    PWD_USER VARCHAR(14), 
    LVL_USER INT NOT NULL,
	PRIMARY KEY (ID_USER),
    UNIQUE KEY (PWD_USER),
    FOREIGN KEY (LVL_USER) REFERENCES db_test.tbl_LVL(ID_LVL)
);

INSERT INTO db_test.tbl_LVL(NM_LVL)
VALUES('admin'),('technical'),('user');

DELIMITER $$
CREATE PROCEDURE db_test.SET_USR(
user_name VARCHAR(200), 
pass_word VARCHAR(14),
lvl_usr VARCHAR(200)) 
BEGIN
   DECLARE name_usr  VARCHAR(200);
   DECLARE passwd_usr  VARCHAR(14);
   DECLARE id_lvl_usr  INT;
   SET id_lvl_usr=(SELECT ID_LVL FROM db_test.tbl_LVL
   WHERE NM_LVL=lvl_usr);
   INSERT INTO db_test.tbl_USER(NM_USER,PWD_USER,LVL_USER)
   VALUES(name_usr,passwd_usr,id_lvl_usr);
END$$
DELIMITER ;

CALL db_test.SET_USR('Maria Wood','Sky12345','admin');