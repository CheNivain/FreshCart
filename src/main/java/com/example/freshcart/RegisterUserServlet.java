//package com.example.freshcart;
//
//import java.io.IOException;
//import java.sql.*;
//import javax.servlet.*;
//import javax.servlet.http.*;
//
//public class RegisterUserServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String role = request.getParameter("role");
//        System.out.println("Role selected: " + role);  // Debugging line
//
//        String firstName = request.getParameter("firstname");
//        String lastName = request.getParameter("lastname");
//        String email = request.getParameter("email");
//        String phone = request.getParameter("phone");
//        String username = request.getParameter("username");
//        String password = request.getParameter("password");
//        String confirmPassword = request.getParameter("confirmPassword");
//
//        if (!password.equals(confirmPassword)) {
//            request.setAttribute("error", "Passwords do not match.");
//            request.getRequestDispatcher("register.jsp").forward(request, response);
//            return;
//        }
//
//        Connection conn = null;
//        PreparedStatement stmt = null;
//
//        try {
//            // ✅ Use DBConnection utility class here
//            conn = DBConnection.getConnection();
//
//            String insertSQL = "";
//            if ("Freshcart Delivery Person".equals(role)) {
//                System.out.println("Inserting into delivery_persons table...");
//                insertSQL = "INSERT INTO delivery_persons (first_name, last_name, email, phone_number, username, password, created_at) " +
//                        "VALUES (?, ?, ?, ?, ?, ?, NOW())";
//            } else if ("Freshcart Customer".equals(role)) {
//                insertSQL = "INSERT INTO customers (first_name, last_name, email, phone_number, username, password, created_at) " +
//                        "VALUES (?, ?, ?, ?, ?, ?, NOW())";
//            } else {
//                request.setAttribute("error", "Invalid role selected.");
//                request.getRequestDispatcher("register.jsp").forward(request, response);
//                return;
//            }
//
//            stmt = conn.prepareStatement(insertSQL);
//            stmt.setString(1, firstName);
//            stmt.setString(2, lastName);
//            stmt.setString(3, email);
//            stmt.setString(4, phone);
//            stmt.setString(5, username);
//            stmt.setString(6, password); // Reminder: hash this in production
//
//            int row = stmt.executeUpdate();
//            System.out.println("Rows affected: " + row); // Debug line
//
//            if (row > 0) {
//                response.sendRedirect("login.jsp");
//            } else {
//                request.setAttribute("error", "Registration failed.");
//                request.getRequestDispatcher("register.jsp").forward(request, response);
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Database error: " + e.getMessage());
//            request.getRequestDispatcher("register.jsp").forward(request, response);
//        } finally {
//            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
//            try { if (conn != null) conn.close(); } catch (Exception e) {}
//        }
//    }
//}


package com.example.freshcart;

import com.example.freshcart.model.Customer;
import com.example.freshcart.model.DeliveryPerson;
import com.example.freshcart.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class RegisterUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");

        String firstName = request.getParameter("firstname");
        String lastName = request.getParameter("lastname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = null;
        if ("Freshcart Customer".equals(role)) {
            user = new Customer(firstName, lastName, email, phone, username, password);
        } else if ("Freshcart Delivery Person".equals(role)) {
            user = new DeliveryPerson(firstName, lastName, email, phone, username, password);
        } else {
            request.setAttribute("error", "Invalid role selected.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (user.register(conn)) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Registration failed.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

