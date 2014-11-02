procedure A()
{
  var i,x,y,z,temp : int;
  i := 0;
  x := 1; y := 2; z := 3;
  while (i < 10000)
    invariant _c0 ==> i == 0;
    invariant _c1 ==> i != 0;
    invariant _c2 ==> 0 <= i;
    invariant _c3 ==> 0 < i;
    invariant _c4 ==> i < 10000;
    invariant _c5 ==> i <= 10000;
    invariant _c6 ==> x != y;
  {
    temp := x; x := y;
    i := i + 1;
  }
}

const {:stage_id 0} {:existential true} _c0: bool;
const {:stage_id 0} {:existential true} _c1: bool;
const {:stage_id 0} {:existential true} _c2: bool;
const {:stage_id 0} {:existential true} _c3: bool;
const {:stage_id 0} {:existential true} _c4: bool;
const {:stage_id 0} {:existential true} _c5: bool;
const {:stage_id 0} {:existential true} _c6: bool;
