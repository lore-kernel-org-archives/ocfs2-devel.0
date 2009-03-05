From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Date: Thu, 05 Mar 2009 08:25:50 -0000
Subject: [Ocfs2-devel] [PATCH] OCFS2: Pagecache usage optimization on OCFS2
Message-ID: <6.0.0.20.2.20090305172216.06b83408@172.19.0.2>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi.

I introduced "is_partially_uptodate" aops for OCFS2.

A page can have multiple buffers and even if a page is not uptodate, some buffers 
can be uptodate on pagesize != blocksize environment.
This aops checks that all buffers which correspond to a part of a file 
that we want to read are uptodate. If so, we do not have to issue actual 
read IO to HDD even if a page is not uptodate because the portion we 
want to read are uptodate. 
"block_is_partially_uptodate" function is already used by ext2/3/4.
With the following patch random read/write mixed workloads or random read after 
random write workloads can be optimized and we can get performance improvement.

I did a performance test using the sysbench.

#sysbench --num-threads=16 --max-requests=150000 --test=fileio --file-num=1 
--file-block-size=8K --file-total-size=1G --file-test-mode=rndrw 
--file-fsync-freq=0 --file-rw-ratio=0.5  run

-2.6.29-rc7
Test execution summary:
    total time:                          82.3114s
    total number of events:              150000
    total time taken by event execution: 989.1867
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0066s
         max:                            0.4400s
         approx.  95 percentile:         0.0417s

Threads fairness:
    events (avg/stddev):           9375.0000/257.65
    execution time (avg/stddev):   61.8242/0.01


-2.6.29-rc7-patched
Test execution summary:
    total time:                          71.9416s
    total number of events:              150000
    total time taken by event execution: 845.7592
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0056s
         max:                            0.5892s
         approx.  95 percentile:         0.0374s

Threads fairness:
    events (avg/stddev):           9375.0000/263.46
    execution time (avg/stddev):   52.8600/0.01


arch: ia64
pagesize: 16k
blocksize: 4k

Please merge following patch.
Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.29-rc7.org/fs/ocfs2/aops.c linux-2.6.29-rc7/fs/ocfs2/aops.c
--- linux-2.6.29-rc7.org/fs/ocfs2/aops.c	2009-03-05 13:46:07.000000000 +0900
+++ linux-2.6.29-rc7/fs/ocfs2/aops.c	2009-03-05 13:50:59.000000000 +0900
@@ -1953,15 +1953,16 @@ static int ocfs2_write_end(struct file *
 }
 
 const struct address_space_operations ocfs2_aops = {
-	.readpage	= ocfs2_readpage,
-	.readpages	= ocfs2_readpages,
-	.writepage	= ocfs2_writepage,
-	.write_begin	= ocfs2_write_begin,
-	.write_end	= ocfs2_write_end,
-	.bmap		= ocfs2_bmap,
-	.sync_page	= block_sync_page,
-	.direct_IO	= ocfs2_direct_IO,
-	.invalidatepage	= ocfs2_invalidatepage,
-	.releasepage	= ocfs2_releasepage,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ocfs2_readpage,
+	.readpages		= ocfs2_readpages,
+	.writepage		= ocfs2_writepage,
+	.write_begin		= ocfs2_write_begin,
+	.write_end		= ocfs2_write_end,
+	.bmap			= ocfs2_bmap,
+	.sync_page		= block_sync_page,
+	.direct_IO		= ocfs2_direct_IO,
+	.invalidatepage		= ocfs2_invalidatepage,
+	.releasepage		= ocfs2_releasepage,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate	= block_is_partially_uptodate,
 };
