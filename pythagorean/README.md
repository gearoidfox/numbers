## Pythagorean Triples

Pythagorean triples are positive integers a,b,c such that a^2 + b^2 = c^2.
If a, b and c are coprime, they form a **primitive pythagorean triple**.

``pythag.c`` reads pairs of coprime integers from a file, or the standard input, and prints primitive pythagorean triples. To generate coprime integers, see the ``coprime/`` directory.

# Usage:

      make
      ./pythag [filename]
      
Where ``[filename]`` is the path to a file containing one pair of whitespace-separated coprime integers per line.

You can also pipe the output of ``coprime`` directly into ``pythag``:

      ../coprime/coprime | ./pythag


