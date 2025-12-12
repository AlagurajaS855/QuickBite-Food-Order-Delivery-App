package com.model;

import java.math.BigDecimal;

public class OrderItem {

	    private long orderItemId;
	    private long orderId;    // belongs to which order
	    private long menuItemId; // menu table id
	    private String name;    // menu item name
	    private int quantity;
	    private BigDecimal price; // price per unit
	    private BigDecimal subtotal;
	    
	    public OrderItem() { }
	    
	    public OrderItem(int orderItemId, int orderId, int menuItemId,
                String name, int quantity, BigDecimal price) {
		   this.orderItemId = orderItemId;
		   this.orderId = orderId;
		   this.menuItemId = menuItemId;
		   this.name = name;
		   this.quantity = quantity;
		   this.price = price;
		   this.subtotal = price.multiply(new BigDecimal(quantity));
	    }
		    // Getters and Setters
		    public long getOrderItemId() { return orderItemId; }

		    public void setOrderItemId(long orderItemId) { this.orderItemId = orderItemId; }

		    public long getOrderId() { return orderId; }

		    public void setOrderId(long orderId) { this.orderId = orderId; }

		    public long getMenuItemId() { return menuItemId; }

		    public void setMenuItemId(long menuItemId) { this.menuItemId = menuItemId; }

		    public String getName() { return name; }

		    public void setName(String name) { this.name = name; }

		    public int getQuantity() { return quantity; }

		    public void setQuantity(int quantity) {
		        this.quantity = quantity;
		        this.subtotal = price.multiply(new BigDecimal(quantity));
		    }

		    public BigDecimal getPrice() { return price; }

		    public void setPrice(BigDecimal price) { this.price = price; }

		    public BigDecimal getSubtotal() { return subtotal; }

		    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

	

			
		
}

