From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar  9 17:00:23 2004
Subject: [Ocfs2-devel] Bug in error handling
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A602A569E1@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A602A569E1@orsmsx403.jf.intel.com>
Message-ID: <20040309230012.GA12681@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 09, 2004 at 01:18:11PM -0800, Villalovos, John L wrote:
> It was NOT a 1st mount.  It was a disk that had been previously used.
> 
> It appears that the mount fails but then some globals are probably in a
> partially set state.
Ok, could you update from latest SVN and let me know if that fixed it?
I wasn't getting the NULL pointer error in ocfs_bh_sem_lookup like you, but
I was definitely seeing one in ocfs_inode_hash_prune_all where we were
assuming that an inode existed on the inum when in fact it didn't :) The fix
of course, we to check for it's existence before acting on it!

Alternatively, if you don't want to update from SVN, you can apply this
patch.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com

Index: hash.c
===================================================================
--- hash.c	(revision 766)
+++ hash.c	(working copy)
@@ -1267,18 +1267,19 @@ static int ocfs_inode_hash_prune_all(ocf
 		inum = list_entry(iter, ocfs_inode_num, i_list);
 		list_del(&inum->i_list);
 
-		/* this log_error_args is mainly for debugging */
-		if (atomic_read(&inum->i_inode->i_count) > 2)
-			LOG_ERROR_ARGS("inode (%lu) with i_count = %u left in "
-				       "system, (voteoff = %u.%u, "
-				       "fileoff = %u.%u)\n", 
-				       inum->i_inode->i_ino,
-				       atomic_read(&inum->i_inode->i_count),
-				       HILO(inum->i_voteoff), 
-				       HILO(inum->i_feoff));
+		if (inum->i_inode) {
+			/* this log_error_args is mainly for debugging */
+			if (atomic_read(&inum->i_inode->i_count) > 2)
+				LOG_ERROR_ARGS("inode (%lu) with i_count = %u "
+					  "left in system, (voteoff = "
+					  "%u.%u, fileoff = %u.%u)\n", 
+					  inum->i_inode->i_ino,
+					  atomic_read(&inum->i_inode->i_count),
+					  HILO(inum->i_voteoff), 
+					  HILO(inum->i_feoff));
 
-		if (inum->i_inode)
 			iput(inum->i_inode);
+		}
 		ocfs_free_inode_num(inum);
 	}
 
