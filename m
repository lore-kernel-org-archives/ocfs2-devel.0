From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:03 2008
Subject: [Ocfs2-devel] [PATCH 23/30] ocfs2: printf fixes
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-24-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

From: Jan Kara <jack@suse.cz>

Explicitely convert loff_t to long long in printf. Just for sure...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6ebc9f9..ed5d523 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -626,7 +626,7 @@ int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_dinode *di,
 
 	mlog(0, "extend inode %llu, i_size = %lld, di->i_clusters = %u, "
 	     "clusters_to_add = %u, extents_to_split = %u\n",
-	     (unsigned long long)OCFS2_I(inode)->ip_blkno, i_size_read(inode),
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno, (long long)i_size_read(inode),
 	     le32_to_cpu(di->i_clusters), clusters_to_add, extents_to_split);
 
 	num_free_extents = ocfs2_num_free_extents(osb, inode, di);
@@ -807,7 +807,7 @@ restarted_transaction:
 	     le32_to_cpu(fe->i_clusters),
 	     (unsigned long long)le64_to_cpu(fe->i_size));
 	mlog(0, "inode: ip_clusters=%u, i_size=%lld\n",
-	     OCFS2_I(inode)->ip_clusters, i_size_read(inode));
+	     OCFS2_I(inode)->ip_clusters, (long long)i_size_read(inode));
 
 leave:
 	if (handle) {
-- 
1.5.3.6
