package com.example.freshcart.dao;

import com.example.freshcart.model.Admin;
import com.example.freshcart.model.Vendor;
import com.example.freshcart.model.InternalUser;
import com.example.freshcart.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InternalUserDAO {

    public InternalUser authenticate(String username, String password, String role) throws Exception {
        String query = "SELECT e.first_name, e.last_name FROM employees e ";
        if ("admin".equalsIgnoreCase(role)) {
            query += "JOIN admin a ON e.employee_id = a.employee_id WHERE a.username = ? AND a.password = ?";
        } else if ("vendor".equalsIgnoreCase(role)) {
            query += "JOIN vendors v ON e.employee_id = v.employee_id WHERE v.username = ? AND v.password = ?";
        } else {
            return null; // invalid role
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");

                    if ("admin".equalsIgnoreCase(role)) {
                        return new Admin(username, firstName, lastName);
                    } else {
                        return new Vendor(username, firstName, lastName);
                    }
                }
            }
        }
        return null; // invalid credentials
    }
}
