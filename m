From: jiangyiwen <jiangyiwen@huawei.com>
Date: Mon, 25 Jan 2016 10:52:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: use spinlock irqsave for downconvert
 lock in ocfs2_osb_dump()
Message-ID: <56A58DE8.3000207@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

commit a75e9ccabd92("ocfs2: use spinlock irqsave for downconvert lock")
missed an unmodified place in ocfs2_osb_dump(), so it still exists
a deadlock scenario.

    ocfs2_wake_downconvert_thread
    ocfs2_rw_unlock
    ocfs2_dio_end_io
    dio_complete
    .....
    bio_endio
    req_bio_endio
    ....
    scsi_io_completion
    blk_done_softirq
    __do_softirq
    do_softirq
    irq_exit
    do_IRQ
    ocfs2_osb_dump
    cat /sys/kernel/debug/ocfs2/${uuid}/fs_state

This patch will still use spin_lock_irqsave() replace spin_lock() to
solve this situation.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2de4c8a..0623710 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -236,6 +236,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
 	struct ocfs2_orphan_scan *os = &osb->osb_orphan_scan;
 	int i, out = 0;
+	unsigned long flags;

 	out += snprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
@@ -271,14 +272,14 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 				cconn->cc_version.pv_minor);
 	}

-	spin_lock(&osb->dc_task_lock);
+	spin_lock_irqsave(&osb->dc_task_lock, flags);
 	out += snprintf(buf + out, len - out,
 			"%10s => Pid: %d  Count: %lu  WakeSeq: %lu  "
 			"WorkSeq: %lu\n", "DownCnvt",
 			(osb->dc_task ?  task_pid_nr(osb->dc_task) : -1),
 			osb->blocked_lock_count, osb->dc_wake_sequence,
 			osb->dc_work_sequence);
-	spin_unlock(&osb->dc_task_lock);
+	spin_unlock_irqrestore(&osb->dc_task_lock, flags);

 	spin_lock(&osb->osb_lock);
 	out += snprintf(buf + out, len - out, "%10s => Pid: %d  Nodes:",
-- 
1.8.4.3
