trait HasName
  fun name(): String => "Bob"

trait HasAge
  fun age(): U32 => 42

trait HasFeelings
  fun feeling(): String => "Great!"

type Person is (HasName & HasAge & HasFeelings)