package com.example.freshcart.model;

public abstract class InternalUser {
    protected String username;
    protected String firstName;
    protected String lastName;

    public InternalUser(String username, String firstName, String lastName) {
        this.username = username;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getUsername() { return username; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }

    public abstract String getDashboardPage();
}
