interface HasName
  fun name(): String

interface HasAge
  fun age(): U32

interface HasFeelings
  fun feeling(): String

type Person is (HasName & HasAge & HasFeelings)