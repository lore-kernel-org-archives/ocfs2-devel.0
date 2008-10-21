From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 20 Oct 2008 19:08:16 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: Check errors from
	ocfs2_xattr_update_xattr_search()
In-Reply-To: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
References: <1224554898-3928-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1224554898-3928-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2_xattr_update_xattr_search() function can return an error when
trying to read blocks off of disk.  The caller needs to check this error
before using those (possibly invalid) blocks.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ec262ef..90cd7d0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2812,7 +2812,11 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	if (data_bh)
 		ocfs2_journal_dirty(handle, data_bh);
 
-	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
+	ret = ocfs2_xattr_update_xattr_search(inode, xs, xb_bh, xh_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
 
 	/* Change from ocfs2_xattr_header to ocfs2_xattr_tree_root */
 	memset(&xb->xb_attrs, 0, inode->i_sb->s_blocksize -
-- 
1.5.6.5
