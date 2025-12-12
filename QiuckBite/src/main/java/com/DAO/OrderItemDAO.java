package com.DAO;

import com.model.OrderItem;
import java.sql.SQLException;
import java.util.List;

public interface OrderItemDAO {
    long saveOrderItem(long orderId, OrderItem item) throws SQLException;

    List<OrderItem> getOrderItemsByOrderId(long orderId) throws SQLException;

}
