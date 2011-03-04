From: Li Dongyang <lidongyang@novell.com>
Date: Fri, 4 Mar 2011 15:10:33 +0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: do not allow fallocate on dir file
Message-ID: <201103041510.33128.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

allowing fallocate() on dir file doesn't make sense, we check if
we are dealing with a regular file and return -EINVAL when it's not,
Thanks

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/ocfs2/file.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a665195..0c68a61 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1870,6 +1870,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out_inode_unlock;
 	}
 
+	if (!S_ISREG(inode->i_mode)) {
+		ret = -EINVAL;
+		goto out_inode_unlock;
+	}
+
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
-- 
1.7.1
