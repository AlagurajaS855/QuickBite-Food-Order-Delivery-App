package com.model;

import java.math.BigDecimal;

public class CartItem {
    private int itemId;
    private String name;
    private  BigDecimal price;
    private  int quantity;
    private String image;

    public CartItem() { }

    public CartItem(int itemId, String name, BigDecimal price, int quantity, String image) {
        this.itemId = itemId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
    }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public  BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public  int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public BigDecimal getSubtotal() {
        return price.multiply(new BigDecimal(quantity));
    }
    
}
