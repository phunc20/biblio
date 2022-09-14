

```bash
[phunc20@T460p 01-awk_tuto]$ awk '$3>0 {print $1, $2*$3}' emp.data
Kathy 40
Mark 100
Mary 121
Susie 76.5
[phunc20@T460p 01-awk_tuto]$ awk '$3>0 {print $1, $2*$3}' space_emp.data
Kathy 40
Mark 100
Mary 121
Susie 76.5
```
**Note.**
1. `space_emp.data` contains exactly the same data as `emp.data` with the `\t` replaced by
   (different) numbers of spaces on each line. Note that the same `awk` command works
   for both data files.
1. The spaces inside the `awk` command is indifferent:
   ```bash
   [phunc20@T460p 01-awk_tuto]$ awk '$3 > 0 { print $1, $2 * $3 }' emp.data
   Kathy 40
   Mark 100
   Mary 121
   Susie 76.5
   [phunc20@T460p 01-awk_tuto]$
   ```
