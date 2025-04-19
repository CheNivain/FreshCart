package com.example.freshcart;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class EditVendor extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String employeeId = request.getParameter("EmployeeID");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Dynamically build SQL based on what was entered
            StringBuilder sql = new StringBuilder("UPDATE vendors SET ");
            boolean hasUsername = username != null && !username.trim().isEmpty();
            boolean hasPassword = password != null && !password.trim().isEmpty();
            int paramIndex = 1;

            if (!hasUsername && !hasPassword) {
                response.getWriter().println("No fields to update.");
                return;
            }

            if (hasUsername) sql.append("username = ?");
            if (hasPassword) {
                if (hasUsername) sql.append(", ");
                sql.append("password = ?");
            }

            sql.append(" WHERE employee_id = ?");
            stmt = conn.prepareStatement(sql.toString());

            // Set values in the correct order
            if (hasUsername) stmt.setString(paramIndex++, username);
            if (hasPassword) stmt.setString(paramIndex++, password);
            stmt.setString(paramIndex, employeeId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                HttpSession session = request.getSession();
                String adminName = (String) session.getAttribute("username");
                if (session.getAttribute("adminName") == null) {
                    session.setAttribute("adminName", adminName);
                }
                response.sendRedirect("adminDashboard.jsp");
            } else {
                response.getWriter().println("Error updating vendor.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error occurred.");
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
