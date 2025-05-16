package com.example.freshcart.model;

public class Admin extends InternalUser {

    public Admin(String username, String firstName, String lastName) {
        super(username, firstName, lastName);
    }

    @Override
    public String getDashboardPage() {
        return "adminDashboard.jsp";
    }
}
