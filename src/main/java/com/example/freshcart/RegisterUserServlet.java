package com.example.freshcart;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RegisterUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        System.out.println("Role selected: " + role);  // Debugging line

        String firstName = request.getParameter("firstname");
        String lastName = request.getParameter("lastname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Define SQL for inserting data
            String insertSQL = "";
            if ("Freshcart Delivery Person".equals(role)) {
                System.out.println("Inserting into delivery_persons table...");
                insertSQL = "INSERT INTO delivery_persons (first_name, last_name, email, phone_number, username, password, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, NOW())";
            } else if ("Freshcart Customer".equals(role)) {
                insertSQL = "INSERT INTO customers (first_name, last_name, email, phone_number, username, password, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, NOW())";
            } else {
                request.setAttribute("error", "Invalid role selected.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            stmt = conn.prepareStatement(insertSQL);
            stmt.setString(1, firstName);
            stmt.setString(2, lastName);
            stmt.setString(3, email);
            stmt.setString(4, phone);
            stmt.setString(5, username);
            stmt.setString(6, password); // Consider hashing in production

            int row = stmt.executeUpdate();
            System.out.println("Rows affected: " + row); // Debugging line to check if rows are affected

            if (row > 0) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Registration failed.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            // Close resources
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
