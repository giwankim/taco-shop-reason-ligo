let main = ((parameter, contractStorage) : (int, int)) : (list (operation), int) =>
  (([] : list (operation)), contractStorage + parameter);
