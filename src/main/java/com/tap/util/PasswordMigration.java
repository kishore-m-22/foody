package com.tap.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordMigration {

    public static void main(String[] args) {

        String selectSQL =
                "SELECT userId, password FROM users";

        String updateSQL =
                "UPDATE users SET password = ? WHERE userId = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement selectPS =
                    con.prepareStatement(selectSQL);
            PreparedStatement updatePS =
                    con.prepareStatement(updateSQL);
            ResultSet rs = selectPS.executeQuery()
        ) {

            while (rs.next()) {

                int userId = rs.getInt("userId");
                String currentPassword = rs.getString("password");

                // Skip passwords already converted to BCrypt
                if (currentPassword.startsWith("$2a$")) {
                    System.out.println(
                        "Already hashed: User ID " + userId
                    );
                    continue;
                }

                // Convert plaintext password to BCrypt
                String hashedPassword =
                        BCrypt.hashpw(
                            currentPassword,
                            BCrypt.gensalt(12)
                        );

                // Save BCrypt password
                updatePS.setString(1, hashedPassword);
                updatePS.setInt(2, userId);

                updatePS.executeUpdate();

                System.out.println(
                    "Updated User ID: " + userId
                );
            }

            System.out.println(
                "All passwords have been converted to BCrypt."
            );

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}