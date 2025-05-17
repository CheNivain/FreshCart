<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Admin | FreshCart</title>
    <link rel="stylesheet" href="registerAdmin.css">
</head>
<body class="admin-register-body">

<!-- Header -->
<header class="admin-header">
    <div class="admin-header-container">
        <h1>FreshCart Admin Portal</h1>
        <p>Internal Use Only</p>
    </div>
</header>

<div class="admin-register-container">
    <h2 class="admin-register-title">Admin Registration</h2>
    <p class="admin-register-subtitle">Please fill in the details below to register as an admin.</p>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="error-message" style="color: red; font-weight: bold; margin-bottom: 15px;">
        <%= error %>
    </div>
    <% } %>

    <form action="registerAdmin" method="post" class="admin-register-form">

        <!-- Admin Name -->
        <label for="EmployeeID">Employee ID</label>
        <input type="text" id="EmployeeID" name="EmployeeID" placeholder="Enter your Employee ID"
               value="<%= request.getParameter("EmployeeID") != null ? request.getParameter("EmployeeID") : "" %>"
               required>

        <!-- Admin Username -->
        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Choose a username"
               value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required>

        <!-- Admin Password -->
        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <!-- Confirm Password -->
        <label for="confirm-password">Confirm Password</label>
        <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirm password" required>

        <br><br>
        <button type="submit" class="btn register-btn">Register</button>
    </form>
</div>

<!-- Footer -->
<footer class="admin-footer">
    <p>&copy; 2025 FreshCart Admin Portal. Confidential & Internal Use Only.</p>
</footer>

</body>
</html>
