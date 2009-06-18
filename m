From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Jun 2009 18:52:25 -0700
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: fdatasync should skip unimportant
	metadata writeout
In-Reply-To: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
References: <1245289946-17136-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1245289946-17136-8-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

Mainline commit e04cc15f52eb072937cec2bbd8499f37afe5e1ef

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

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 267389c..1204656 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -189,6 +189,9 @@ static int ocfs2_sync_file(struct file *file,
 	if (err)
 		goto bail;
 
+	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
+		goto bail;
+
 	journal = osb->journal->j_journal;
 	err = journal_force_commit(journal);
 
-- 
1.6.0.4
