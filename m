From: yangwenfang <vicky.yangwenfang@huawei.com>
Date: Mon, 26 Jan 2015 20:28:36 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2/dlm: support range lock
Message-ID: <54C632F4.3070705@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

What:
Byte range lock is applied to lock a region of a file to accelerate
reading/writing concurrently.

Why:		
Currently ocfs2 does not support byte range lock. Since multiple nodes
may concurrently update/write at different positions of the same file
in database workloads, the performance(tpmc) of DB+ocfs2 is much poorer than
DB+GPFS in running TPCC.
Aiming at improving the efficiency of parallel accesses to the same file,
we have implemented a demo of range lock feature which has been supported
by lustre and GPFS, so that a file can be updated by different nodes in
the cluster when they are visiting different blocks.

How:
Key issues in design and implementation:
1.In ocfs2, each file only has one lock, which is incapable of telling
different position.
One solution is to add a range field (start,end) in a lock. For example:
-ocfs2_lock_res(N1)	      dlm_lock_resource(Master)	ocfs2_lock_res(N2)
-ocfs2_res_range_lock (0,9)----dlm_lock(0,9)    N1			
-				dlm_lock(10,19)  N2<--ocfs2_res_range_lock(10,19)
-ocfs2_res_range_lock (20,29)---dlm_lock(20,29)  N1			
-				dlm_lock(30,49)  N2<--ocfs2_res_range_lock(30,49)
-ocfs2_res_range_lock (50,59)---dlm_lock(50,59)  N1			
-				dlm_lock(60,69)  N2<--ocfs2_res_range_lock(60,69)

Each lock resource deploys an interval tree to manage the range, which
supports basic operations like add, delete, insert, find, split and merge.
The most important issue is to determine the existance of conflicts
among the ranges. Conflict-free ranges of the same file can be accessed
concurrently. In the contrary, nodes must wait for the release of a
conflicted lock before accessing the range of file.

Byte range lock supports split and merge rules: for same level, larger
scope; different level, write > read(If a node keeps EX lock with
range(start,end), then it has PR range lock(start,end)).
For example:
(1) merge: N1 keeps range lock (0,9)PR and (5,19)PR, the lock is merged into
(0,19) PR;
(2) merge: N1 keeps range lock (0,9)PR and (5,19)EX, the merged lock should
become(0,19) PR, (5,19)EX;
(3) split: N1 keeps range lock (0,9)PR, N2 tries to lock(0,5) PR, N1 should
split the lock and keep (6,9)PR.

2.In ocfs2, there are only three types of lock resources: rw, inode and open
which provide protections to different contents.
We need to add another lock resource(ip_range_lock_lockres) to protect
different ranges in IO read/write process.
For example: buffer read/write.
(1)ocfs2_file_aio_write	------------->ocfs2_file_aio_write
	ocfs2_rw_lock(ex)		ocfs2_rw_lock(pr)
					ocfs2_range_lock(start, end, ex)
	ocfs2_write_begin
		ocfs2_inode_lock(ex)    ocfs2_inode_lock(pr)
					if append, update to ex;
(2)ocfs2_file_aio_read---------------> no need to change.
	ocfs2_readpage
		ocfs2_inode_lock(pr)
(3)but it is a problem in read_ahead.
	ocfs2_readpages------------------>ocfs2_readpages
	ocfs2_inode_lock(pr)		ocfs2_inode_lock(pr)
					ocfs2_range_lock(start, end, pr)
																	
Limitations based on our assumption:
1.Byte range lock is only beneficial for update write.
2.Too many locks because of delayed unlock.
3.Significant source code modification is necessitated, involving almost the
whole dlmglue and dlm modules.

As described above, there are also many limitations base on our assumption.
Many thanks for any advice.

thanks.
