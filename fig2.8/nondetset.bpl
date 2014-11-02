// Race instrumentation
var rdExistsA : bool;
var rdOffsetA : int;
var wrExistsA : bool;
var wrOffsetA : int;

// Race logging and checking procedures
procedure {:inline 1} LogRdA(offset : int, P : bool)
  modifies rdExistsA, rdOffsetA;
{
  if (P) {
    if (*) {
      rdExistsA := true;
      rdOffsetA := offset;
    }
  }
}

procedure {:inline 1} ChkRdA(offset: int, P : bool) {
  assert (P && wrExistsA ==> wrOffsetA != offset);
}

procedure {:inline 1} LogWrA(offset : int, P : bool)
  modifies wrExistsA, wrOffsetA;
{
  if (P) {
    if (*) {
      wrExistsA := true;
      wrOffsetA := offset;
    }
  } 
}

procedure {:inline 1} ChkWrA(offset : int, P : bool)
{
  assert (P && wrExistsA ==> wrOffsetA != offset);
  assert (P && rdExistsA ==> rdOffsetA != offset);  
}

procedure {:inline 1} Barrier(P$1 : bool, P$2 : bool)
{
  assert P$1 == P$2;
  assume(P$1 ==> !rdExistsA && !wrExistsA);
}
