From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 26 May 2011 17:56:25 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: No need to hangup cluster on hard
	readonly mount
In-Reply-To: <4DDE2000.3000301@oracle.com>
References: <4DDE2000.3000301@oracle.com>
Message-ID: <1306403785-15235-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As no cluster service in hard readonly mount, so skip hangup
cluster, otherwise ocfs2_stack_driver_put will hit BUG_ON.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 5a521c7..395b26f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1973,7 +1973,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	 * If we failed before we got a uuid_str yet, we can't stop
 	 * heartbeat.  Otherwise, do it.
 	 */
-	if (!mnt_err && !ocfs2_mount_local(osb) && osb->uuid_str)
+	if (!mnt_err && !ocfs2_mount_local(osb) && osb->uuid_str &&
+	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
 	if (osb->cconn)
-- 
1.7.4.4
