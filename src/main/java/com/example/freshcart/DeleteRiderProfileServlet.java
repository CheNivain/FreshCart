//package com.example.freshcart;
//
//import java.io.*;
//import javax.servlet.*;
//import javax.servlet.http.*;
//import java.sql.*;
//
//public class DeleteRiderProfileServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession(false);
//        String username = (String) session.getAttribute("username");
//        String confirmPassword = request.getParameter("confirmPassword");
//
//        if (username == null || confirmPassword == null) {
//            response.sendRedirect("riderProfile.jsp?delete=error");
//            return;
//        }
//
//        try {
//            Class.forName("com.mysql.cj.jdbc.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");
//
//            // Step 1: Check if password is correct
//            PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM delivery_persons WHERE username = ? AND password = ?");
//            checkStmt.setString(1, username);
//            checkStmt.setString(2, confirmPassword); // Plaintext for now — hash this in production
//            ResultSet rs = checkStmt.executeQuery();
//
//            if (rs.next()) {
//                // Step 2: Delete the profile
//                PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM delivery_persons WHERE username = ?");
//                deleteStmt.setString(1, username);
//                int rows = deleteStmt.executeUpdate();
//
//                if (rows > 0) {
//                    session.invalidate(); // Log out the user
//                    response.sendRedirect("login.jsp");
//                } else {
//                    response.sendRedirect("riderProfile.jsp?delete=error");
//                }
//
//                deleteStmt.close();
//            } else {
//                // Password incorrect
//                response.sendRedirect("riderProfile.jsp?delete=wrongpassword");
//            }
//
//            rs.close();
//            checkStmt.close();
//            conn.close();
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("riderProfile.jsp?delete=error");
//        }
//    }
//}


package com.example.freshcart;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteRiderProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = (String) session.getAttribute("username");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || confirmPassword == null) {
            response.sendRedirect("riderProfile.jsp?delete=error");
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement deleteStmt = null;
        ResultSet rs = null;

        try {
            // ✅ Use DBConnection utility class
            conn = DBConnection.getConnection();

            // Step 1: Check if password is correct
            checkStmt = conn.prepareStatement("SELECT * FROM delivery_persons WHERE username = ? AND password = ?");
            checkStmt.setString(1, username);
            checkStmt.setString(2, confirmPassword); // Plaintext — should be hashed in real projects
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Step 2: Delete the profile
                deleteStmt = conn.prepareStatement("DELETE FROM delivery_persons WHERE username = ?");
                deleteStmt.setString(1, username);
                int rows = deleteStmt.executeUpdate();

                if (rows > 0) {
                    session.invalidate(); // Log out the user
                    response.sendRedirect("login.jsp");
                } else {
                    response.sendRedirect("riderProfile.jsp?delete=error");
                }
            } else {
                response.sendRedirect("riderProfile.jsp?delete=wrongpassword");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("riderProfile.jsp?delete=error");
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
