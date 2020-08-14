# Bond Script

create or delete bond interface in Linux

## usage

```bash
-a                   add bond interface
-d                   delete bond interface, must be with -n and -s
-n <name>            The name of bond interface
-m <mode>            The mode of bond interface, balance-rr, active-backup, balance-xor, broadcast, 802.3ad, balance-tlb, balance-alb
-s <slave_list>      The slave interface list of bond, split by ',' like 'eth12,eth13'
-h                   Print this message
```

example：
```bash
# add a bond interface bond1
./bond.sh -a -n bond1 -s "eth1,eth2"

# delete a bond interface bond1
./bond.sh -d -n bond1 -s "eth1,eth2"
```
