From: Jan Kara <jack@suse.cz>
Date: Thu,  4 Jun 2009 15:26:49 +0200
Subject: [Ocfs2-devel] [PATCH 1/2] vfs: Set special lockdep map for dirs
	only if not set by fs
In-Reply-To: <1244122010-16766-1-git-send-email-jack@suse.cz>
References: <1244122010-16766-1-git-send-email-jack@suse.cz>
Message-ID: <1244122010-16766-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some filesystems need to set lockdep map for i_mutex differently for
different directories. For example OCFS2 has system directories (for
orphan inode tracking and for gathering all system files like journal
or quota files into a single place) which have different locking
locking rules than standard directories. For a filesystem setting
lockdep map is naturaly done when the inode is read but we have to
modify unlock_new_inode() not to overwrite the lockdep map the filesystem
has set.

Acked-by: peterz at infradead.org
CC: mingo at redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c              |   17 +++++++++++------
 include/linux/lockdep.h |   15 +++++++++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6ad14a1..44e1848 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -654,12 +654,17 @@ void unlock_new_inode(struct inode *inode)
 	if (inode->i_mode & S_IFDIR) {
 		struct file_system_type *type = inode->i_sb->s_type;
 
-		/*
-		 * ensure nobody is actually holding i_mutex
-		 */
-		mutex_destroy(&inode->i_mutex);
-		mutex_init(&inode->i_mutex);
-		lockdep_set_class(&inode->i_mutex, &type->i_mutex_dir_key);
+		/* Set new key only if filesystem hasn't already changed it */
+		if (!lockdep_match_class(&inode->i_mutex,
+		    &type->i_mutex_key)) {
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
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index da5a5a1..b25d1b5 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -258,6 +258,16 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 #define lockdep_set_subclass(lock, sub)	\
 		lockdep_init_map(&(lock)->dep_map, #lock, \
 				 (lock)->dep_map.key, sub)
+/*
+ * Compare locking classes
+ */
+#define lockdep_match_class(lock, key) lockdep_match_key(&(lock)->dep_map, key)
+
+static inline int lockdep_match_key(struct lockdep_map *lock,
+				    struct lock_class_key *key)
+{
+	return lock->key == key;
+}
 
 /*
  * Acquire a lock.
@@ -326,6 +336,11 @@ static inline void lockdep_on(void)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
+/*
+ * We don't define lockdep_match_class() and lockdep_match_key() for !LOCKDEP
+ * case since the result is not well defined and the caller should rather
+ * #ifdef the call himself.
+ */
 
 # define INIT_LOCKDEP
 # define lockdep_reset()		do { debug_locks = 1; } while (0)
-- 
1.6.0.2
