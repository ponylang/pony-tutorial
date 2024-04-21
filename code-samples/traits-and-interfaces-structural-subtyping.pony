interface box Stringable
  """
  Things that can be turned into a String.
  """
  fun string(): String iso^
    """
    Generate a string representation of this object.
    """

primitive ExecveError
  fun string(): String iso^ => "ExecveError".clone()