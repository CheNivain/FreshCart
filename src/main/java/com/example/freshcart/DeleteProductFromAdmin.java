package com.example.freshcart;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteProductFromAdmin extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("product_id");
        String enteredPassword = request.getParameter("password");

        // Check if product ID or password is missing
        if (productId == null || productId.trim().isEmpty() ||
                enteredPassword == null || enteredPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Product ID or password is missing.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }


        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("loginOptions.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Step 1: Verify admin password
            String checkUserSQL = "SELECT password FROM admin WHERE username = ?";
            stmt = conn.prepareStatement(checkUserSQL);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String actualPassword = rs.getString("password");
                if (!actualPassword.equals(enteredPassword)) {
                    request.setAttribute("errorMessage", "Incorrect password. Product not deleted.");
                    request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
                    return;
                }
            } else {
                response.getWriter().println("admin not found.");
                return;
            }
            rs.close();
            stmt.close();

            // Step 2: Delete product
            String deleteSQL = "DELETE FROM products WHERE product_id = ?";
            stmt = conn.prepareStatement(deleteSQL);
            stmt.setString(1, productId);

            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.sendRedirect("adminDashboard.jsp");
            } else {
                response.getWriter().println("Product not found or could not be deleted.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error occurred.");
        } finally {
            try {
                if (rs != null) rs.close();
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
