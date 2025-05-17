package com.example.freshcart;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class RegisterAdminServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String employeeId = request.getParameter("EmployeeID");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement checkStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Step 1: Check if employee ID exists in employees table
            String checkEmployeeSQL = "SELECT * FROM employees WHERE employee_id = ?";
            checkStmt = conn.prepareStatement(checkEmployeeSQL);
            checkStmt.setString(1, employeeId);
            rs = checkStmt.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "Employee ID not found.");
                request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
                return;
            }
            rs.close();
            checkStmt.close();

            // Step 2: Check if employee ID already registered as admin
            String checkAdminByEmployeeSQL = "SELECT * FROM admin WHERE employee_id = ?";
            checkStmt = conn.prepareStatement(checkAdminByEmployeeSQL);
            checkStmt.setString(1, employeeId);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "You are already an admin.");
                request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
                return;
            }
            rs.close();
            checkStmt.close();

            // Step 2: Check if employee ID already registered as a vendor
            String checkVendorByEmployeeSQL = "SELECT * FROM vendors WHERE employee_id = ?";
            checkStmt = conn.prepareStatement(checkVendorByEmployeeSQL);
            checkStmt.setString(1, employeeId);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "You are already a vendor.");
                request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
                return;
            }
            rs.close();
            checkStmt.close();

            // Step 3: Check if username is already taken
            String checkUsernameSQL = "SELECT * FROM admin WHERE username = ?";
            checkStmt = conn.prepareStatement(checkUsernameSQL);
            checkStmt.setString(1, username);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Username is already taken.");
                request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
                return;
            }
            rs.close();
            checkStmt.close();

            // Step 4: Insert new admin
            String insertSQL = "INSERT INTO admin (employee_id, username, password) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(insertSQL);
            stmt.setString(1, employeeId);
            stmt.setString(2, username);
            stmt.setString(3, password); // Hash in production

            int row = stmt.executeUpdate();

            if (row > 0) {
                response.sendRedirect("adminRegistrationSuccess.jsp");
            } else {
                request.setAttribute("error", "Registration failed.");
                request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("registerAdmin.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
            }
            try {
                if (checkStmt != null) checkStmt.close();
            } catch (Exception e) {
            }
            try {
                if (stmt != null) stmt.close();
            } catch (Exception e) {
            }
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
            }
        }
    }
}
