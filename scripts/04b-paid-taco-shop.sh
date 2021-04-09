#!/bin/bash
# Attempting to purchase a taco with 0.7tez
ligo dry-run ../contracts/04-paid-taco-shop.religo --amount 0.7 buy_taco 1n "Map.literal([
  (1n, {current_stock: 50n, max_price: 50tez}),
  (2n, {current_stock: 20n, max_price: 75tez})
])"
