<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String firstName = "", lastName = "", email = "", phone = "", password = "";

    if (username != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/freshcart", "root", "root");

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM delivery_persons WHERE username = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                firstName = rs.getString("first_name");
                lastName = rs.getString("last_name");
                email = rs.getString("email");
                phone = rs.getString("phone_number");
                username = rs.getString("username");
                password = rs.getString("password");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Profile | FreshCart</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="profile.css">
</head>
<body>
<!-- Show success or error message -->
<%
    String updateStatus = request.getParameter("update");
    if ("success".equals(updateStatus)) {
%>
<div class="alert success" id="alertMessage">Your profile has been updated successfully!</div>
<%
} else if ("error".equals(updateStatus)) {
%>
<div class="alert error" id="alertMessage">Something went wrong, please try again.</div>
<%
    }
%>

<%
    String deleteStatus = request.getParameter("delete");
    if ("wrongpassword".equals(deleteStatus)) {
%>
<div class="alert error" id="deletealertMessage">Incorrect password. Could not delete profile.</div>
<%
} else if ("error".equals(deleteStatus)) {
%>
<div class="alert error" id="deletealertMessage">An error occurred. Could not delete profile.</div>
<%
    }
%>


<!-- Profile Form or other content goes here -->

<script>
    window.onload = function () {
        var alertMessage = document.getElementById("alertMessage");
        if (alertMessage) {
            setTimeout(function () {
                alertMessage.style.display = "none";
            }, 5000);
        }

        var deletealertMessage = document.getElementById("deletealertMessage");
        if (deletealertMessage) {
            setTimeout(function () {
                deletealertMessage.style.display = "none";
            }, 5000);
        }
    };

</script>

<header>
    <div class="container nav-container">
        <div class="logo">Fresh<span>Cart</span></div>
        <nav>
            <ul class="nav-links">
                <li><a href="logout.jsp">Logout</a></li>
                <li><a href="pendingDeliveries.jsp">Pending Deliveries</a></li>
                <li><a href="completedDeliveries.jsp">Completed Deliveries</a></li>
                <li><a href="contact.jsp">Contact</a></li>
                <li><a href="riderHome.jsp">Home</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="container hero-content">

    <h1>Hi, <%= firstName %> 👋</h1>
    <p>Welcome to your profile.</p>

    <div class="profile-card">
        <h2>Profile Details</h2>
        <div class="profile-info">
            <p><strong>First Name:</strong> <%= firstName %>
            </p>
            <p><strong>Last Name:</strong> <%= lastName %>
            </p>
            <p><strong>Email:</strong> <%= email %>
            </p>
            <p><strong>Phone:</strong> <%= phone %>
            </p>
            <p><strong>Username:</strong> <%= username %>
            </p>
            <p><strong>Password:</strong> *****</p>
        </div>

        <div class="profile-actions">
            <!-- Edit Profile button -->
            <button onclick="openModal()" class="profbtn">Edit Profile</button>

            <!-- Delete Profile form with confirmation -->
            <button class="profbtn danger" onclick="showDeleteConfirmation()">Delete Account</button>

            <!-- Delete Confirmation Form (Initially Hidden) -->
            <div id="deleteConfirmationOverlay">
                <div class="delete-confirmation-modal">
                    <form action="deleteRiderProfile" method="post">
                        <h3 style="font-size: 16px">Are you sure you want to delete your profile?</h3>
                        <input type="password" class="confirm-password-input" id="confirmPassword"
                               name="confirmPassword" placeholder="Enter your password" required>
                        <div class="confirm-delete-buttons">
                            <button type="submit" class="confirmdeletebutton delete">Confirm Delete</button>
                            <button type="button" class="confirmdeletebutton cancel" onclick="cancelDelete()">Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal -->
    <div id="editModal" class="modal hidden">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Edit Profile</h2>

            <form action="editRiderProfile" method="post" class="profile-form">
                <input type="hidden" name="username" value="<%= username %>">

                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" value="<%= firstName %>" required>

                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" value="<%= lastName %>" required>

                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>

                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone" value="<%= phone %>" required>

                <label for="password">Password:</label>
                <div class="password-field">
                    <input type="password" id="password" name="password" value="<%= password %>" required>
                    <span class="toggle-password" onclick="togglePassword()">👁️</span>
                </div>

                <br>
                <button type="submit" class="profbtn">Update</button>
            </form>
        </div>
    </div>

</div>

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

<script>
    function openModal() {
        document.getElementById("editModal").classList.remove("hidden");
    }

    function closeModal() {
        document.getElementById("editModal").classList.add("hidden");
    }

    window.onclick = function (event) {
        const modal = document.getElementById("editModal");
        if (event.target === modal) {
            modal.classList.add("hidden");
        }
    };

    function togglePassword() {
        const passwordInput = document.getElementById("password");
        const toggle = document.querySelector(".toggle-password");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            toggle.textContent = "🙈";
        } else {
            passwordInput.type = "password";
            toggle.textContent = "👁️";
        }
    }


    function showDeleteConfirmation() {
        document.getElementById("deleteConfirmationOverlay").style.display = "flex";
    }

    function cancelDelete() {
        document.getElementById("deleteConfirmationOverlay").style.display = "none";
    }


</script>

</body>
</html>
