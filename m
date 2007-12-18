From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Dec 18 19:08:22 2007
Subject: [Ocfs2-devel] [PATCH 0/4] Add online resize support for ocfs2,
	take 4
In-Reply-To: <20071218073522.GA24606@tma-pc1.cn.oracle.com>
References: <20071218073522.GA24606@tma-pc1.cn.oracle.com>
Message-ID: <20071219030648.GG13821@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 18, 2007 at 03:35:22PM +0800, tao.ma wrote:
> Mark,
>     Wish this patch series meets your need.

Ok, kernel patches are committed to ocfs2.git. I added this patch to the end
of the series, please check.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com

From: Mark Fasheh <mark.fasheh@oracle.com>

ocfs2: Add missing permission checks

Check that an online resize is being driven by a user with permission to
change system resource limits.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index a4dda60..83b3e0f 100644
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
