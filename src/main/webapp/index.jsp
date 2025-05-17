<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FreshCart</title>
    <link rel="stylesheet" href="style.css">

</head>
<body>

<!-- Navigation -->
<header>
    <div class="container nav-container">
        <div class="logo">Fresh<span>Cart</span></div>
        <nav>
            <ul class="nav-links">
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp">Register</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
        </nav>
    </div>
</header>

<!-- Hero Section -->
<section class="hero"></section>

<div class="container hero-content">
    <br>
    <h1>Fresh Groceries Delivered to Your Door</h1>
    <p>Shop from your local vendors and get everything delivered fast and fresh.</p>
    <a href="login.jsp" class="btn">Upload Shopping List</a>
</div>

<!-- Features -->
<section class="features">
    <div class="container feature-grid">
        <div class="feature-card"><a href="Products.jsp">
            <img src="./Images/Easy%20Order.png" alt='EasyOrder' class="feature-image">
            <br><br>
            <h3>Wide Range of Products</h3>
            <p>Choose from fresh fruits, vegetables, dairy, and more.</p></a>
        </div>
        <div class="feature-card"><a href="fastDelivery.jsp">
            <img src="./Images/Fast-Delivery.png" alt='FastDelivery' class="feature-image">
            <br><br>
            <h3>Fast Delivery</h3>
            <p>Get your orders delivered within hours by local delivery partners.</p></a>
        </div>
        <div class="feature-card"><a href="securePayments.jsp">
            <img src="./Images/Secure-Payment.png" alt='SecurePayment' class="feature-image">
            <br><br>
            <h3>Secure Payments</h3>
            <p>Pay online or opt for cash/card on delivery with confidence.</p></a>
        </div>
    </div>
</section>

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
    <div class="container footer-container">
        <p>&copy; 2025 FreshCart. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
