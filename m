From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 18 Apr 2008 10:23:53 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Allow uid/gid/perm changes of
	symlinks
Message-ID: <1208539433-29475-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds the ability to change attributes of a symlink.
Fixes oss bugzilla#963
http://oss.oracle.com/bugzilla/show_bug.cgi?id=963

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/file.c    |    4 ++++
 fs/ocfs2/symlink.c |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9154c82..57e0d30 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1048,6 +1048,10 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
 
+	/* ensuring we don't even attempt to truncate a symlink */
+	if (S_ISLNK(inode->i_mode))
+		attr->ia_valid &= ~ATTR_SIZE;
+
 	if (attr->ia_valid & ATTR_MODE)
 		mlog(0, "mode change: %d\n", attr->ia_mode);
 	if (attr->ia_valid & ATTR_UID)
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 7134007..ba9dbb5 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -167,9 +167,11 @@ const struct inode_operations ocfs2_symlink_inode_operations = {
 	.readlink	= page_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
+	.setattr	= ocfs2_setattr,
 };
 const struct inode_operations ocfs2_fast_symlink_inode_operations = {
 	.readlink	= ocfs2_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
+	.setattr	= ocfs2_setattr,
 };
-- 
1.5.3.6
