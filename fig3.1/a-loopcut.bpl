procedure ALoopCut()
{
  var i,j : int;

  i := 0; j := 0;
  assert j == 2 * i;
  havoc i,j;
  assume j == 2 * i;
  if (i < 100) {
    i := i + 1;
    j := j + 2;
    assert j == 2 * i;
  }
  assert j == 200;
}
