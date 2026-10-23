package com.tap.model;

import java.time.LocalDateTime;

public class Order {

    private int orderId;
    private int userId;
    private int restaurantId;
    private LocalDateTime orderDate;
    private double totalAmount;

    // ===== Breakdown fields =====
    private double subtotal;
    private int discountPercent;
    private double discountAmount;
    private double deliveryFee;
    private double tax;

    private String status;
    private String paymentMode;

    public Order() {
    }

    public Order(int orderId, int userId, int restaurantId,
                 LocalDateTime orderDate, double totalAmount,
                 double subtotal, int discountPercent,
                 double discountAmount, double deliveryFee,
                 double tax, String status, String paymentMode) {

        this.orderId = orderId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.subtotal = subtotal;
        this.discountPercent = discountPercent;
        this.discountAmount = discountAmount;
        this.deliveryFee = deliveryFee;
        this.tax = tax;
        this.status = status;
        this.paymentMode = paymentMode;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public double getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(double deliveryFee) { this.deliveryFee = deliveryFee; }

    public double getTax() { return tax; }
    public void setTax(double tax) { this.tax = tax; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMode() { return paymentMode; }
    public void setPaymentMode(String paymentMode) { this.paymentMode = paymentMode; }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", restaurantId=" + restaurantId +
                ", orderDate=" + orderDate +
                ", totalAmount=" + totalAmount +
                ", subtotal=" + subtotal +
                ", discountPercent=" + discountPercent +
                ", discountAmount=" + discountAmount +
                ", deliveryFee=" + deliveryFee +
                ", tax=" + tax +
                ", status='" + status + '\'' +
                ", paymentMode='" + paymentMode + '\'' +
                '}';
    }
}