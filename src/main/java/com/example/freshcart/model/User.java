package com.example.freshcart.model;

public abstract class User {
    protected String firstName;
    protected String lastName;
    protected String email;
    protected String phone;
    protected String username;
    protected String password;

    public User(String firstName, String lastName, String email, String phone, String username, String password) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.username = username;
        this.password = password;
    }

    // Getters and setters (encapsulation)
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }

    public abstract boolean register(java.sql.Connection conn) throws java.sql.SQLException;

}
