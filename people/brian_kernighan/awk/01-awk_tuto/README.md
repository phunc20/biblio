

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
[phunc20@T460p 01-awk_tuto]$
```
**Note.**
1. `space_emp.data` contains exactly the same data as `emp.data` with the `\t` replaced by
   (different) numbers of spaces on each line. Note that the same `awk` command works
   for both data files.
    - Other softwares may not exhibit the same behaviour as `awk`, e.g. `pandas` seems to be
      unable to easily deal with inhomogeneous number of spaces.
      ```python
      In [2]: pd.read_csv("emp.data", names=["name", "rate", "hr"])
      Out[2]:
                    name  rate  hr
      0    Beth\t4.00\t0   NaN NaN
      1     Dan\t3.75\t0   NaN NaN
      2  Kathy\t4.00\t10   NaN NaN
      3   Mark\t5.00\t20   NaN NaN
      4   Mary\t5.50\t22   NaN NaN
      5  Susie\t4.25\t18   NaN NaN
      
      In [3]: pd.read_csv("emp.data", sep="\t", names=["name", "rate", "hr"])
      Out[3]:
          name  rate  hr
      0   Beth  4.00   0
      1    Dan  3.75   0
      2  Kathy  4.00  10
      3   Mark  5.00  20
      4   Mary  5.50  22
      5  Susie  4.25  18
      
      In [4]: pd.read_csv("space_emp.data", names=["name", "rate", "hr"])
      Out[4]:
                       name  rate  hr
      0   Beth    4.00    0   NaN NaN
      1   Dan     3.75    0   NaN NaN
      2  Kathy   4.00    10   NaN NaN
      3  Mark    5.00    20   NaN NaN
      4  Mary    5.50    22   NaN NaN
      5  Susie   4.25    18   NaN NaN
      
      In [5]: pd.read_csv("space_emp.data", sep=" ", names=["name", "rate", "hr"])
      ParserError: Error tokenizing data. C error: Expected 9 fields in line 2, saw 10
      ```
1. The number of spaces inside the `awk` command is indifferent:
   ```bash
   [phunc20@T460p 01-awk_tuto]$ awk '$3 > 0 { print $1, $2 * $3 }' emp.data
   Kathy 40
   Mark 100
   Mary 121
   Susie 76.5
   [phunc20@T460p 01-awk_tuto]$
   ```
