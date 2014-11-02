// A simple loop require invariants

procedure A()
{
  var i,j : int;

  i := 0; j := 0;
  while (i < 100)
    invariant 0 <= j;
    invariant      j <= 200;
    invariant j == 2*i;
  {
    i := i + 1;
    j := j + 2;
  }
  assert(j == 200);
}
