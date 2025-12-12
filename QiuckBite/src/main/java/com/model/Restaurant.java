package com.model;

public class Restaurant {
    private long restaurantId;
    private String name;
    private double rating;
    private String description;
    private String address;
	private String imageUrl;

    
    
	
	public Restaurant(long restaurantId, String name, double rating, String description, String imageUrl, String address) {
	    this.restaurantId = restaurantId;
	    this.name = name;
	    this.rating = rating;
	    this.description = description;
	    this.imageUrl = imageUrl;
	    this.address = address;
	}

	public Restaurant(String name, double rating, String description, String imageUrl, String address) {
		this.name = name;
		this.rating = rating;
		this.description = description;
		this.address = address;
		this.imageUrl = imageUrl;
	}
	

	public long getRestaurantId() {
		return restaurantId;
	}
	public String getName() {
		return name;
	}
	public double getRating() {
		return rating;
	}
	public String getDescription() {
		return description;
	}
	public String getAddress() {
		return address;
	}
	public String getImageUrl() {
		return imageUrl;
	}
   
    
	@Override
	public String toString() {
		return "Restaurant [restaurantId=" + restaurantId + ", name=" + name + ", rating=" + rating + ", description=" + description
				+ ", address=" + address + ", imageUrl=" + imageUrl + "]";
	}
}




	
