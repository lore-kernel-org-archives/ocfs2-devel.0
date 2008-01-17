From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:37:01 2008
Subject: [Ocfs2-devel] [PATCH 14/30] ocfs2: Add missing permission checks
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-15-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>

Check that an online resize is being driven by a user with permission to
change system resource limits.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7003d58..5177fba 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -144,12 +144,18 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 
 		return ocfs2_change_file_space(filp, cmd, &sr);
 	case OCFS2_IOC_GROUP_EXTEND:
+		if (!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
 		if (get_user(new_clusters, (int __user *)arg))
 			return -EFAULT;
 
 		return ocfs2_group_extend(inode, new_clusters);
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+		if (!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
 		if (copy_from_user(&input, (int __user *) arg, sizeof(input)))
 			return -EFAULT;
 
-- 
1.5.3.6
