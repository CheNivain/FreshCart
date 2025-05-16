package com.example.freshcart;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || confirmPassword == null) {
            response.sendRedirect("profile.jsp?delete=error");
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement deleteStmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Step 1: Check if password is correct
            checkStmt = conn.prepareStatement("SELECT * FROM customers WHERE username = ? AND password = ?");
            checkStmt.setString(1, username);
            checkStmt.setString(2, confirmPassword); // Plaintext — hash this in production
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Step 2: Delete the profile
                deleteStmt = conn.prepareStatement("DELETE FROM customers WHERE username = ?");
                deleteStmt.setString(1, username);
                int rows = deleteStmt.executeUpdate();

                if (rows > 0) {
                    session.invalidate(); // Log out the user
                    response.sendRedirect("login.jsp");
                } else {
                    response.sendRedirect("profile.jsp?delete=error");
                }
            } else {
                // Password incorrect
                response.sendRedirect("profile.jsp?delete=wrongpassword");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?delete=error");
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (deleteStmt != null) deleteStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
