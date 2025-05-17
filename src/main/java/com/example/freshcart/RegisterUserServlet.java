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

