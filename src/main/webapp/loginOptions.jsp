<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Our Grocery</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="login-body">

<div class="login-container">
    <h2 class="login-title">Login to Continue</h2>
    <p class="login-subtitle">Please select your role and enter your credentials</p>

    <form action="authenticateProfile" method="post" class="login-form">

        <label for="role">Select Role</label>
        <select id="role" name="role" required>
            <option value="vendor">Vendor</option>
            <option value="admin">Admin</option>
        </select>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <br>
        <button type="submit" class="btn login-btn">Login</button>
    </form>

    <p class="register-text">
        <a href="login.jsp" class="alt-link">Not a Vendor/Admin?</a>
    </p>

</div>

</body>
</html>
