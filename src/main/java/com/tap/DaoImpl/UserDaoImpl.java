package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.UserDao;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDaoImpl implements UserDao {

    @Override
    public void addUser(User user) {

        String sql = "INSERT INTO users "
                   + "(username, password, email, phone, address, role) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            if (con == null) {
                throw new SQLException("Database connection is null.");
            }

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                System.out.println(
                    "User registered successfully: " + user.getEmail()
                );
            }

        } catch (SQLException e) {

            System.out.println("User registration failed!");
            e.printStackTrace();

            throw new RuntimeException(
                "Unable to register user.", e
            );
        }
    }


    @Override
    public User getUser(int userId) {

        String sql = "SELECT * FROM users WHERE userId = ?";
        User user = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                user = new User();

                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }


    @Override
    public User getUserByEmail(String email) {

        String sql = "SELECT * FROM users WHERE email = ?";
        User user = null;

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                user = new User();

                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }


    @Override
    public List<User> getAllUsers() {

        String sql = "SELECT * FROM users";
        List<User> users = new ArrayList<>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));

                users.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }


    @Override
    public void updateUser(User user) {

        String sql = "UPDATE users SET "
                   + "username = ?, password = ?, email = ?, "
                   + "phone = ?, address = ?, role = ? "
                   + "WHERE userId = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getUserId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteUser(int userId) {

        String sql = "DELETE FROM users WHERE userId = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    /*
     * Permanently deletes the user's account.
     *
     * Order:
     * 1. Delete order_item records
     * 2. Delete orders
     * 3. Delete user
     *
     * All operations happen inside one transaction.
     */
    @Override
    public void deleteAccount(int userId) {

        String deleteOrderItems =
                "DELETE FROM order_item "
              + "WHERE orderId IN "
              + "(SELECT orderId FROM orders WHERE userId = ?)";

        String deleteOrders =
                "DELETE FROM orders WHERE userId = ?";

        String deleteUser =
                "DELETE FROM users WHERE userId = ?";

        Connection con = null;

        try {

            con = DBConnection.getConnection();

            if (con == null) {
                throw new SQLException(
                    "Database connection is null."
                );
            }

            /*
             * Start transaction
             */
            con.setAutoCommit(false);

            /*
             * Step 1:
             * Delete order items belonging to user's orders.
             */
            try (PreparedStatement ps =
                    con.prepareStatement(deleteOrderItems)) {

                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            /*
             * Step 2:
             * Delete user's orders.
             */
            try (PreparedStatement ps =
                    con.prepareStatement(deleteOrders)) {

                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            /*
             * Step 3:
             * Delete the user.
             */
            try (PreparedStatement ps =
                    con.prepareStatement(deleteUser)) {

                ps.setInt(1, userId);

                int rowsDeleted = ps.executeUpdate();

                if (rowsDeleted == 0) {
                    throw new SQLException(
                        "User account was not found."
                    );
                }
            }

            /*
             * Everything succeeded.
             */
            con.commit();

            System.out.println(
                "User account permanently deleted: " + userId
            );

        } catch (SQLException e) {

            /*
             * Something failed.
             * Roll back all changes.
             */
            if (con != null) {

                try {
                    con.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }

            e.printStackTrace();

            throw new RuntimeException(
                "Unable to delete user account.", e
            );

        } finally {

            if (con != null) {

                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}