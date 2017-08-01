From: Jan Kara <jack@suse.cz>
Date: Tue,  1 Aug 2017 16:12:52 +0200
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Don't clear SGID when inheriting
	ACLs
In-Reply-To: <20170801141252.19675-1-jack@suse.cz>
References: <20170801141252.19675-1-jack@suse.cz>
Message-ID: <20170801141252.19675-3-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>, stable@vger.kernel.org

When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
set, DIR1 is expected to have SGID bit set (and owning group equal to
the owning group of 'DIR0'). However when 'DIR0' also has some default
ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
'DIR1' to get cleared if user is not member of the owning group.

Fix the problem by moving posix_acl_update_mode() out of ocfs2_set_acl()
into ocfs2_iop_set_acl(). That way the function will not be called when
inheriting ACLs which is what we want as it prevents SGID bit clearing
and the mode has been properly set by posix_acl_create() anyway. Also
posix_acl_chmod() that is calling ocfs2_set_acl() takes care of updating
mode itself.

Fixes: 073931017b49d9458aa351605b43a7e34598caef
CC: stable at vger.kernel.org
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/acl.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 3b9c3638a381..40b5cc97f7b0 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -240,18 +240,6 @@ static int ocfs2_set_acl(handle_t *handle,
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_ACCESS;
-		if (acl) {
-			umode_t mode;
-
-			ret = posix_acl_update_mode(inode, &mode, &acl);
-			if (ret)
-				return ret;
-
-			ret = ocfs2_acl_set_mode(inode, di_bh,
-						 handle, mode);
-			if (ret)
-				return ret;
-		}
 		break;
 	case ACL_TYPE_DEFAULT:
 		name_index = OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT;
@@ -289,7 +277,19 @@ int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	had_lock = ocfs2_inode_lock_tracker(inode, &bh, 1, &oh);
 	if (had_lock < 0)
 		return had_lock;
+	if (type == ACL_TYPE_ACCESS && acl) {
+		umode_t mode;
+
+		status = posix_acl_update_mode(inode, &mode, &acl);
+		if (status)
+			goto unlock;
+
+		status = ocfs2_acl_set_mode(inode, bh, NULL, mode);
+		if (status)
+			goto unlock;
+	}
 	status = ocfs2_set_acl(NULL, inode, bh, type, acl, NULL, NULL);
+unlock:
 	ocfs2_inode_unlock_tracker(inode, 1, &oh, had_lock);
 	brelse(bh);
 	return status;
-- 
2.12.3
