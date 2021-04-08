#!/bin/bash
ligo dry-run ../contracts/03-free-taco-shop.religo --amount 1 buy_taco 1n "Map.literal([
  (1n, {current_stock: 50n, max_price: 50tez}),
  (2n, {current_stock: 20n, max_price: 75tez})
])"