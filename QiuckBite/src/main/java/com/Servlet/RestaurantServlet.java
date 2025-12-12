package com.Servlet;

import java.io.IOException;
import java.util.List;

import com.DaoImpl.RestaurantDAOImpl;
import com.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet{

	private RestaurantDAOImpl restaurantDAOImpl;
	@Override
	public void init() throws ServletException {
		 restaurantDAOImpl = new RestaurantDAOImpl();
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
		List<Restaurant> allRestaurants = restaurantDAOImpl.getAllRestaurants();
		
		req.setAttribute("allRestaurants", allRestaurants);
		}
		catch (Exception e) {
	        e.printStackTrace();
	        req.setAttribute("error", "Unable to load restaurants. Please try again.");
	    }
		RequestDispatcher rd = req.getRequestDispatcher("restaurant.jsp");
		rd.forward(req, resp);
	}
}
