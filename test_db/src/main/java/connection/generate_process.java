package connection;

/**
 * @version 1_2025_01_06
 * @author Gabriel da Silva Cassino
 */
 
public class generate_process {
    public class user{
        
        private String name;
        private String password;
        private String level;
    
        public user(String name, String password, String level,int lang)
                throws IllegalArgumentException {
            if(level!="admin"|level!="technical"|level!="user"){
                throw new IllegalArgumentException(functions_op.invalid_argument(lang));
            }else{
                setName(name);
                setPassword(password);
                setLevel(level);
            }
        }
        
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getPassword() {
            return password;
        }
        
        public String getLevel() {
            return level;
        }

        public void setLevel(String level) {
            this.level = level;
        }
    }
    
    //Process CRUD CREATE
    
    //Process CRUD READ
    
    //Process CRUD UPDATE
    
    //Process CRUD DELETE(Test CODE only)
    public void deleteUser(String name, db_connection connection_db) {
        try {
            connection_db.connect();
        
            String sql1 = "SET @name = '" + name + "'";
            String sql2 = "SET @userID = (SELECT id_USR FROM USER WHERE nm_USR = @name)";
            String sql3 = "DELETE FROM tbl_USERS WHERE id = @userID";
        
            ResultSet query1=connection_db.query(sql1);
        
            ResultSet query2=connection_db.query(sql2);
        
            ResultSet query3=connection_db.query(sql3);
        
            connection_db.disconnect();
            System.out.println("The user " + name + " was deleted from the Table USERS.");
        } catch(Exception e){ 
            System.out.println(e);
        
        }
    }
    
}
