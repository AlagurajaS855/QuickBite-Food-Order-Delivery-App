package com.model;

import java.math.BigDecimal;

public class Menu {
    private int id;
    private String name1;
    private String description;
    private BigDecimal price;
    private double rating;
    private String image_url;
    private long restaurant_id;

    public Menu() { }

    // Updated constructor: set id and restaurant_id if provided (restaurant id optional)
    public Menu(int id, String name1, String description, BigDecimal price, double rating, String image_url) {
        this.id = id;
        this.name1 = name1;
        this.description = description;
        this.price = price;
        this.rating = rating;
        this.image_url = image_url;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName1() { return name1; }
    public void setName1(String name1) { this.name1 = name1; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getImage_url() { return image_url; }
    public void setImage_url(String image_url) { this.image_url = image_url; }

    public long getRestaurant_id() { return restaurant_id; }
    public void setRestaurant_id(long restaurant_id) { this.restaurant_id = restaurant_id; }

    @Override
    public String toString() {
        return "Menu [id=" + id + ", name1=" + name1 + ", description=" + description + ", price=" + price + ", rating="
                + rating + ", image_url=" + image_url + ", restaurant_id=" + restaurant_id + "]";
    }
}
