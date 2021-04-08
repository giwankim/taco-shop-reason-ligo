type taco_supply = {
  current_stock : nat,
  max_price     : tez
};

type taco_shop_storage = map (nat, taco_supply);

type return = (list (operation), taco_shop_storage);

let main = ((parameter, taco_shop_storage): (unit, taco_shop_storage)) : return =>
  (([] : list (operation)), taco_shop_storage);
