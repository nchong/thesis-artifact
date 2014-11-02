// Race instrumentation
var rdSet : [int]bool;
var wrSet : [int]bool;

// Race logging and checking procedures
procedure {:inline 1} LogRdA(offset : int, P : bool)
  modifies rdSet;
{
  rdSet[offset] := P;
}

procedure {:inline 1} ChkRdA(offset: int, P : bool) {
  assert (P ==> !wrSet[offset]);
}

procedure {:inline 1} LogWrA(offset : int, P : bool)
  modifies wrSet;
{
  wrSet[offset] := P;
}

procedure {:inline 1} ChkWrA(offset : int, P : bool)
{
  assert (P ==> !rdSet[offset]);
  assert (P ==> !wrSet[offset]);  
}

procedure {:inline 1} Barrier(P$1 : bool, P$2 : bool)
{
  assert P$1 == P$2;
  assume(P$1 ==> (forall x : int :: !rdSet[x]));
  assume(P$1 ==> (forall x : int :: !wrSet[x]));
}
