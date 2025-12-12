package com.model;

import java.sql.Timestamp;
import java.util.TimerTask;

public class Users {


		private int userId;           
	    private String name;      
	    private String email;          
	    private String phone;          
	    private String password;          
	    private String role;          
	    private String address;      
	    private Timestamp created_at;      
	    private Timestamp last_login_date;      
	    
	    

	
	public Users() {
		
	}
	
	public Users( String name, String email, String phone, String password, String role, String address) {
		this.name = name;
		this.email = email;
		this.phone = phone;
		this.password = password;
		this.role = role;
		this.address = address;
	
	}
	public Users(int id, String name, String email, String phone, String password, String role, String address) {
		this.userId = id;
		this.name = name;
		this.email = email;
		this.phone = address;
		this.password = password;
		this.role = address;
		this.address = address;
	
	}
	
	


	public void setUserId(int userId) {
		this.userId = userId;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

	public void setLast_login_date(Timestamp last_login_date) {
		this.last_login_date = last_login_date;
	}

	public int getUserId() {
		return userId;
	}

	public String getName() {
		return name;
	}

	public String getEmail() {
		return email;
	}

	public String getPhone() {
		return phone;
	}

	public String getPassword() {
		return password;
	}

	public String getRole() {
		return role;
	}

	public String getAddress() {
		return address;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public Timestamp getLast_login_date() {
		return last_login_date;
	}

	@Override
	public String toString() {
		return "Users [user_id=" + userId + ", full_name=" + name + ", email=" + email + ", phone=" + phone
				+ ", password_hash=" + password + ", role=" + role + ", address=" + address + ", created_at="
				+ created_at + ", last_login_date=" + last_login_date + "]";
	}

	
	

	



	
}