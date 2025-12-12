package com.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Order {

	    private long orderId;
	    private long userId; // who placed the order
	    private BigDecimal totalAmount;
	    private String status; // PENDING, CONFIRMED, DELIVERED, CANCELLED
	    private LocalDateTime orderDate;
	    private long restaurantId;        // NEW
	    private String deliveryAddress;  // NEW
	    private String paymentMethod;    // NEW (COD, UPI, CARD, WALLET)
	    private List<OrderItem> items = new ArrayList<>();
	    
	    public Order() {}

		public Order(int orderId, int userId, BigDecimal totalAmount, String status, LocalDateTime orderDate,
				int restaurantId, String deliveryAddress, String paymentMethod) {
			super();
			this.orderId = orderId;
			this.userId = userId;
			this.totalAmount = totalAmount;
			this.status = status;
			this.orderDate = orderDate;
			this.restaurantId = restaurantId;
			this.deliveryAddress = deliveryAddress;
			this.paymentMethod = paymentMethod;
		}

	
		
	    // Add item to order
	    public void addItem(OrderItem item) {
	        items.add(item);
	    }

		public long getOrderId() {
			return orderId;
		}

		public void setOrderId(long orderId) {
			this.orderId = orderId;
		}

		public long getUserId() {
			return userId;
		}

		public void setUserId(long userId) {
			this.userId = userId;
		}

		public BigDecimal getTotalAmount() {
			return totalAmount;
		}

		public void setTotalAmount(BigDecimal totalAmount) {
			this.totalAmount = totalAmount;
		}

		public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}

		public LocalDateTime getOrderDate() {
			return orderDate;
		}

		public void setOrderDate(LocalDateTime orderDate) {
			this.orderDate = orderDate;
		}

		public long getRestaurantId() {
			return restaurantId;
		}

		public void setRestaurantId(long restaurantId) {
			this.restaurantId = restaurantId;
		}

		public String getDeliveryAddress() {
			return deliveryAddress;
		}

		public void setDeliveryAddress(String deliveryAddress) {
			this.deliveryAddress = deliveryAddress;
		}

		public String getPaymentMethod() {
			return paymentMethod;
		}

		public void setPaymentMethod(String paymentMethod) {
			this.paymentMethod = paymentMethod;
		}

		public List<OrderItem> getItems() {
			return items;
		}

		public void setItems(List<OrderItem> items) {
			this.items = items;
		}

		@Override
		public String toString() {
			return "Order [orderId=" + orderId + ", userId=" + userId + ", totalAmount=" + totalAmount + ", status="
					+ status + ", orderDate=" + orderDate + ", restaurantId=" + restaurantId + ", deliveryAddress="
					+ deliveryAddress + ", paymentMethod=" + paymentMethod + ", items=" + items + "]";
		}

	    

	    
}
