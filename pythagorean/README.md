## Pythagorean Triples

Pythagorean triples are positive integers a,b,c such that a^2 + b^2 = c^2.
If a, b and c are coprime, they form a **primitive pythagorean triple**.

``pythag.c`` reads pairs of coprime integers from a file, or the standard input, and prints primitive pythagorean triples. To generate a list of coprime integers, see the coprime/ directory.

      make
      ./pythag coprime_list.txt

or

      ../coprime/coprime | ./pythag


