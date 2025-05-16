package com.example.freshcart.model;

public class Vendor extends InternalUser {

    public Vendor(String username, String firstName, String lastName) {
        super(username, firstName, lastName);
    }

    @Override
    public String getDashboardPage() {
        return "vendorDashboard.jsp";
    }
}
