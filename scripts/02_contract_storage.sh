#!/bin/bash
ligo dry-run ../contracts/02_contract_storage.religo main unit "Map.literal([
  (1n, {current_stock: 50n, max_price: 50tez}),
  (2n, {current_stock: 20n, max_price: 75tez})
])"