package com.example.freshcart;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.nio.file.Files;
import java.sql.*;

public class AuthenticateInternalProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Database connection setup (replace with your DB connection details)
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Query to fetch the first name and last name based on the role
            String query = "SELECT e.first_name, e.last_name FROM employees e ";
            if (role.equals("admin")) {
                query += "JOIN admin a ON e.employee_id = a.employee_id WHERE a.username = ? AND a.password = ?";
                HttpSession session = request.getSession();
                session.setAttribute("username", username);// Store admin's ID
            } else if (role.equals("vendor")) {
                query += "JOIN vendors v ON e.employee_id = v.employee_id WHERE v.username = ? AND v.password = ?";
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
            }

            ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {
                // User found, retrieve their full name
                String fullName = rs.getString("first_name");

                // Set the full name as a request attribute
                if (role.equals("admin")) {
                    HttpSession session = request.getSession();
                    session.setAttribute("adminName", fullName);
                    // Forward to the admin dashboard
                    request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
                } else {
//                    request.setAttribute("vendorName", fullName);
                    HttpSession session = request.getSession();
                    String Name = rs.getString("first_name"); // or first_name + " " + last_name if needed
                    session.setAttribute("vendorName", Name);

                    // Forward to the vendor dashboard
                    request.getRequestDispatcher("vendorDashboard.jsp").forward(request, response);
                }
            } else {
                // Invalid credentials, redirect to login page with an error
                request.setAttribute("error", "Invalid login credentials");
                request.getRequestDispatcher("loginOptions.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("loginOptions.jsp").forward(request, response);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database driver not found");
            request.getRequestDispatcher("loginOptions.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
