package com.example.freshcart;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class EditProductServlet extends HttpServlet {

    // Process the HTTP POST request to update a product
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("product_id");
        String productName = request.getParameter("product_name");
        String productType = request.getParameter("product_type");
        String availableStockStr = request.getParameter("available_stock");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        Part imagePart = request.getPart("image_url");

        // Validate product_id
        System.out.println("PROBLEM HERE");
        System.out.println(productId);
        System.out.println(productName);
        System.out.println(productType);
        System.out.println(availableStockStr);
        System.out.println(description);
        System.out.println(priceStr);

        if (productId == null || productId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Invalid product_id.");
            request.getRequestDispatcher("vendorDashboard.jsp").forward(request, response);
            return;
        }

        // Default values for availableStock and price
        int availableStock = 0;
        double price = 0.0;
        String imageUrl = null;

        // Validate and parse available_stock
        try {
            if (availableStockStr != null && !availableStockStr.trim().isEmpty()) {
                availableStock = Integer.parseInt(availableStockStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid available stock.");
            request.getRequestDispatcher("vendorDashboard.jsp").forward(request, response);
            return;
        }

        // Validate and parse price
        try {
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = Double.parseDouble(priceStr);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price.");
            request.getRequestDispatcher("vendorDashboard.jsp").forward(request, response);
            return;
        }

        // If image is uploaded, save it to the server
        if (imagePart != null && imagePart.getSize() > 0) {
            String uploadDirPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadDirPath);
            String fileName = imagePart.getSubmittedFileName();
            imageUrl = "uploads/" + fileName;
            File file = new File(uploadDir, fileName);
            imagePart.write(file.getAbsolutePath());
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            // Update query
            String sql;
            if (imageUrl != null) {
                sql = "UPDATE products SET product_name = ?, product_type = ?, available_stock = ?, description = ?, price = ?, image_url = ? WHERE product_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, productName);
                stmt.setString(2, productType);
                stmt.setInt(3, availableStock);
                stmt.setString(4, description);
                stmt.setDouble(5, price);
                stmt.setString(6, imageUrl);
                stmt.setString(7, productId);
            } else {
                sql = "UPDATE products SET product_name = ?, product_type = ?, available_stock = ?, description = ?, price = ? WHERE product_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, productName);
                stmt.setString(2, productType);
                stmt.setInt(3, availableStock);
                stmt.setString(4, description);
                stmt.setDouble(5, price);
                stmt.setString(6, productId);
            }

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("vendorDashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Failed to update product.");
                request.getRequestDispatcher("vendorDashboard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating the product.");
            request.getRequestDispatcher("vendorDashboard.jsp").forward(request, response);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
