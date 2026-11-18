class \nomutate\ Ledger
  fun balance(): U64 =>
    100

  fun \mutate_only(aor, ror)\ affordable(balance': U64, charge: U64): Bool =>
    (balance'.i128() - charge.i128()) > 0

actor \nomutate\ Main
  new create(env: Env) =>
    let ledger = Ledger
    env.out.print(ledger.affordable(ledger.balance(), 25).string())
