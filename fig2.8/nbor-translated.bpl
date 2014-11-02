// Two-thread reduction introduce 2 arbitrary threads
var tid$1 : int;
var tid$2 : int;

// Assume there are N threads in total
const N : int;
axiom N == 8;

// Shared state abstraction removes declaration of array A
// Two-thread reduction dualises scalar formal i
procedure nbor(i$1 : int, i$2 : int, n$1 : int, n$2 : int, P$1 : bool, P$2 : bool)
  // Ensure threads are in range and distinct
  requires 0 <= tid$1 && tid$1 < N;
  requires 0 <= tid$2 && tid$2 < N;
  requires tid$1 != tid$2;
  // Scalar formals initially equal
  requires i$1 == i$2;
  requires n$1 == n$2;
  // Clear read/write sets
  requires !rdExistsA && !wrExistsA;
  // Predication assumes enabledness
  requires P$1 && P$2;
{
  // Dualised local variables
  var v$1, v$2 : int;
  var w$1, w$2 : int;

  // Fresh Predicates
  var Q$1, Q$2 : bool;

  // Arbitrary values
  var arbitrary$1, arbitrary$2 : int;

  // Translation of "v = 0"
  v$1 := if P$1 then 0 else v$1;
  v$2 := if P$2 then 0 else v$2;

  // Translation of if-statement
  Q$1 := P$1 && (tid$1 + i$1 < n$1);
  Q$2 := P$2 && (tid$2 + i$2 < n$2);
  //   Translation of "v = A[tid+i]"
  call LogRdA(tid$1 + i$1, Q$1);
  call ChkRdA(tid$2 + i$2, Q$2);
  havoc arbitrary$1, arbitrary$2;
  v$1 := if Q$1 then arbitrary$1 else v$1;
  v$2 := if Q$2 then arbitrary$2 else v$2;

  // Translation of "w = A[tid]"
  call LogRdA(tid$1, P$1);
  call ChkRdA(tid$2, P$2);
  havoc arbitrary$1, arbitrary$2;
  w$1 := if P$1 then arbitrary$1 else w$1;
  w$2 := if P$2 then arbitrary$2 else w$2;
 
  // Uncommenting this barrier fixes the race
  // call Barrier(P$1, P$2);

  // Translation of "A[tid] = v + w"
  call LogWrA(tid$1, P$1);
  call ChkWrA(tid$2, P$2);
  // write to A[tid] is no-op
}
