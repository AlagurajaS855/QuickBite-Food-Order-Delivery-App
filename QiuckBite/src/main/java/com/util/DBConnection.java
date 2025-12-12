package com.util;

import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/quickbite";
    private static final String USER = "root";  // YOUR MySQL USER
    private static final String PASS = "Mysql@123";      // YOUR MySQL PASSWORD
	private static Connection conn;
    
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
             conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("DB Connection SUCCESS");
            return conn;
        } catch (Exception e) {
            System.out.println("DB Connection FAILED: " + e.getMessage());
        }
        return conn;
    }
}
