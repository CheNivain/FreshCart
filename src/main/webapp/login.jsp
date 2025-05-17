<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | FreshCart</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- Header -->
<header>
    <div class="nav-container container">
        <div class="logo">Fresh<span>Cart</span></div>
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="register.jsp">Register</a></li>
        </ul>
    </div>
</header>

<!-- Main Login Section -->
<main class="main-auth-section">
    <div class="login-container">
        <h2 class="login-title">Welcome Back 👋</h2>
        <p class="login-subtitle">Login to continue shopping</p>

        <form method="post" class="login-form">
            <label for="role">I am a: </label>
            <select id="role" name="role" required>
                <option value="Freshcart Customer"
                        <% if(request.getParameter("role") == null || !request.getParameter("role").equals("Freshcart DeliveryPerson")) { %>selected<% } %>>
                    Freshcart Customer
                </option>
                <option value="Freshcart Delivery Person"
                        <% if(request.getParameter("role") != null && request.getParameter("role").equals("Freshcart DeliveryPerson")) { %>selected<% } %>>
                    Freshcart Delivery Person
                </option>
            </select>

            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter username" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required>

            <br>

            <button type="submit" class="btn login-btn">Login</button>
        </form>

        <p class="register-text">Don't have an account? <a href="register.jsp">Register</a></p>
        <p class="register-text">
            Are you an <strong>Admin</strong>, or <strong>Vendor</strong>?<br>
            <a href="loginOptions.jsp" class="alt-link">View Other Login Options</a>
        </p>

        <%
            String role = request.getParameter("role");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username != null && password != null && role != null) {
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart?useSSL=false&serverTimezone=UTC", "root", "root");

                    String table = "";
                    if ("Freshcart Customer".equals(role)) {
                        table = "customers";
                    } else if ("Freshcart Delivery Person".equals(role)) {
                        table = "delivery_persons";
                    }

                    // Check if username exists
                    String checkUsernameQuery = "SELECT * FROM " + table + " WHERE username = ?";
                    stmt = conn.prepareStatement(checkUsernameQuery);
                    stmt.setString(1, username);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        // Username exists, now check password
                        if (password.equals(rs.getString("password"))) {
                            session.setAttribute("username", username);
                            if ("Freshcart Customer".equals(role)) {
                                response.sendRedirect("customerHome.jsp");
                            } else if ("Freshcart Delivery Person".equals(role)) {
                                response.sendRedirect("riderHome.jsp");
                            }
                        } else {
                            out.println("<br><p class='error' style='color: red'>Incorrect Username or Password.</p>");
                        }
                    } else {
                        out.println("<br><p class='error' style='color: red'>Incorrect Username or Password.</p>");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p class='error'>Something went wrong. Please try again later.</p>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>

    </div>
</main>

<!-- Footer -->
<div class="container-footer">
    <div class="footer-section">
        <div class="logo">Fresh<span>Cart</span></div>
        <br>
        <p class="footer-description">
            At FreshCart, we believe that access to essential groceries should be simple, efficient, and stress-free. We
            are here to revolutionize the way you manage your shopping and receive your supplies, offering a
            personalized platform that connects you with our ushers of freshness.
        </p>
    </div>

    <div class="footer-section">
        <div class="In-touch">Let's stay in touch...</div>
        <br>
        <p>Email: helloyou@freshcart.com</p>
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
    <p>&copy; 2025 FreshCart. All rights reserved.</p>
</footer>

</body>
</html>
