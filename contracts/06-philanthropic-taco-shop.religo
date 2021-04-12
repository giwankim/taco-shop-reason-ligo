type taco_supply = {
  current_stock : nat,
  max_price     : tez
};

type taco_shop_storage = map (nat, taco_supply);

type return = (list (operation), taco_shop_storage);

let buy_taco = ((taco_kind_index, taco_shop_storage): (nat, taco_shop_storage)) : return => {
  let taco_kind : taco_supply =
    switch (Map.find_opt (taco_kind_index, taco_shop_storage)) {
    | Some (kind) => kind
    | None => (failwith("Unknown kind of taco.") : taco_supply)
    };
  
  let current_purchase_price : tez =
    taco_kind.max_price / taco_kind.current_stock;

  if (Tezos.amount != current_purchase_price) {
    // We won't sell tacos if the amount is not correct
    failwith("Sorry, the taco you are trying to purchase has a different price");
  };

  // Decrease the stock by 1n, because we have just sold one
  let current_stock : nat = abs (taco_kind.current_stock - 1n);
  let taco_kind : taco_supply = {...taco_kind, current_stock : current_stock};

  // Update the storage with the refreshed taco_kind
  let taco_shop_storage : taco_shop_storage =
    Map.update(taco_kind_index, Some (taco_kind), taco_shop_storage);

  // Define the recipients
  let ownerAddress : address =
    ("tz1TGu6TN5GSez2ndXXeDX6LgUDvLzPLqgYV" : address);
  let donationAddress : address =
    ("tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx" : address);

  let receiver : contract (unit) =
    switch (Tezos.get_contract_opt (ownerAddress) : option(contract(unit))) {
    | Some (contract) => contract
    | None            => (failwith("Not a contract") : (contract(unit)))
    };
  let donationReceiver : contract (unit) =
    switch (Tezos.get_contract_opt (donationAddress) : option(contract(unit))) {
    | Some (contract) => contract
    | None            => (failwith("Not a contract") : contract(unit))
    };

  let donationAmount : tez = Tezos.amount / 10n;

  // Pedro will get 90% of the amount
  let payoutOperation : operation =
    Tezos.transaction(unit, Tezos.amount - donationAmount, receiver);
  // Donate 10%
  let donationOperation : operation =
   Tezos.transaction(unit, donationAmount, donationReceiver);

  // Add the transactions to the list of output operations
  let operations : list(operation) = [payoutOperation, donationOperation];

  // Return the two operations to be subsequently executed on the blockchain
  ((operations : list (operation)), taco_shop_storage);
};
