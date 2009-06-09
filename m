From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Date: Tue, 09 Jun 2009 07:52:46 -0000
Subject: [Ocfs2-devel] [PATCH] OCFS2: fdatasync should skip unimportant
 metadata writeout
Message-ID: <6.0.0.20.2.20090609154314.0729f488@172.19.0.2>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi.

In ocfs2, fdatasync and fsync are identical.
I think fdatasync should skip committing transaction when 
inode->i_state is set just I_DIRTY_SYNC and this indicates
only atime or/and mtime updates.
Following patch improves fdatasync throughput.

#sysbench --num-threads=16 --max-requests=300000 --test=fileio 
--file-block-size=4K --file-total-size=16G --file-test-mode=rndwr 
--file-fsync-mode=fdatasync run

Results:
-2.6.30-rc8
Test execution summary:
    total time:                          107.1445s
    total number of events:              119559
    total time taken by event execution: 116.1050
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0010s
         max:                            0.1220s
         approx.  95 percentile:         0.0016s

Threads fairness:
    events (avg/stddev):           7472.4375/303.60
    execution time (avg/stddev):   7.2566/0.64


-2.6.30-rc8-patched
Test execution summary:
    total time:                          86.8529s
    total number of events:              300016
    total time taken by event execution: 24.3077
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0001s
         max:                            0.0336s
         approx.  95 percentile:         0.0001s

Threads fairness:
    events (avg/stddev):           18751.0000/718.75
    execution time (avg/stddev):   1.5192/0.05 


Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.30-rc8.org/fs/ocfs2/file.c linux-2.6.30-rc8.ocfs2/fs/ocfs2/file.c
--- linux-2.6.30-rc8.org/fs/ocfs2/file.c	2009-06-04 16:26:26.000000000 +0900
+++ linux-2.6.30-rc8.ocfs2/fs/ocfs2/file.c	2009-06-09 13:50:42.000000000 +0900
@@ -187,6 +187,9 @@ static int ocfs2_sync_file(struct file *
 	if (err)
 		goto bail;
 
+	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+		goto bail;
+
 	journal = osb->journal->j_journal;
 	err = jbd2_journal_force_commit(journal);
 
