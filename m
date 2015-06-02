From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 2 Jun 2015 15:47:56 +0800
Subject: [Ocfs2-devel] ocfs2 inconsistent when updating journal superblock
	failed
Message-ID: <556D5FAC.20702@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-ext4@vger.kernel.org

Hi all,
If jbd2 has failed to update superblock because of iscsi link down, it
may cause ocfs2 inconsistent.

kernel version: 3.0.93
dmesg:
JBD2: I/O error detected when updating journal superblock for
dm-41-36.

Case description:
Node 1 was doing the checkpoint of global bitmap.
ocfs2_commit_thread
  ocfs2_commit_cache
    jbd2_journal_flush
      jbd2_cleanup_journal_tail
        jbd2_journal_update_superblock
          sync_dirty_buffer
            submit_bh  *failed*
Since the error was ignored, jbd2_journal_flush would return 0.
Then ocfs2_commit_cache thought it normal, incremented trans id and woke
downconvert thread.
So node 2 could get the lock because the checkpoint had been done
successfully (in fact, bitmap on disk had been updated but journal
superblock not). Then node 2 did the update to global bitmap as normal.
After a while, node 2 found node 1 down and began the journal recovery.
As a result, the new update by node 2 would be overwritten and filesystem
became inconsistent.

I'm not sure if ext4 has the same case (can it be deployed on LUN?).
But for ocfs2, I don't think the error can be omitted.
Any ideas about this?

Thanks,
Joseph
