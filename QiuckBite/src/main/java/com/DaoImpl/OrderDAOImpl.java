package com.DaoImpl;

import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

import com.DAO.OrderDAO;
import com.model.Order;
import com.model.OrderItem;
import com.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public long saveOrder(Order order) throws Exception {
        String sql = "INSERT INTO orders (user_id, restaurant_id, total_amount, order_date, status, delivery_address) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        long generatedOrderId = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            conn.setAutoCommit(false); // Start transaction

            ps.setLong(1, order.getUserId());
            ps.setLong(2, order.getRestaurantId());
            ps.setBigDecimal(3, order.getTotalAmount());
            ps.setTimestamp(4, Timestamp.valueOf(order.getOrderDate()));
            ps.setString(5, order.getStatus());
            ps.setString(6, order.getDeliveryAddress());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                generatedOrderId = rs.getLong(1);
            }

            conn.commit();  // Save success

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Error while saving order");
        }

        return generatedOrderId;
    }

    @Override
    public void saveOrderItems(long orderId, List<OrderItem> items) throws Exception {

        String sql = "INSERT INTO order_items (order_id, food_id, food_name, price, quantity, subtotal) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false);

            for (OrderItem item : items) {

                ps.setLong(1, orderId);
                ps.setLong(2, item.getOrderItemId());
                ps.setString(3, item.getName());
                ps.setBigDecimal(4, item.getPrice());
                ps.setInt(5, item.getQuantity());
                ps.setBigDecimal(6, item.getSubtotal());

                ps.addBatch();
            }

            ps.executeBatch();
            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Error while saving order items");
        }
    }

    @Override
    public Order getOrderById(long orderId) throws Exception {

        String orderSql = "SELECT * FROM orders WHERE order_id=?";
        String itemSql  = "SELECT * FROM order_items WHERE order_id=?";

        Order order = null;

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(orderSql);
            ps.setLong(1, orderId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getLong("order_id"));
                order.setUserId(rs.getLong("user_id"));
                order.setRestaurantId(rs.getLong("restaurant_id"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                order.setStatus(rs.getString("status"));
                order.setDeliveryAddress(rs.getString("delivery_address"));

            }

            // Fetch items
            PreparedStatement ps2 = conn.prepareStatement(itemSql);
            ps2.setLong(1, orderId);

            ResultSet rs2 = ps2.executeQuery();

            List<OrderItem> items = new ArrayList<>();

            while (rs2.next()) {
                OrderItem item = new OrderItem();

                item.setOrderItemId(rs2.getLong("order_item_id"));
                item.setMenuItemId(rs2.getLong("menu_id"));
                item.setName(rs2.getString("item_name"));
                item.setPrice(rs2.getBigDecimal("price_at_purchase"));
                item.setQuantity(rs2.getInt("quantity"));
                item.setSubtotal(rs2.getBigDecimal("subtotal"));

                items.add(item);
            }

            if (order != null) {
                order.setItems(items);
            }
        }

        return order;
    }
    @Override
    public List<Order> getOrdersByUserId(long userId) throws Exception {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Order> orders = new ArrayList<>();
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getLong("order_id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setRestaurantId(rs.getInt("restaurant_id"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setDeliveryAddress(rs.getString("delivery_address"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    java.sql.Timestamp ts = rs.getTimestamp("order_date");
                    if (ts != null) {
                        order.setOrderDate(ts.toLocalDateTime());
                    }
                    orders.add(order);
                }
                return orders;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new Exception("Error fetching orders", e);
        }
    }

}
