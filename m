From: Jan Kara <jack@suse.cz>
Date: Tue, 3 Mar 2009 21:04:32 +0100
Subject: [Ocfs2-devel] [PATCH 6/7] vfs: Set special lockdep map for dirs
	only if not	set by fs
In-Reply-To: <1236095085.5330.4767.camel@laptop>
References: <1235679305-3920-1-git-send-email-jack@suse.cz>
	<1235679305-3920-2-git-send-email-jack@suse.cz>
	<1235679305-3920-3-git-send-email-jack@suse.cz>
	<1235679305-3920-4-git-send-email-jack@suse.cz>
	<1235679305-3920-5-git-send-email-jack@suse.cz>
	<1235679305-3920-6-git-send-email-jack@suse.cz>
	<1235679305-3920-7-git-send-email-jack@suse.cz>
	<1235680042.4948.590.camel@laptop>
	<20090302092338.GA23880@duck.suse.cz>
	<1236095085.5330.4767.camel@laptop>
Message-ID: <20090303200432.GA3912@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 03-03-09 16:44:45, Peter Zijlstra wrote:
> On Mon, 2009-03-02 at 10:23 +0100, Jan Kara wrote:
> 
> >   Not that much - the difference is between "system directories" and normal
> > directories. Currently we also have xattr i_mutex rank differently than
> > normal i_mutex and this is exactly the same case. Only OCFS2 has much more
> > such system files and also system directories so it's impractical to learn
> > VFS about all of them...
> >   But yes, probably I should update the changelog to say this so that
> > a reader does not have to look up why we need it.
> 
> Just for my education, what is a system directory?
  OCFS2 has two system directories AFAIK: The first one is a "root system
directory" - it contains all system files like quota files, journal files,
etc. The second one is the orphan directory - instead of orphan list in ext3,
ocfs2 links every orphaned inode into the orphan directory.

> > > As to the patch, I'd rather you introduce a helper,
> > > lockdep_match_class() or somesuch, if you can convince VFS folks that
> > > what you're wanting to do is sane.
> >   OK, sounds good. Does something like:
> > #define lockdep_match_class(lock, key) lockdep_match_key(&(lock)->dep_map, key)
> > 
> > and
> > 
> > int lockdep_match_key(struct lockdep_map *lock, struct lock_class_key *key)
> > {
> > 	return lock->key == key;
> > }
> > 
> >   Look fine to you? Thanks for opinion.
> 
> Yep, looks good, thanks!
  OK, below is a new version of the patch.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

From 272d47c01af8d7423e3db0d86c8c7dbb8535f2a3 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 12 Feb 2009 22:46:42 +0100
Subject: [PATCH] vfs: Set special lockdep map for dirs only if not set by fs

Some filesystems need to set lockdep map for i_mutex differently for
different directories. For example OCFS2 has system directories (for
orphan inode tracking and for gathering all system files like journal
or quota files into a single place) which have different locking
locking rules than standard directories. For a filesystem setting
lockdep map is naturaly done when the inode is read but we have to
modify unlock_new_inode() not to overwrite the lockdep map the filesystem
has set.

CC: peterz at infradead.org
CC: mingo at redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c              |   17 +++++++++++------
 include/linux/lockdep.h |   15 +++++++++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..147d34b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -640,12 +640,17 @@ void unlock_new_inode(struct inode *inode)
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
index 23bf02f..cb6b2f9 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -291,6 +291,16 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
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
@@ -352,6 +362,11 @@ static inline void lockdep_on(void)
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
