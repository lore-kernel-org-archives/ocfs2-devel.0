From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  5 Dec 2008 06:20:55 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2/xattr: Always updating ctime in
	xattr set.
In-Reply-To: <4938C737.9060504@oracle.com>
References: <4938C737.9060504@oracle.com>
Message-ID: <1228429256-9308-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In xattr set, we should always update ctime if the operation goes
sucessfully. The old one mistakenly put it in ocfs2_xattr_set_entry
which is only called when we set xattr in inode or xattr block. The
side benefit is that it resolve the bug 1052 since in that scenario,
ocfs2_calc_xattr_set_need only calc out the xattr set credits while
ocfs2_xattr_set_entry update the inode also which isn't concerned with
the process of xattr set.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8fb8457..34c6850 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1609,10 +1609,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	oi->ip_dyn_features |= flag;
 	di->i_dyn_features = cpu_to_le16(oi->ip_dyn_features);
 	spin_unlock(&oi->ip_lock);
-	/* Update inode ctime */
-	inode->i_ctime = CURRENT_TIME;
-	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
-	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 
 	ret = ocfs2_journal_dirty(handle, xs->inode_bh);
 	if (ret < 0)
@@ -2525,6 +2521,20 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 		}
 	}
 
+	if (!ret) {
+		/* Update inode ctime. */
+		ret = ocfs2_journal_access(ctxt->handle, inode, xis->inode_bh,
+					   OCFS2_JOURNAL_ACCESS_WRITE);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		inode->i_ctime = CURRENT_TIME;
+		di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
+		di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+		ocfs2_journal_dirty(ctxt->handle, xis->inode_bh);
+	}
 out:
 	return ret;
 }
@@ -2701,6 +2711,8 @@ int ocfs2_xattr_set(struct inode *inode,
 		goto cleanup;
 	}
 
+	/* we need to update inode's ctime field, so add credit for it. */
+	credits += OCFS2_INODE_UPDATE_CREDITS;
 	ctxt.handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
-- 
1.5.4.GIT
