From: jiangyiwen <jiangyiwen@huawei.com>
Date: Wed, 23 Dec 2015 18:23:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix slot overwritten if storage link
	down during mount
Message-ID: <567A7628.5040503@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following case will lead to slot overwritten.

N1                               N2
mount ocfs2 volume, find and
allocate slot 0, then set
osb->slot_num to 0, begin to
write slot info to disk
                                 mount ocfs2 volume, wait for super lock
write block fail because of
storage link down, unlock
super lock
                                 got super lock and also allocate slot 0
                                 then unlock super lock

mount fail and then dismount,
since osb->slot_num is 0, try to
put invalid slot to disk. And it
will succeed if storage link
restores.
                                 N2 slot info is now overwritten

Once another node say N3 mount, it will find and allocate slot 0 again,
which will lead to mount hung because journal has already been locked
by N2. so when write slot info failed, invalidate slot in advance to
avoid overwrite slot.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/slot_map.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 47bba1b..cad50f0 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -502,8 +502,17 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	trace_ocfs2_find_slot(osb->slot_num);

 	status = ocfs2_update_disk_slot(osb, si, osb->slot_num);
-	if (status < 0)
+	if (status < 0) {
 		mlog_errno(status);
+		/*
+		 * if write block failed, invalidate slot to avoid overwrite slot during
+		 * dismount in case another node rightly has mounted
+		 */
+		spin_lock(&osb->osb_lock);
+		ocfs2_invalidate_slot(si, osb->slot_num);
+		osb->slot_num = OCFS2_INVALID_SLOT;
+		spin_unlock(&osb->osb_lock);
+	}

 bail:
 	return status;
-- 
1.8.4.3
