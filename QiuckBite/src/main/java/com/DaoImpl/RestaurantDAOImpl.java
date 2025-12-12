package com.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.DAO.RestaurantDAO;
import com.model.Restaurant;
import com.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO{
	@Override
	public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();

        String sql = "SELECT restaurant_id, restaurant_name, rating, description, address, image_url FROM restaurants";

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                long id = rs.getLong("restaurant_id");
                String name = rs.getString("restaurant_name");
                double rating = rs.getDouble("rating");
                String description = rs.getString("description");
                String address = rs.getString("address");
                String image_url = rs.getString("image_url");

                Restaurant r = new Restaurant(id, name,rating,description,image_url,address);
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
