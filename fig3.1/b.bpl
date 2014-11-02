// Obsfuscated assignment [m := n] by bit-twiddling.

function {:bvbuiltin "bvadd"}  BV_ADD(bv8, bv8) : bv8;
function {:bvbuiltin "bvsub"}  BV_SUB(bv8, bv8) : bv8;
function {:bvbuiltin "bvand"}  BV_AND(bv8, bv8) : bv8;
function {:bvbuiltin "bvlshr"} BV_LSHR(bv8, bv8) : bv8;
function {:bvbuiltin "bvugt"}  BV_UGT(bv8, bv8) : bool;
function {:bvbuiltin "bvshl"}  BV_SHL(bv8, bv8) : bv8;
function {:bvbuiltin "bvuge"}  BV_UGE(bv8, bv8) : bool;
function {:bvbuiltin "bvule"}  BV_ULE(bv8, bv8) : bool;
function {:bvbuiltin "bvor"}   BV_OR(bv8, bv8) : bv8;

procedure B(v:bv8) 
{
  var n, m, i : bv8;
  n := v; m := 0bv8; i := 0bv8;
  while (n != 0bv8)
    invariant n == BV_LSHR(v, i);
    invariant m == BV_AND(v, BV_SUB(BV_SHL(1bv8,i),1bv8));
  {
    if (BV_AND(n, 1bv8) == 1bv8) {
      m := BV_OR(m, BV_SHL(1bv8, i));
    }
    i := BV_ADD(i, 1bv8);
    n := BV_LSHR(n, 1bv8);
  }
  assert m == v;
}
