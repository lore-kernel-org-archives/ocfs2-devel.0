From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Jul 16 12:28:14 2004
Subject: [Ocfs2-devel] A patch to improve the metadata reading throughput
	(a gainst svn1267)
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E04B13BD8@pdsmsx403>
References: <37FBBA5F3A361C41AB7CE44558C3448E04B13BD8@pdsmsx403>
Message-ID: <20040716172342.GM14805@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On Fri, Jul 16, 2004 at 05:59:55PM +0800, Zhang, Sonic wrote:
> Hi,
> 
> 	This is a new patch to increase the metadata reading throughput
> for OCFS2. 
Would you mind regenerating the patch against the latest svn release? 
We've made some changes which you've already gone ahead and rolled into that
one, and I noticed you're missing at least one bug fix which you want to
pick up in ocfs_populate_inode.

> Our approach is to make the metadata reading operation via
> routine ocfs_read_bh() cacheable and keep consistency through routine
> invalidate_bdev() when receiving lock release notifications, such as
> FLAG_FILE_CREATE, FLAG_FILE_DELETE, FLAG_FILE_TRUNCATE,
> FLAG_FILE_EXTEND, etc. These notification is sent in routine
> ocfs_release_lock(), which is invoked in the journal commit thread.
Yeah, for a while now we've been meaning to go through all calls to
ocfs_read_bh[s] and basically make as many of them cached as possible. At
this point in our development, things should be cached unless you're
*absolutely* certain you want to sync off disk.

Another thing that's on the list which you might be interested in looking at
is not sending all lock release messages. Some of them do basically nothing
on the other end in process_vote, so there's really no reason to send them
to the nodes at all. This should help alot when you've batched up a ton of
locks to release in commit_cache. I already started some of this by not
sendning the final delete message in ocfs_delete_inode, though that one's
special as the lockres accounting information is about to be thrown out so
we don't have to update it. Others require more work as you at least have to
decrement the lock_holders variable when you're done with it.

> 	We also did some benchmark.
> 	The directory creating rate is about 4000/s with this patch and
> 1400/s without.
> 	The directory removing rate is about 740/s with this patch and
> 10/s without.
> 
> 	Please refer to the attachment. It is against svn 1267.
> 
> 	This patch is not stable yet. Known issues:
> 1. We still need to check all code which read the metadata. Figure out
> if that metadata is suitable to be cached.
> 3. Current OCFS lock mechanism may cause dead lock in some cases after
> we change to cache metadata and release lock in journal asynchronously.
> We plan to fix it in a new patch.
So are you planning to turn off immediate checkpointing for all the other
journal transactions? This is also on the list :) The only one that *may* be
troublesome I believe is truncate. Otherwise, the ones that are left are:
link, symlink, and rename.

> 4. readdir() may get old data after the data is written back to disk in
> journal asynchronously. It is not a bug. But which way is better, sync
> the new data to disk when other nodes notify READONLY message or just
> let them get old data?
No, we consider it a bug :)  The other nodes should be getting up to date
directory contents.

> 
> 	We are working to improve this patch. Any suggestion?
Sure :) I'll paste your patch below:

Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1267)
+++ src/journal.c	(working copy)
@@ -148,6 +148,8 @@
 	}
 	spin_unlock(&journal->cmt_lock);
 
+	if (osb->needs_flush)
+		ocfs_sync_blockdev(osb->sb);

Is this necessary? It seems awfully heavy, and since we journal *all*
metadata (so it should be synced up to disk via the journal_flush just a
couple lines above that), I don't see the point... I was actually meaning to
take the other call to sync_blockdev out as it's never used :)

Index: src/dlm.c
===================================================================
--- src/dlm.c	(revision 1267)
+++ src/dlm.c	(working copy)
@@ -1038,9 +1038,7 @@
 	ocfs2_dinode *fe = NULL;
 	struct buffer_head *tmpbh = NULL, **b = NULL;
 	__s16 curr_master;
-	int lockflags =
-		(OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE) ?
-		0 : OCFS_BH_CACHED;
+	int lockflags = OCFS_BH_CACHED;
 	int clear_tmp = 0;
 	ocfs_lock_res *lockres = GET_INODE_LOCKRES(inode);

this is good...

<snip>

Index: src/inode.c
===================================================================
--- src/inode.c	(revision 1267)
+++ src/inode.c	(working copy)
@@ -447,8 +447,6 @@
 		    break;
 	    case S_IFDIR:
 		    if (inode->i_nlink < 2) {
-			    LOG_ERROR_ARGS("inlink=%d for %llu\n", inode->i_nlink, 
-					   fe->i_blkno);
 			    inode->i_nlink = 2;
 		    }

This is wrong. The latest SVN doesn't include this block as nlink on a
directory can very well be 0 if it's been moved to the orphan dir.

<snip>

Index: src/nm.c
===================================================================
--- src/nm.c	(revision 1267)
+++ src/nm.c	(working copy)

<snip>

@@ -813,8 +814,7 @@
 		}
 	}
 
-	lockflags = (OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE)
-	       	? 0 : OCFS_BH_CACHED;
+	lockflags = OCFS_BH_CACHED;

This is good...

<snip>

@@ -910,7 +928,7 @@
 				       inode->i_nlink);
 			/* verify_update_inode does a dirty read which
 			 * might set i_nlink to an old value. */
-			if (inode->i_nlink) {
+			if ( !S_ISDIR(inode->i_mode) && inode->i_nlink) {
 				LOG_ERROR_ARGS("Orphaned inode %lu has link "
 					       "count = %d!\n", inode->i_ino, 
 					       inode->i_nlink);

and if you include the fix to ocfs_populate_inode, this is no longer
necessary :)

<snip>

Index: src/buffer_head_io.c
===================================================================
--- src/buffer_head_io.c	(revision 1267)
+++ src/buffer_head_io.c	(working copy)
@@ -217,13 +217,6 @@
 	    !(OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE))
 		flags |= OCFS_BH_CACHED;
 
-	if (inode && (flags & OCFS_BH_CACHED) &&
-	    (OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE)) {
-		LOG_TRACE_STR("hey bozo you are trying to read "
-			      "a system thingy cached!");
-		flags &= ~OCFS_BH_CACHED;
-	}
-
 	sb = osb->sb;
 	blocknum = off >> sb->s_blocksize_bits;

excellent. This and the other places where you did something like:
-       int lockflags =
-               (OCFS_I(inode)->ip_flags & OCFS_INODE_SYSTEM_FILE) ?
-               0 : OCFS_BH_CACHED;
+       int lockflags = OCFS_BH_CACHED;

are exactly what we've needed to do for a while now.
Thanks!
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
