<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Wide Range of Products - FreshCart</title>
  <link rel="stylesheet" href="products.css">
  <link rel="stylesheet" href="style.css">
</head>
<body>

<!-- Navigation -->
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

<section class="products-hero">
  <div class="container-widerange">
    <h1>Explore Our Wide Range of Products</h1>
    <p>Fresh. Local. Delivered to your door.</p>
  </div>
</section>

<section class="product-grid container-widerange">
  <div class="product-card">
    <img src="./Images/fruits.png" alt="Fruits">
    <h3>Fresh Fruits</h3>
    <p>Apples, Bananas, Berries, and more!</p>
  </div>
  <div class="product-card">
    <img src="./Images/vegetables.png" alt="Vegetables">
    <h3>Vegetables</h3>
    <p>Carrots, Tomatoes, Spinach, etc.</p>
  </div>
  <div class="product-card">
    <img src="./Images/dairy.png" alt="Dairy">
    <h3>Dairy Products</h3>
    <p>Milk, Cheese, Yogurt & more.</p>
  </div>
  <div class="product-card">
    <img src="./Images/meat.png" alt="Meat">
    <h3>Meat & Poultry</h3>
    <p>Chicken, Beef, Eggs, etc.</p>
  </div>
  <div class="product-card">
    <img src="./Images/snacks.png" alt="Snacks">
    <h3>Snacks & Beverages</h3>
    <p>Juices, Chips, Soft drinks, etc.</p>
  </div>
  <div class="product-card">
    <img src="./Images/bakery.png" alt="Bakery">
    <h3>Bakery Items</h3>
    <p>Bread, Buns, Pastries, and more.</p>
  </div>

  <div class="product-card">
    <img src="./Images/seafood.png" alt="Seafood">
    <h3>Seafood</h3>
    <p>Fish, Shrimp, Crabs, etc.</p>
  </div>

  <div class="product-card">
    <img src="./Images/frozen.png" alt="Frozen Foods">
    <h3>Frozen Foods</h3>
    <p>Pizzas, Nuggets, Ice Cream, etc.</p>
  </div>

</section>

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
  <div class="container footer-container">
    <p>&copy; 2025 FreshCart. All rights reserved.</p>
  </div>
</footer>

</body>
</html>
