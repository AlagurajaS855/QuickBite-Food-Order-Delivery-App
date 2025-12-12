package com.model;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items = new LinkedHashMap<>();

    public void addItem(CartItem item) {
        CartItem existing = items.get(item.getItemId());
        if (existing != null) {
            int existingQuantity = existing.getQuantity();
            existing.setQuantity(existingQuantity + item.getQuantity());
        } else {
            items.put(item.getItemId(), item);
        }
    }

    public void updateQuantity(int id, int qty) {
        if (items.containsKey(id)) {
            if (qty <= 0) {
                items.remove(id);
            } else {
                items.get(id).setQuantity(qty);
            }
        }
    }

    public void removeItem(int id) {
        items.remove(id);
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public int getTotalQuantity() {
        return items.values()
                    .stream()
                    .mapToInt(CartItem::getQuantity)
                    .sum();
    }


    public BigDecimal getTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem i : items.values()) {
            total = total.add(i.getSubtotal());
        }
        return total;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clear() {
        items.clear();
    }
}
