From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Jun  8 04:11:42 2004
Subject: [Ocfs2-devel] OCFS2 performance benchmark on IA32
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65EED@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	We have run some file system performance benchmark on the latest
version of OCFS2 on IA32 platform. We got the data and compared it with
the EXT3 file system. We have only tried the single node setting by now.
We will give out dual-node benchmark result soon.

Benchmark Environment:
OCFS2 svn 1022
Kernel 2.6.6-mm5
Platform	 P3 900G with 256M
IDE Hard Disk (7200 r/sec)
Only 1 node in the cluster

Benchmark Tools:
iozone 3.217

Benchmark Tool Configuration:
We ran a subset of the benchmark tests provided in iozone. They are
"write/re-write", "read/re-read", "random read/random write", "Backward
read", "Record Re-write" and "Stride Read".

Benchmark Results:
The result files are too large. They are in the waiting list for the
approval from the mailing list owner.

Summary:
In general, the performance of OCFS2 in a single node system is much
lower than that of the ext3, especially in the file read operation. The
throughput is approximately 1000 times slower in some random read cases
than that in ext3.

1. Write/Re-write
The throughput difference in write operation is from 1 time to 10 times.
The performance of OCFS2 is not smooth when the file size and record
size change. It drops sharply when the file size is between 2k and 8k or
is larger than 16k, while ext3 appears much smooth.
The throughput difference in re-write operation is less than 1 time,
whatever the size of the file and records are.

2. Read/Re-read
The throughput of OCFS2 is 100 times slower than that of ext3 if the
file size is larger than 128 bytes. The buffer cache can only do help to
tiny file.
There is no much performance gain in the re-read operation.

3. Random Read/Random Write
The throughput of random write operation in OCFS2 is very close to the
re-write operation, which is acceptable.
The throughput of random read is even much worse than the read/re-read
operation. It is up to 1000 times slower than that of ext3.

4. Backward Read
Just the same as Random Read

5. Record Rewrite
This test shows the best performance of OCFS2. The throughput is almost
the same as that of ext3.

6. Stride Read
The performance is a little better than Random Read operation. But the
drop compared with ext3 is still from 200 to 600 times.



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 
