package com.DaoImpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.DAO.MenuDAO;
import com.model.Menu;
import com.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String FETCH_MENU =
        "SELECT menu_id, item_name, description, price, rating, image_url FROM menu WHERE restaurant_id = ?";

    @Override
    public List<Menu> getAllMenuByRestaurant(long restaurantId) {
        List<Menu> list = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FETCH_MENU)) {

            statement.setLong(1, restaurantId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("menu_id");
                String name = rs.getString("item_name");
                String description = rs.getString("description");
                BigDecimal price = rs.getBigDecimal("price");
                double rating = rs.getDouble("rating");
                String image_url = rs.getString("image_url");

                Menu m = new Menu(id, name, description, price, rating, image_url);
                // Set restaurant id so JSP can reuse it
                m.setRestaurant_id(restaurantId);

                list.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
