From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu Jun 10 22:56:02 2004
Subject: [Ocfs2-devel] 
	The benchmark data of OCFS2 svn(1022) directory operations on an
	IA32 platform under kernel 2.6.6-mm5
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65EF4@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Followings are the benchmark data of OCFS2 directory operations. The
throughput to remove the directory is very slow in contrast to the
create operation. 

The benchmark environment is:
Plarform: P4 1900M with 256M memory.
Hard Disk: 7200 r/sec
OS: kernel 2.6.6-mm5
Benchmark tool: dir_bench.tar.gz ( see the attachment)

Result:
OCFS2
------------------------------------------
Start to benchmark create directory...
Result: 865.077698 (dirs/sec)
Start to benchmark rename directory...
Result: 131.857971 (dirs/sec)
Start to benchmark remove directory...
Result: 18.311045 (dirs/sec)
------------------------------------------

ext3
------------------------------------------
Start to benchmark create directory...
Result: 6469.385742 (dirs/sec)
Start to benchmark rename directory...
Result: 3964.775146 (dirs/sec)
Start to benchmark remove directory...
Result: 32505.585938 (dirs/sec)
------------------------------------------


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-------------- next part --------------
A non-text attachment was scrubbed...
Name: dir_bench.tar.gz
Type: application/x-gzip
Size: 1021 bytes
Desc: dir_bench.tar.gz
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040611/c7a35e41/dir_bench.tar.bin
