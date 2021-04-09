type taco_supply = {
  current_stock : nat,
  max_price     : tez
};

type taco_shop_storage = map (nat, taco_supply);

type return = (list (operation), taco_shop_storage);

let buy_taco = ((taco_kind_index, taco_shop_storage) : (nat, taco_shop_storage)) : return => {
  // Retrieve the taco_kind from the contract's storage or fail
  let taco_kind : taco_supply = {
    switch (Map.find_opt (taco_kind_index, taco_shop_storage)) {
    | Some (kind) => kind
    | None => (failwith ("Unknown kind of taco.") : taco_supply)
    };
  };

  let current_purchase_price : tez =
    taco_kind.max_price / taco_kind.current_stock;

  if (Tezos.amount != current_purchase_price) {
    // We won't sell tacos if the amount is not correct
    failwith (
      "Sorry, the taco you are trying to purchase has a different price");
  };

  // Decrease the stock by 1n, because we have just sold one
  let current_stock : nat = abs (taco_kind.current_stock - 1n);
  let taco_kind : taco_supply = {...taco_kind, current_stock : current_stock};

  // Update the storage with the refreshed taco_kind
  let taco_shop_storage : taco_shop_storage =
    Map.update(taco_kind_index, Some (taco_kind), taco_shop_storage);

  // Return updated taco_shop_storage
  (([]: list (operation)), taco_shop_storage);
};
