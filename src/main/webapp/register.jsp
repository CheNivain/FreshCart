<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register | Our Grocery</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- === Header === -->
<header>
    <div class="container nav-container">
        <div class="logo">Fresh<span>Cart</span></div>
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="login.jsp">Login</a></li>
        </ul>
    </div>
</header>

<!-- === Main Registration Content === -->
<main class="main-register">
    <div class="login-container">
        <h2 class="login-title">Create Your Account</h2>
        <p class="login-subtitle">Register to start ordering fresh groceries</p>

        <form action="registerUser" method="post" class="login-form">

            <label for="role">I am registering as a: </label>
            <select id="role" name="role" required>
                <option value="Freshcart Customer">Freshcart Customer</option>
                <option value="Freshcart Delivery Person">Freshcart Delivery Person</option>
            </select>

        <label for="firstname">First name</label>
            <input type="text" id="firstname" name="firstname" placeholder="Your first name" required>

            <label for="lastname">Last name</label>
            <input type="text" id="lastname" name="lastname" placeholder="Your last name" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="example@mail.com" required>

            <label for="phone">Phone Number</label>
            <input type="tel" id="phone" name="phone" placeholder="07X-XXXXXXX" required pattern="[0-9]{10}">

            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Choose a username" required>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Create a password" required>

            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>

            <button type="submit" class="btn login-btn">Register</button>
        </form>

        <p class="register-text">Already have an account? <a href="login.jsp">Login here</a></p>
    </div>
</main>

<!-- === Footer === -->
<!-- Footer -->
<div class="container-footer">
    <div class="footer-section">
        <div class="logo">Fresh<span>Cart</span></div>
        <br>
        <p class="footer-description">
            At FreshCart, we believe that access to essential groceries should be simple, efficient, and stress-free. We are here to revolutionize the way you manage your shopping and receive your supplies, offering a personalized platform that connects you with our ushers of freshness.
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
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3372.410995192605!2d-73.98811752376795!3d40.757978734799195!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25855c6480299%3A0x55194ec5a1ae072e!2sTimes%20Square!5e1!3m2!1sen!2sin!4v1735117875850!5m2!1sen!2sin" width="502" height="350" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </div>
</div>

<footer>
    <div class="container">
        &copy; 2025 FreshCart. All rights reserved.
    </div>
</footer>

</body>
</html>
