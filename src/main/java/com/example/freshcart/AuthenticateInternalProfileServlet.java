package com.example.freshcart;

import com.example.freshcart.dao.InternalUserDAO;
import com.example.freshcart.model.InternalUser;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthenticateInternalProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        InternalUserDAO userDAO = new InternalUserDAO();
        InternalUser user = null;

        try {
            user = userDAO.authenticate(username, password, role);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", user.getUsername());
                if (user instanceof com.example.freshcart.model.Admin) {
                    session.setAttribute("adminName", user.getFirstName());
                } else if (user instanceof com.example.freshcart.model.Vendor) {
                    session.setAttribute("vendorName", user.getFirstName());
                }

                request.getRequestDispatcher(user.getDashboardPage()).forward(request, response);
            } else {
                request.setAttribute("error", "Invalid login credentials");
                request.getRequestDispatcher("loginOptions.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("loginOptions.jsp").forward(request, response);
        }
    }
}
