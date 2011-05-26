From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 26 May 2011 17:58:15 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Get readonly dentry lock on hard
	readonly mount
In-Reply-To: <4DDE2000.3000301@oracle.com>
References: <4DDE2000.3000301@oracle.com>
Message-ID: <1306403895-15331-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As some readonly operations such as ls, cat are allowed to
run on hard readonly mount, so change return value to 0 to
allow them to get fake readonly dentry lock.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/dlmglue.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 717f8d3..da103f5 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2634,8 +2634,11 @@ int ocfs2_dentry_lock(struct dentry *dentry, int ex)
 
 	BUG_ON(!dl);
 
-	if (ocfs2_is_hard_readonly(osb))
-		return -EROFS;
+	if (ocfs2_is_hard_readonly(osb)) {
+		if (ex)
+			return -EROFS;
+		return 0;
+	}
 
 	if (ocfs2_mount_local(osb))
 		return 0;
@@ -2653,7 +2656,7 @@ void ocfs2_dentry_unlock(struct dentry *dentry, int ex)
 	struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
 	struct ocfs2_super *osb = OCFS2_SB(dentry->d_sb);
 
-	if (!ocfs2_mount_local(osb))
+	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb))
 		ocfs2_cluster_unlock(osb, &dl->dl_lockres, level);
 }
 
-- 
1.7.4.4
