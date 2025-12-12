package com.DAO;

import java.util.List;
import com.model.Order;
import com.model.OrderItem;

public interface OrderDAO {

    long saveOrder(Order order) throws Exception;

    void saveOrderItems(long orderId, List<OrderItem> items) throws Exception;

    Order getOrderById(long orderId) throws Exception;

    List<Order> getOrdersByUserId(long userId) throws Exception;
}
