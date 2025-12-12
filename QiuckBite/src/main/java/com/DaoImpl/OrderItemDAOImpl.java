package com.DaoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.DAO.OrderItemDAO;
import com.model.OrderItem;
import com.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    // Do NOT insert order_item_id if it is AUTO_INCREMENT.
    // Include all the columns you want to set, in correct order.
    private static final String INSERT_SQL =
            "INSERT INTO order_items (order_id, menu_id, item_name, quantity, price_at_purchase, subtotal) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_BY_ORDER_ID =
            "SELECT * FROM order_items WHERE order_id = ?";

    @Override
    public long saveOrderItem(long orderId, OrderItem item) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {

            // 1 → order_id
            ps.setLong(1, orderId);
            // 2 → menu_item_id (from your model)
            ps.setLong(2, item.getMenuItemId());
            // 3 → item_name
            ps.setString(3, item.getName());
            // 4 → quantity
            ps.setInt(4, item.getQuantity());
            // 5 → price_at_purchase
            ps.setBigDecimal(5, item.getPrice());
            // 6 → subtotal
            ps.setBigDecimal(6, item.getSubtotal());

            ps.executeUpdate();
        }
        return orderId;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(long orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ORDER_ID)) {

            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getLong("order_item_id"));
                item.setOrderId(rs.getLong("order_id"));
                item.setMenuItemId(rs.getInt("menu_id"));      // make sure this column exists
                item.setName(rs.getString("item_name"));
                item.setPrice(rs.getBigDecimal("price_at_purchase"));
                item.setQuantity(rs.getInt("quantity"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                items.add(item);
            }
        }

        return items;
    }
}
