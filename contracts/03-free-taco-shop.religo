type taco_supply = {
  current_stock : nat,
  max_price     : tez
};

type taco_shop_storage = map (nat, taco_supply);

type return = (list (operation), taco_shop_storage);

let buy_taco = ((taco_kind_index, taco_shop_storage): (nat, taco_shop_storage)) : return => {
  // Retrieve the taco_kind from the contract's storage or fail
  let taco_kind : taco_supply =
    switch (Map.find_opt(taco_kind_index, taco_shop_storage)) {
    | Some (kind) => kind
    | None => (failwith ("Unknown kind of taco.") : taco_supply)
    };

  // Decreate the stock by 1n, because we have just sold one
  let current_stock : nat = abs (taco_kind.current_stock - 1n);
  let taco_kind = {...taco_kind, current_stock : current_stock};
  

  // Update the storage with the refreshed taco_kind
  let taco_shop_storage : taco_shop_storage = Map.update(taco_kind_index, Some (taco_kind), taco_shop_storage);

  // Return updated taco_shop_storage
  (([]: list(operation)), taco_shop_storage);
};
