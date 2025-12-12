package com.DAO;

import java.util.ArrayList;
import java.util.List;

import com.model.Menu;

public interface MenuDAO {
	
	List<Menu> getAllMenuByRestaurant(long restaurantId);
}
