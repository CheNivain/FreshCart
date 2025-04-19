package com.example.freshcart;

import java.io.*;
import java.nio.file.Paths;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15)   // 15 MB

public class AddProductFromAdmin extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String productName = request.getParameter("product_name");
        String type = request.getParameter("type");
        String stockStr = request.getParameter("available_stock");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");

        if (stockStr == null || stockStr.isEmpty() || priceStr == null || priceStr.isEmpty()) {
            request.setAttribute("error", "Stock and price are required.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }

        int availableStock = Integer.parseInt(stockStr);
        double price = Double.parseDouble(priceStr);


        Part imagePart = request.getPart("image_url");

        if (imagePart == null || imagePart.getSubmittedFileName() == null || imagePart.getSubmittedFileName().isEmpty()) {
            request.setAttribute("error", "Please select an image to upload.");
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            return;
        }

        String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();


        // Upload path inside your project (e.g. webapp/uploads)
        String uploadDirPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        String filePath = uploadDirPath + File.separator + fileName;
        imagePart.write(filePath);

        String imagePath = "uploads/" + fileName;

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            String sql = "INSERT INTO products (product_name, product_type, available_stock, description, price, image_url, created_at, updated_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, productName);
            stmt.setString(2, type);
            stmt.setInt(3, availableStock);
            stmt.setString(4, description);
            stmt.setDouble(5, price);
            stmt.setString(6, imagePath);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("adminDashboard.jsp?success=Product+added+successfully");
            } else {
                request.setAttribute("error", "Failed to add product.");
                request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
