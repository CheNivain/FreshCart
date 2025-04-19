package com.example.freshcart;  // Your package name

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Database credentials
    private static final String URL = "jdbc:mysql://localhost:8889/FreshCart";
    private static final String USER = "root";
    private static final String PASSWORD = "root"; // default for MAMP is 'root'

    public static Connection getConnection() throws SQLException {
        // Attempt to connect to the database
        try {
            // Load the MySQL JDBC driver (optional for newer versions)
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            // Handle error if driver is not found
            System.err.println("MySQL JDBC Driver not found.");
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }
    }
}
