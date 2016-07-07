From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 7 Jul 2016 11:12:41 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: silence an integer overflow warning
Message-ID: <20160707081241.GA16645@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

My static checker complains that ->me_start + ->me_len can overflow.
I haven't followed it through to see the implications but it seems
simple enough to prevent the overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
move_extents in other less common file systems have this same warning as
well.

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index e3d05d9..9ff405a 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -1014,7 +1014,8 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 		goto out_free;
 	}
 
-	if (range.me_start > i_size_read(inode)) {
+	if (range.me_start > i_size_read(inode) ||
+	    range.me_len > i_size_read(inode)) {
 		status = -EINVAL;
 		goto out_free;
 	}
