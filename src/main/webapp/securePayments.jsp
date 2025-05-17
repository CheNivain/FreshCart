<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Payments - FreshCart</title>
    <link rel="stylesheet" href="securePayments.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
    <div class="container nav-container">
        <div class="logo">Fresh<span>Cart</span></div>
        <nav>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp">Register</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a href="contact.jsp">Contact</a></li>
            </ul>
        </nav>
    </div>
</header>

<section class="payments-hero">
    <div class="container">
        <h1>Secure Payments for Your Peace of Mind</h1>
        <p>We prioritize your security and convenience when it comes to payments.</p>
    </div>
</section>

<section class="payments-content container">
    <div class="payments-image">
        <img src="./Images/Secure-Payment.png" alt="Secure Payment">
    </div>
    <div class="payments-text">
        <h2>Why Choose Our Secure Payment System?</h2>
        <ul>
            <li>🔒 Industry-standard encryption for secure transactions.</li>
            <li>💳 Multiple payment options including credit/debit cards, online wallets, and cash on delivery.</li>
            <li>✅ Instant order confirmation with secure transaction receipts.</li>
            <li>📲 Seamless integration for easy and quick payments.</li>
        </ul>
        <a href="login.jsp" class="btn">Start Shopping</a>
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
