package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    @Override
    public void addOrder(Order order) {

        String sql = "INSERT INTO orders "
                + "(userId, restaurantId, orderDate, totalAmount, "
                + "subtotal, discountPercent, discountAmount, "
                + "deliveryFee, tax, status, paymentMode) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setTimestamp(3, Timestamp.valueOf(order.getOrderDate()));
            ps.setDouble(4, order.getTotalAmount());
            ps.setDouble(5, order.getSubtotal());
            ps.setInt(6, order.getDiscountPercent());
            ps.setDouble(7, order.getDiscountAmount());
            ps.setDouble(8, order.getDeliveryFee());
            ps.setDouble(9, order.getTax());
            ps.setString(10, order.getStatus());
            ps.setString(11, order.getPaymentMode());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Order getOrder(int orderId) {

        String sql = "SELECT * FROM orders WHERE orderId = ?";
        Order order = null;

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = mapRow(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public List<Order> getAllOrders() {

        String sql = "SELECT * FROM orders";
        List<Order> orders = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {

        String sql = "SELECT * FROM orders WHERE userId = ?";
        List<Order> orders = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByRestaurant(int restaurantId) {

        String sql = "SELECT * FROM orders WHERE restaurantId = ?";
        List<Order> orders = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapRow(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public void updateOrder(Order order) {

        String sql = "UPDATE orders SET userId = ?, restaurantId = ?, "
                + "orderDate = ?, totalAmount = ?, subtotal = ?, "
                + "discountPercent = ?, discountAmount = ?, "
                + "deliveryFee = ?, tax = ?, status = ?, paymentMode = ? "
                + "WHERE orderId = ?";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setTimestamp(3, Timestamp.valueOf(order.getOrderDate()));
            ps.setDouble(4, order.getTotalAmount());
            ps.setDouble(5, order.getSubtotal());
            ps.setInt(6, order.getDiscountPercent());
            ps.setDouble(7, order.getDiscountAmount());
            ps.setDouble(8, order.getDeliveryFee());
            ps.setDouble(9, order.getTax());
            ps.setString(10, order.getStatus());
            ps.setString(11, order.getPaymentMode());
            ps.setInt(12, order.getOrderId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        String sql = "DELETE FROM orders WHERE orderId = ?";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, orderId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* =====================================================
       Helper — maps one DB row to an Order object
    ===================================================== */
    private Order mapRow(ResultSet rs) throws SQLException {

        Order order = new Order();

        order.setOrderId(rs.getInt("orderId"));
        order.setUserId(rs.getInt("userId"));
        order.setRestaurantId(rs.getInt("restaurantId"));

        Timestamp timestamp = rs.getTimestamp("orderDate");

        if (timestamp != null) {
            order.setOrderDate(timestamp.toLocalDateTime());
        }

        order.setTotalAmount(rs.getDouble("totalAmount"));
        order.setSubtotal(rs.getDouble("subtotal"));
        order.setDiscountPercent(rs.getInt("discountPercent"));
        order.setDiscountAmount(rs.getDouble("discountAmount"));
        order.setDeliveryFee(rs.getDouble("deliveryFee"));
        order.setTax(rs.getDouble("tax"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMode(rs.getString("paymentMode"));

        return order;
    }
}