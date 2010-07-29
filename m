From: Jan Kara <jack@suse.cz>
Date: Thu, 29 Jul 2010 14:00:46 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Remove ocfs2_sync_inode()
In-Reply-To: <1280404846-9388-1-git-send-email-jack@suse.cz>
References: <1280404846-9388-1-git-send-email-jack@suse.cz>
Message-ID: <1280404846-9388-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_sync_inode() is used only from ocfs2_sync_file(). But all data has
already been written before calling ocfs2_sync_file() and ocfs2 doesn't use
inode's private_list for tracking metadata buffers thus sync_mapping_buffers()
is superfluous as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5659d85..2e341a2 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -64,12 +64,6 @@
 
 #include "buffer_head_io.h"
 
-static int ocfs2_sync_inode(struct inode *inode)
-{
-	filemap_fdatawrite(inode->i_mapping);
-	return sync_mapping_buffers(inode->i_mapping);
-}
-
 static int ocfs2_init_file_private(struct inode *inode, struct file *file)
 {
 	struct ocfs2_file_private *fp;
@@ -187,10 +181,6 @@ static int ocfs2_sync_file(struct file *file, int datasync)
 	mlog_entry("(0x%p, 0x%p, %d, '%.*s')\n", file, dentry, datasync,
 		   dentry->d_name.len, dentry->d_name.name);
 
-	err = ocfs2_sync_inode(dentry->d_inode);
-	if (err)
-		goto bail;
-
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC)) {
 		/*
 		 * We still have to flush drive's caches to get data to the
-- 
1.6.4.2
