package com.tap.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.tap.Dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    // ADD RESTAURANT
    @Override
    public void addRestaurant(Restaurant restaurant) {

        String sql = "INSERT INTO restaurant "
                + "(name, cuisineType, deliveryTime, address, adminUserId, "
                + "rating, isActive, imagePath, discountPercent) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setInt(5, restaurant.getAdminUserId());
            ps.setDouble(6, restaurant.getRating());
            ps.setBoolean(7, restaurant.isActive());
            ps.setString(8, restaurant.getImagePath());
            ps.setInt(9, restaurant.getDiscountPercent());

            ps.executeUpdate();

            System.out.println("Restaurant added successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // GET RESTAURANT BY ID
    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        String sql = "SELECT * FROM restaurant WHERE restaurantId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                restaurant = mapRestaurant(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurant;
    }


    // GET ALL RESTAURANTS
    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        String sql = "SELECT * FROM restaurant ORDER BY restaurantId";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                restaurants.add(mapRestaurant(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurants;
    }


    // UPDATE RESTAURANT
    @Override
    public void updateRestaurant(Restaurant restaurant) {

        String sql = "UPDATE restaurant SET "
                + "name = ?, "
                + "cuisineType = ?, "
                + "deliveryTime = ?, "
                + "address = ?, "
                + "adminUserId = ?, "
                + "rating = ?, "
                + "isActive = ?, "
                + "imagePath = ?, "
                + "discountPercent = ? "
                + "WHERE restaurantId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setInt(5, restaurant.getAdminUserId());
            ps.setDouble(6, restaurant.getRating());
            ps.setBoolean(7, restaurant.isActive());
            ps.setString(8, restaurant.getImagePath());
            ps.setInt(9, restaurant.getDiscountPercent());
            ps.setInt(10, restaurant.getRestaurantId());

            ps.executeUpdate();

            System.out.println("Restaurant updated successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // DELETE RESTAURANT
    @Override
    public void deleteRestaurant(int restaurantId) {

        String sql = "DELETE FROM restaurant WHERE restaurantId = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);

            ps.executeUpdate();

            System.out.println("Restaurant deleted successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // MAP RESULTSET TO RESTAURANT OBJECT
    private Restaurant mapRestaurant(ResultSet rs) throws Exception {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(
                rs.getInt("restaurantId")
        );

        restaurant.setName(
                rs.getString("name")
        );

        restaurant.setCuisineType(
                rs.getString("cuisineType")
        );

        restaurant.setDeliveryTime(
                rs.getInt("deliveryTime")
        );

        restaurant.setAddress(
                rs.getString("address")
        );

        restaurant.setAdminUserId(
                rs.getInt("adminUserId")
        );

        restaurant.setRating(
                rs.getDouble("rating")
        );

        restaurant.setActive(
                rs.getBoolean("isActive")
        );

        restaurant.setImagePath(
                rs.getString("imagePath")
        );

        restaurant.setDiscountPercent(
                rs.getInt("discountPercent")
        );

        return restaurant;
    }
}