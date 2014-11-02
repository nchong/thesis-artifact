// Race instrumentation
var trOffset  : int;
var tracking  : bool;
var rdExistsA : bool;
var wrExistsA : bool;

// Race logging and checking procedures
procedure {:inline 1} LogRdA(offset : int, P : bool)
  modifies rdExistsA;
{
  if (P && tracking && trOffset == offset) {
    rdExistsA := true;
  }
}

procedure {:inline 1} ChkRdA(offset: int, P : bool) {
  assert (P && wrExistsA ==> trOffset != offset);
}

procedure {:inline 1} LogWrA(offset : int, P : bool)
  modifies wrExistsA;
{
  if (P && tracking && trOffset == offset) {
    wrExistsA := true;
  } 
}

procedure {:inline 1} ChkWrA(offset : int, P : bool)
{
  assert (P && wrExistsA ==> trOffset != offset);
  assert (P && rdExistsA ==> trOffset != offset);  
}

procedure {:inline 1} Barrier(P$1 : bool, P$2 : bool)
  modifies tracking;
{
  assert P$1 == P$2;
  havoc tracking;
  assume(P$1 ==> !rdExistsA && !wrExistsA);
}
