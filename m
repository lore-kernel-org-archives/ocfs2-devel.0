From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Feb 2010 16:44:29 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2-1.6: Use filep_dentry in compat_ctl.
Message-ID: <1265791469-15876-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

17fb03bb01b4ae34643b16f2029049e5bab350e is backported from
mainline, but the structure has changed somehow since 2.6.18.
So get inode like we do in ioctl.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 1d3f828..56dba61 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -184,7 +184,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
 	bool preserve;
 	struct reflink_arguments args;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct inode *inode = filp_dentry(file)->d_inode;
 
 	switch (cmd) {
 	case OCFS2_IOC32_GETFLAGS:
-- 
1.5.5
