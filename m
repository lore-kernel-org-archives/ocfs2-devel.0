From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Apr 27 10:23:07 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 updates
Message-ID: <20070427172301.GI21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Christoph Hellwig <hch@lst.de>

Hi Linus,

	Here's pretty much everything I wanted to push for 2.6.22-rc1. This
includes the following patch series:

* Various fixes / cleanups which weren't suitable for late inclusion in 2.6.21.


* A patch series by Tiger Yang which removes some broadcast node messaging
  that Ocfs2 does in ocfs2_delete_inode() and replaces it with an "open
  lock".  This is conceptually similar to what GFS2 does right now. Being
  able to test the lock in ocfs2_delete_inode() allows us to take a
  clusterwide message and turn it into a message between only two nodes at
  worst case. That message has actually been on my hit list for a while now,
  so I'm very excited that Tiger has gotten rid of it :)


* Sparse file support for Ocfs2. This series easily comprises the bulk of
  the changes, as it had to touch most parts of the file system that had
  anything to do with reading and writing files. Most patches in the series
  have to do with on-disk b-tree manipulation or updates to the higher level
  read/write functions in the file system. Additionally, the series includes
  some patches which make the necessary disk structure changes to allow a
  small flags field in our extent record. The only allocated flag right now
  is OCFS2_EXT_UNWRITTEN to mark an unwritten extent. The code to write
  unwritten extents is not yet complete (this will have to come after
  2.6.22), but the file system correctly returns zeros when reading them.

  Unfortunately, the patches for write support of sparse files led to the
  implementation of a custom file write within Ocfs2. We needed this to
  ensure correct ordering of page locks when filling holes - Ocfs2 file
  systems can have atomic allocation units up to 1 megabyte. The existing
  VFS write mechanisms don't give the file system the ability to handle it's
  own page locking, so Ocfs2 has no good way to ensure that zero's for
  adjacent PAGE_SIZE regions blocks are written to disk during an allocating
  write (so that a subsequent read doesn't return junk). NTFS has a custom
  write for a similar problem.

  I'm not particularly thrilled with the write situation however, so I've
  been helping out Nick Piggin on some patches that he's come up with to fix
  up the VFS to allow file systems some more control over how pages for a
  write are mapped and written. He's sent those patches out for review
  several times, as a "New Aops" patch series. Included in those series is
  an Ocfs2 patch to remove the custom write functionality and replace it
  with generic callbacks (which kills _alot_ of code). Ultimately, I believe
  that some version of those patches is what we'll wind up with. For
  reference, the latest version of Nicks patches can be found at:

http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/new-aops/2.6.21-rc7-new-aops.tar.gz


* Included is one patch which touches files outside of fs/ocfs2 which I have
  attached to this e-mail. The patch makes a small API adjustment by turning
  do_sync_file_range() into do_sync_mapping_range(). This was required for
  the sparse file support patches so that we could sync a range by passing a
  struct address_space instead of a file *.


Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/alloc.c                | 3037 ++++++++++++++++++++++++++++++++--------
 fs/ocfs2/alloc.h                |   27 
 fs/ocfs2/aops.c                 | 1011 ++++++++++---
 fs/ocfs2/aops.h                 |   77 -
 fs/ocfs2/cluster/quorum.c       |    5 
 fs/ocfs2/cluster/tcp_internal.h |    5 
 fs/ocfs2/dir.c                  |   15 
 fs/ocfs2/dlm/dlmdomain.c        |    5 
 fs/ocfs2/dlm/dlmrecovery.c      |    2 
 fs/ocfs2/dlmglue.c              |  143 +
 fs/ocfs2/dlmglue.h              |    3 
 fs/ocfs2/extent_map.c           | 1233 ++++------------
 fs/ocfs2/extent_map.h           |   39 
 fs/ocfs2/file.c                 |  637 +++++++-
 fs/ocfs2/file.h                 |    5 
 fs/ocfs2/inode.c                |  199 +-
 fs/ocfs2/inode.h                |   23 
 fs/ocfs2/journal.c              |   24 
 fs/ocfs2/journal.h              |    2 
 fs/ocfs2/mmap.c                 |    7 
 fs/ocfs2/namei.c                |   23 
 fs/ocfs2/ocfs2.h                |   55 
 fs/ocfs2/ocfs2_fs.h             |   31 
 fs/ocfs2/ocfs2_lockid.h         |    5 
 fs/ocfs2/slot_map.c             |    2 
 fs/ocfs2/suballoc.c             |    3 
 fs/ocfs2/super.c                |    7 
 fs/ocfs2/vote.c                 |  289 ---
 fs/ocfs2/vote.h                 |    3 
 fs/sync.c                       |    8 
 include/linux/fs.h              |    9 
 31 files changed, 4697 insertions(+), 2237 deletions(-)

Mark Fasheh:
      ocfs2: Local mounts should skip inode updates
      ocfs2: filter more error prints
      ocfs2: small cleanup of ocfs2_request_delete()
      ocfs2: sparse b-tree support
      ocfs2: temporarily remove extent map caching
      ocfs2: teach extend/truncate about sparse files
      ocfs2: abstract out allocation locking
      ocfs2: Turn off shared writeable mmap for local files systems with holes.
      ocfs2: teach ocfs2_file_aio_write() about sparse files
      ocfs2: remove ocfs2_prepare_write() and ocfs2_commit_write()
      ocfs2: Teach ocfs2_get_block() about holes
      ocfs2: zero tail of sparse files on truncate
      Turn do_sync_file_range() into do_sync_mapping_range()
      ocfs2: Use do_sync_mapping_range() in ocfs2_zero_tail_for_truncate()
      ocfs2: Use own splice write actor
      ocfs2: make room for unwritten extents flag
      ocfs2: Read from an unwritten extent returns zeros
      ocfs2: Fix extent lookup to return true size of holes
      ocfs2: Fix up i_blocks calculation to know about holes
      ocfs2: Remember rw lock level during direct io
      ocfs2: Cache extent records

Srinivas Eeda:
      ocfs2_dlm: fix race in dlm_remaster_locks

Sunil Mushran:
      ocfs2_dlm: Call cond_resched_lock() once per hash bucket scan
      ocfs2: Silence compiler warnings
      ocfs2: Replace panic() with emergency_restart() when fencing

Tiger Yang:
      ocfs2: Remove delete inode vote
      ocfs2: remove unused code



From: Mark Fasheh <mark.fasheh@oracle.com>

[PATCH] Turn do_sync_file_range() into do_sync_mapping_range()

do_sync_file_range() accepts a file * from which it takes an address_space to
sync.  Abstract out the bulk of the function into do_sync_mapping_range()
which takes the address_space directly.  This way callers who want to sync an
address_space directly can take advantage of the functionality provided.

do_sync_file_range() is preserved as a small wrapper around
do_sync_mapping_range().

Ocfs2 in particular would like to use this to initiate a sync of a specific
inode range during truncate, where a file * may not be available.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

---

 fs/sync.c          |    8 +++-----
 include/linux/fs.h |    9 +++++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

5b04aa3a64f854244bc40a6f528176ed50b5c4f6
diff --git a/fs/sync.c b/fs/sync.c
index d0feff6..5cb9e7e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -239,13 +239,11 @@ out:
 /*
  * `endbyte' is inclusive
  */
-int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags)
+int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			  loff_t endbyte, unsigned int flags)
 {
 	int ret;
-	struct address_space *mapping;
 
-	mapping = file->f_mapping;
 	if (!mapping) {
 		ret = -EINVAL;
 		goto out;
@@ -275,4 +273,4 @@ int do_sync_file_range(struct file *file
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(do_sync_file_range);
+EXPORT_SYMBOL_GPL(do_sync_mapping_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 86ec3f4..095a9c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -843,8 +843,13 @@ extern int fcntl_setlease(unsigned int f
 extern int fcntl_getlease(struct file *filp);
 
 /* fs/sync.c */
-extern int do_sync_file_range(struct file *file, loff_t offset, loff_t endbyte,
-			unsigned int flags);
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+static inline int do_sync_file_range(struct file *file, loff_t offset,
+			loff_t endbyte, unsigned int flags)
+{
+	return do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
+}
 
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
-- 
1.3.3
