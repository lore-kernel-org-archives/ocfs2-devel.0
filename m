From: Tiger Yang <tiger.yang@oracle.com>
Date: Sun,  2 Nov 2008 19:04:21 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add search result checking in
	block_get
Message-ID: <1225623861-6394-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Because ocfs2_xattr_block_find may return zero when not found
the xattr entry, and struct ocfs2_xattr_search may have not
be initialized. So check the search result is necessary to
avoid access NULL pointer.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 70baffe..054e2ef 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -777,6 +777,11 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 		goto cleanup;
 	}
 
+	if (xs->not_found) {
+		ret = -ENODATA;
+		goto cleanup;
+	}
+
 	xb = (struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
 	size = le64_to_cpu(xs->here->xe_value_size);
 	if (buffer) {
@@ -860,7 +865,7 @@ static int ocfs2_xattr_get(struct inode *inode,
 	down_read(&oi->ip_xattr_sem);
 	ret = ocfs2_xattr_ibody_get(inode, name_index, name, buffer,
 				    buffer_size, &xis);
-	if (ret == -ENODATA)
+	if (ret == -ENODATA && di->i_xattr_loc)
 		ret = ocfs2_xattr_block_get(inode, name_index, name, buffer,
 					    buffer_size, &xbs);
 	up_read(&oi->ip_xattr_sem);
-- 
1.5.4.1
