package com.DAO;

import com.model.Users;

public interface UsersDAO {
    Users login(String email, String password);
    boolean signup(Users user);
    boolean isEmailExists(String email);
}
