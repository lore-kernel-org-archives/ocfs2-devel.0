From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 25 Feb 2010 22:00:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: send SIGXFSZ if new filesize exceeds
	limit
Message-ID: <201002251402.o1NFaue3024549@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch makes ocfs2 send SIGXFSZ if new file size exceeds limit.
No suprise that processes get SIGXFSZ on one node(in the cluster) while they
don't on another if file size limits are different on the two nodes.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/file.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 558ce03..13d7c68 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -993,6 +993,14 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (size_change && attr->ia_size != i_size_read(inode)) {
+		unsigned long limit;
+
+		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		if (limit != RLIM_INFINITY && attr->ia_size > limit) {
+			status = -EFBIG;
+			send_sig(SIGXFSZ, current, 0);
+			goto bail_unlock;
+		}
 		if (attr->ia_size > sb->s_maxbytes) {
 			status = -EFBIG;
 			goto bail_unlock;
-- 
1.6.6
