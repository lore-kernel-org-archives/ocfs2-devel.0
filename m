From: Tao Ma <tm@tao.ma>
Date: Mon, 23 May 2011 10:36:44 +0800
Subject: [Ocfs2-devel] [PATCH 2/3 V2] ocfs2: Add FITRIM ioctl.
In-Reply-To: <1306118205-3148-1-git-send-email-tm@tao.ma>
References: <4DD9C1A3.5020005@tao.ma>
	<1306118205-3148-1-git-send-email-tm@tao.ma>
Message-ID: <1306118205-3148-2-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Add the corresponding ioctl function for FITRIM.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/ioctl.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 8f13c59..312a28f 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -542,6 +542,29 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 0);
+	case FITRIM:
+	{
+		struct super_block *sb = inode->i_sb;
+		struct fstrim_range range;
+		int ret = 0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (copy_from_user(&range, (struct fstrim_range *)arg,
+		    sizeof(range)))
+			return -EFAULT;
+
+		ret = ocfs2_trim_fs(sb, &range);
+		if (ret < 0)
+			return ret;
+
+		if (copy_to_user((struct fstrim_range *)arg, &range,
+		    sizeof(range)))
+			return -EFAULT;
+
+		return 0;
+	}
 	default:
 		return -ENOTTY;
 	}
@@ -569,6 +592,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_GROUP_EXTEND:
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+	case FITRIM:
 		break;
 	case OCFS2_IOC_REFLINK:
 		if (copy_from_user(&args, (struct reflink_arguments *)arg,
-- 
1.6.3.GIT
