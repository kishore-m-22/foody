package com.tap.util;

import com.tap.DaoImpl.UserDaoImpl;
import com.tap.model.User;

public class TestUserDao {

    public static void main(String[] args) {

        UserDaoImpl userDao = new UserDaoImpl();

        User user = new User();

        user.setUsername("testuser");
        user.setPassword("12345");
        user.setEmail("testuser@gmail.com");
        user.setPhone("9876543210");
        user.setAddress("Bengaluru");
        user.setRole("USER");

        userDao.addUser(user);

        System.out.println("User added successfully!");
    }
}