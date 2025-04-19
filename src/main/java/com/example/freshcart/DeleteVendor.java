package com.example.freshcart;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DeleteVendor extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String employeeId = request.getParameter("vendor_id");
        String adminPassword = request.getParameter("adminPassword");

        if (employeeId == null || employeeId.isEmpty()) {
            request.setAttribute("error", "Vendor ID is missing.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement checkAdminStmt = null;
        PreparedStatement deleteVendorStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Step 1: Verify admin password (assuming admin is logged in and you can get employee_id from session)
            HttpSession session = request.getSession(false);
            String username = (String) session.getAttribute("username");

            if (username == null) {
                request.setAttribute("error", "Unauthorized access.");
                request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
                return;
            }

            String checkAdminSQL = "SELECT * FROM admin WHERE username = ? AND password = ?";
            checkAdminStmt = conn.prepareStatement(checkAdminSQL);
            checkAdminStmt.setString(1, username);
            checkAdminStmt.setString(2, adminPassword);
            rs = checkAdminStmt.executeQuery();

            if (!rs.next()) {
                request.setAttribute("error", "Invalid admin password.");
                request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
                return;
            }

            rs.close();
            checkAdminStmt.close();

            // Step 2: Delete vendor by employee_id
            String deleteSQL = "DELETE FROM vendors WHERE employee_id = ?";
            deleteVendorStmt = conn.prepareStatement(deleteSQL);
            deleteVendorStmt.setString(1, employeeId);

            int deletedRows = deleteVendorStmt.executeUpdate();

            if (deletedRows > 0) {
                response.sendRedirect("adminDashboard.jsp?success=Vendor deleted successfully.");
            } else {
                request.setAttribute("error", "Vendor not found or deletion failed.");
                request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            }


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkAdminStmt != null) checkAdminStmt.close(); } catch (Exception e) {}
            try { if (deleteVendorStmt != null) deleteVendorStmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
