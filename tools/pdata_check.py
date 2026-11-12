import struct, sys
path = sys.argv[1]
f = open(path, 'rb')
head = f.read(4096)
pe = struct.unpack_from('<I', head, 0x3c)[0]
nsec = struct.unpack_from('<H', head, pe + 6)[0]
optsz = struct.unpack_from('<H', head, pe + 20)[0]
opt = pe + 24
sec = opt + optsz
secs = {}
for i in range(nsec):
    name, vsize, va, rawsize, rawptr = struct.unpack_from('<8sIIII', head, sec + i*40)
    secs[name.rstrip(b'\0').decode()] = (va, vsize, rawptr, rawsize)
va, vsize, rawptr, rawsize = secs['.pdata']
f.seek(rawptr); pdata = f.read(vsize)
n = vsize // 12
entries = [struct.unpack_from('<III', pdata, i*12) for i in range(n)]
inv = sum(1 for i in range(n-1) if entries[i][0] > entries[i+1][0])
overlap = sum(1 for i in range(n-1) if entries[i][1] > entries[i+1][0] and entries[i][0] <= entries[i+1][0])
covered = sum(e[1]-e[0] for e in entries)
tva, tvsize = secs['.text'][0], secs['.text'][1]
print(f"entries={n} inversions={inv} overlaps={overlap} covered={covered:#x} of text={tvsize:#x} ({100*covered/tvsize:.1f}%)")
# first few inversions
shown=0
for i in range(n-1):
    if entries[i][0] > entries[i+1][0] and shown < 5:
        print(f"  inversion at {i}: {entries[i][0]:#x}..{entries[i][1]:#x} then {entries[i+1][0]:#x}"); shown+=1
gaps = []
prev_end = tva
for b, e, u in entries:
    if b > prev_end: gaps.append((b - prev_end, prev_end, b))
    prev_end = max(prev_end, e)
if tva + tvsize > prev_end: gaps.append((tva + tvsize - prev_end, prev_end, tva + tvsize))
gaps.sort(reverse=True)
print("largest gaps:")
for g in gaps[:10]: print(f"  {g[0]:#x} bytes at {g[1]:#x}..{g[2]:#x}")
import collections
buckets = collections.Counter()
for g in gaps:
    k = 16 if g[0] <= 16 else 256 if g[0] <= 256 else 4096 if g[0] <= 4096 else 65536 if g[0] <= 65536 else 1<<40
    buckets[k] += g[0]
print({k: hex(v) for k, v in sorted(buckets.items())})
