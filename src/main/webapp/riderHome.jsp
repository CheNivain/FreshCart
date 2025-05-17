<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        // Redirect to login page if no username in session
        response.sendRedirect("login.jsp");
        return;
    }

    String firstname = "Rider"; // Default to "Rider"

    // Fetch rider's first name
    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL JDBC Driver
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart?useSSL=false&serverTimezone=UTC", "root", "root");

        PreparedStatement ps = conn.prepareStatement("SELECT first_name FROM delivery_persons WHERE username = ?");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            firstname = rs.getString("first_name");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Fetch pending deliveries for the rider
    List<String> pendingDeliveries = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart?useSSL=false&serverTimezone=UTC", "root", "root");

        PreparedStatement ps = conn.prepareStatement("SELECT order_id, customer_name, delivery_address FROM deliveries WHERE rider_username = ? AND status = 'Pending'");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            String orderId = rs.getString("order_id");
            String customerName = rs.getString("customer_name");
            String deliveryAddress = rs.getString("delivery_address");
            pendingDeliveries.add("Order ID: " + orderId + " - " + customerName + " (" + deliveryAddress + ")");
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Rider Home | FreshCart</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- Navigation -->
<header>
    <div class="container nav-container">
        <div class="logo">Fresh<span>Cart</span></div>
        <nav>
            <ul class="nav-links">
                <li><a href="logout.jsp">Logout</a></li>
                <li><a href="pendingDeliveries.jsp">Pending Deliveries</a></li>
                <li><a href="completedDeliveries.jsp">Completed Deliveries</a></li>
                <li><a href="contact.jsp">Contact</a></li>
                <li><a href="riderProfile.jsp" class="editbtn">Profile</a></li>
            </ul>
        </nav>
    </div>
</header>

<!-- Hero Section -->
<section class="hero"></section>

<div class="container hero-content">
    <br>
    <h1>Hello, <%= firstname %> 👋</h1>
    <p>Welcome back! Here are your pending deliveries. Deliver the orders and help customers get their groceries fresh
        and fast.</p>

    <!-- Pending Deliveries List -->
    <div class="pending-deliveries">
        <h2>Pending Deliveries</h2>
        <% if (pendingDeliveries.isEmpty()) { %>
        <p>No pending deliveries at the moment. Check back soon!</p>
        <% } else { %>
        <ul>
            <% for (String delivery : pendingDeliveries) { %>
            <li><%= delivery %>
            </li>
            <% } %>
        </ul>
        <% } %>
    </div>
</div>

<!-- Features Section -->
<section class="features">
    <div class="container feature-grid">
        <div class="feature-card"><a href="deliveries.jsp">
            <img src="./Images/Pending-Deliveries.png" alt='PendingDeliveries' class="feature-image">
            <br><br>
            <h3>Pending Deliveries</h3>
            <p>See all deliveries you need to complete.</p></a>
        </div>
        <div class="feature-card"><a href="completedDeliveries.jsp">
            <img src="./Images/Completed-Deliveries.png" alt='CompletedDeliveries' class="feature-image">
            <br><br>
            <h3>Completed Deliveries</h3>
            <p>View the deliveries you've completed.</p></a>
        </div>
    </div>
</section>

<!-- Footer -->
<div class="container-footer">
    <div class="footer-section">
        <div class="logo">Fresh<span>Cart</span></div>
        <br>
        <p class="footer-description">
            At FreshCart, we rely on delivery partners like you to ensure that our customers get their groceries quickly
            and efficiently. Together, we make it happen!
        </p>
    </div>

    <div class="footer-section">
        <div class="In-touch">Let's stay in touch...</div>
        <br>
        <p>Email: ridersupport@freshcart.com</p>
        <div class="social-icons">
            <a href="#" target="_blank"><i class='bx bxl-instagram'></i></a>
            <a href="#" target="_blank"><i class='bx bxl-tiktok'></i></a>
            <a href="#" target="_blank"><i class='bx bxl-facebook'></i></a>
            <a href="#" target="_blank"><i class='bx bxl-linkedin'></i></a>
        </div>
    </div>

    <div class="footer-section">
        <h3 style="font-size:23px;">Find us at...</h3>
        <br>
        <div class="map">
            <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3372.410995192605!2d-73.98811752376795!3d40.757978734799195!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25855c6480299%3A0x55194ec5a1ae072e!2sTimes%20Square!5e1!3m2!1sen!2sin!4v1735117875850!5m2!1sen!2sin"
                    width="502" height="350" style="border:0;" allowfullscreen="" loading="lazy"
                    referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </div>
</div>

<footer>
    <div class="container footer-container">
        <p>&copy; 2025 FreshCart. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
