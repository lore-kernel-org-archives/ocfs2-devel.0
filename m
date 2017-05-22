From: Gang He <ghe@suse.com>
Date: Mon, 22 May 2017 10:15:05 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: give an obvious tip for dismatch
	cluster names
Message-ID: <1495419305-3780-1-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

This patch is used to add an obvious error message, due to
dismatch cluster names between on-disk and in the current cluster.
We can meet this case during OCFS2 cluster migration, if we can
give the user an obvious tip for why they can not mount the file
system after migration, they can quickly fix this dismatch problem.
Second, also move printing ocfs2_fill_super() errno to the front
of ocfs2_dismount_volume() function, since ocfs2_dismount_volume()
will also print it's own message.
Compare with initial version, we only print this error tip when
the user uses pcmk stack. since in o2cb stack, the user will not
meet this error.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ca1646f..fc25d4a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1208,14 +1208,15 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 read_super_error:
 	brelse(bh);
 
+	if (status)
+		mlog_errno(status);
+
 	if (osb) {
 		atomic_set(&osb->vol_state, VOLUME_DISABLED);
 		wake_up(&osb->osb_mount_event);
 		ocfs2_dismount_volume(sb, 1);
 	}
 
-	if (status)
-		mlog_errno(status);
 	return status;
 }
 
@@ -1843,6 +1844,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
+		if (status == -EBADR && ocfs2_userspace_stack(osb))
+			mlog(ML_ERROR, "couldn't mount because cluster name on"
+			" disk does not match the running cluster name.\n");
 		goto leave;
 	}
 
-- 
1.8.5.6
