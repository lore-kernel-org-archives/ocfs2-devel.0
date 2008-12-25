From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:48 -0800
Subject: [Ocfs2-devel] [PATCH 33/35] ocfs2: calculate and reserve credits
	for xattr value in mknod
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-34-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tiger Yang <tiger.yang@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tiger Yang <tiger.yang@oracle.com>

We extend the credits for xattr's large value in set_value_outside
before, this can give rise to a credits issue when we set one security
entry and two acl entries duing mknod. As we remove extend_trans form
set_value_outside, we must calculate and reserve the credits for
xattr's large value in mknod.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   40 ++++++++++++++++++++++++++--------------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 73fb9f7..e5be470 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -490,9 +490,14 @@ int ocfs2_calc_security_init(struct inode *dir,
 	}
 
 	/* reserve clusters for xattr value which will be set in B tree*/
-	if (si->value_len > OCFS2_XATTR_INLINE_SIZE)
-		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
-							   si->value_len);
+	if (si->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		int new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
+							    si->value_len);
+
+		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+							   new_clusters);
+		*want_clusters += new_clusters;
+	}
 	return ret;
 }
 
@@ -506,9 +511,7 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 {
 	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
-	int s_size = 0;
-	int a_size = 0;
-	int acl_len = 0;
+	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
 	if (si->enable)
 		s_size = ocfs2_xattr_entry_real_size(strlen(si->name),
@@ -556,16 +559,25 @@ int ocfs2_calc_xattr_init(struct inode *dir,
 		*xattr_credits += ocfs2_blocks_per_xattr_bucket(dir->i_sb);
 	}
 
-	/* reserve clusters for xattr value which will be set in B tree*/
-	if (si->enable && si->value_len > OCFS2_XATTR_INLINE_SIZE)
-		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
-							   si->value_len);
+	/*
+	 * reserve credits and clusters for xattrs which has large value
+	 * and have to be set outside
+	 */
+	if (si->enable && si->value_len > OCFS2_XATTR_INLINE_SIZE) {
+		new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
+							si->value_len);
+		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+							   new_clusters);
+		*want_clusters += new_clusters;
+	}
 	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL &&
 	    acl_len > OCFS2_XATTR_INLINE_SIZE) {
-		*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb, acl_len);
-		if (S_ISDIR(mode))
-			*want_clusters += ocfs2_clusters_for_bytes(dir->i_sb,
-								   acl_len);
+		/* for directory, it has DEFAULT and ACCESS two types of acls */
+		new_clusters = (S_ISDIR(mode) ? 2 : 1) *
+				ocfs2_clusters_for_bytes(dir->i_sb, acl_len);
+		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
+							   new_clusters);
+		*want_clusters += new_clusters;
 	}
 
 	return ret;
-- 
1.5.6
