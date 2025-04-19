package com.example.freshcart;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class EditRiderProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Getting form data
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Database connection setup
        Connection conn = null;
        PreparedStatement ps = null;
        String jdbcURL = "jdbc:mysql://localhost:8889/freshcart";
        String dbUsername = "root";
        String dbPassword = "root";

        try {
            // Step 1: Load MySQL JDBC Driver (if not already loaded)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Step 2: Establish a connection to the database
            conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);

            // Step 3: Update the user's information in the database
            String updateSQL = "UPDATE delivery_persons SET first_name = ?, last_name = ?, email = ?, phone_number = ?, password = ? WHERE username = ?";
            ps = conn.prepareStatement(updateSQL);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, password);
            ps.setString(6, username);

            // Execute update
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Successfully updated the profile
                response.sendRedirect("riderProfile.jsp?update=success");
            } else {
                // Failed to update the profile
                response.sendRedirect("riderProfile.jsp?update=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("riderProfile.jsp?update=error");
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
