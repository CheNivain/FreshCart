package com.example.freshcart.model;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class Customer extends User {

    public Customer(String f, String l, String e, String p, String u, String pw) {
        super(f, l, e, p, u, pw);
    }

    @Override
    public boolean register(Connection conn) throws java.sql.SQLException {
        String sql = "INSERT INTO customers (first_name, last_name, email, phone_number, username, password, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, username);
            ps.setString(6, password);
            return ps.executeUpdate() > 0;
        }

    }
}

