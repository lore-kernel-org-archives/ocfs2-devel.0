From: Jeff Liu <jeff.liu@oracle.com>
Date: Sun, 08 Dec 2013 19:35:16 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Adjust minlen with
 discard_granularity in the FITRIM ioctl
Message-ID: <52A45974.2030909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

Adjust minlen with discard_granularity for FITRIM ioctl(2) if the given
minimum size in bytes is less than it because, discard granularity is
used to tell us that the minimum size of extent that can be discarded
by the storage device.

This is inspired by Ext4 [ commit 5c2ed62fd4 ] from Lukas Czerner.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 4de6a2a..8ca3c29 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -980,6 +980,8 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&range, argp, sizeof(range)))
 			return -EFAULT;
 
+		range.minlen = max_t(u64, q->limits.discard_granularity,
+				     range.minlen);
 		ret = ocfs2_trim_fs(sb, &range);
 		if (ret < 0)
 			return ret;
-- 
1.8.3.2
