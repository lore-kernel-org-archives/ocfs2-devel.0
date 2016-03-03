From: Jan Kara <jack@suse.cz>
Date: Thu,  3 Mar 2016 15:14:22 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix return value from
	ocfs2_page_mkwrite()
Message-ID: <1457014462-32620-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_page_mkwrite() could mistakenly return error code instead of
mkwrite status value. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 9581d190f6e1..77ebc2bc1cca 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -147,6 +147,10 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	ret = ocfs2_inode_lock(inode, &di_bh, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else
+			ret = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
-- 
2.6.2
