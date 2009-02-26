From: Jan Kara <jack@suse.cz>
Date: Thu, 26 Feb 2009 21:15:04 +0100
Subject: [Ocfs2-devel] [PATCH 6/7] vfs: Set special lockdep map for dirs
	only if not set by fs
In-Reply-To: <1235679305-3920-6-git-send-email-jack@suse.cz>
References: <y> <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
	<1235679305-3920-3-git-send-email-jack@suse.cz>
	<1235679305-3920-4-git-send-email-jack@suse.cz>
	<1235679305-3920-5-git-send-email-jack@suse.cz>
	<1235679305-3920-6-git-send-email-jack@suse.cz>
Message-ID: <1235679305-3920-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some filesystems need to set lockdep map for i_mutex differently for
different directories. For a filesystem it is naturaly done when the
inode is read but we have to modify unlock_new_inode() not to overwrite
the lockdep map filesystem has set.

CC: peterz at infradead.org
CC: mingo at redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..c8c36cf 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -640,12 +640,16 @@ void unlock_new_inode(struct inode *inode)
 	if (inode->i_mode & S_IFDIR) {
 		struct file_system_type *type = inode->i_sb->s_type;
 
-		/*
-		 * ensure nobody is actually holding i_mutex
-		 */
-		mutex_destroy(&inode->i_mutex);
-		mutex_init(&inode->i_mutex);
-		lockdep_set_class(&inode->i_mutex, &type->i_mutex_dir_key);
+		/* Set new key only if filesystem haven't already changed it */
+		if (inode->i_mutex.dep_map.key != &type->i_mutex_key) {
+			/*
+			 * ensure nobody is actually holding i_mutex
+			 */
+			mutex_destroy(&inode->i_mutex);
+			mutex_init(&inode->i_mutex);
+			lockdep_set_class(&inode->i_mutex,
+					  &type->i_mutex_dir_key);
+		}
 	}
 #endif
 	/*
-- 
1.6.0.2
