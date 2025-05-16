package com.example.freshcart;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Database credentials — UNCOMMENT these and keep them private static final
    private static final String URL = "jdbc:mysql://localhost:8889/FreshCart";
    private static final String USER = "root";
    private static final String PASSWORD = "root"; // default for MAMP is 'root'


    public DBConnection() {
        // empty or can remove this constructor
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found.");
            throw new SQLException("MySQL JDBC Driver not found.", e); // wrap it as SQLException
        }
    }

}
