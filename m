From: Jan Kara <jack@suse.cz>
Date: Tue,  1 Aug 2017 16:12:51 +0200
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Make ocfs2_set_acl() static
In-Reply-To: <20170801141252.19675-1-jack@suse.cz>
References: <20170801141252.19675-1-jack@suse.cz>
Message-ID: <20170801141252.19675-2-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The function is never called outside of fs/ocfs2/acl.c.

CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/acl.c | 2 +-
 fs/ocfs2/acl.h | 7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index dc22ba8c710f..3b9c3638a381 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -221,7 +221,7 @@ static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
 /*
  * Set the access or default ACL of an inode.
  */
-int ocfs2_set_acl(handle_t *handle,
+static int ocfs2_set_acl(handle_t *handle,
 			 struct inode *inode,
 			 struct buffer_head *di_bh,
 			 int type,
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 2783a75b3999..7be0bb756286 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -28,13 +28,6 @@ struct ocfs2_acl_entry {
 
 struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type);
 int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-int ocfs2_set_acl(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *di_bh,
-			 int type,
-			 struct posix_acl *acl,
-			 struct ocfs2_alloc_context *meta_ac,
-			 struct ocfs2_alloc_context *data_ac);
 extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
 			  struct buffer_head *, struct buffer_head *,
-- 
2.12.3
