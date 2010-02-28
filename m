From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 27 Feb 2010 19:06:36 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle deletion of refcounted
 oprhan_inode correctly.
In-Reply-To: <4B88F51A.8070701@oracle.com>
References: <1266740977-8638-1-git-send-email-tristan.ye@oracle.com>
	<1266740977-8638-2-git-send-email-tristan.ye@oracle.com>
	<20100226232807.GF23730@mail.oracle.com>
	<4B88F51A.8070701@oracle.com>
Message-ID: <20100228030636.GB20343@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Feb 27, 2010 at 06:34:02PM +0800, tristan ye wrote:
> > 	Why is this necessary?  Don't we have the open lock on the
> > reflink target?  That should keep an orphan scan from wiping a life
> > refount target.  Tao, do we not have the open lock?
> >   
> 
> Yes, we have the open lock all time during reflink operation, but we 
> didn't hold the orphan_dir's lock during this period, which means 
> orphan_scan would have a chance to add our half-refcounted target into 
> its working queue, which will be deferred to invoke ocfs2_inode_delete 
> after reflink operation done(actually it always be invoked after reflink 
> done since we hold the open lock of target inode all the time), in this 
> case, we definitely failed at  ocfs2_query_inode_wipe() as bug 1215 
> described, since the ORPHAN_FLAG here have been cleared by reflink 
> operation. that's not so good to me, we shouldn't have treated this as a 
> 'ML_ERROR'.

	Aha!  I think this is what we're all missing.  The rule of the
orphan dir is that all inodes in the orphan dir have ORPHANED_FL.  But
you're right, we queue the orphans.  A reflink inode can be moved out of
the orphan dir and have its ORPHANED_FL cleared before the queue is run.
Thus, the queue finds an inode without ORPHANED_FL.  This is correct,
because the inode is no longer orphaned.
	The comment didn't help me.  Let's try reversing the order and
changing the comment.

-----------------------------------------------------------------
        if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
+		/*
+		 * Inodes in the orphan dir must have ORPHANED_FL.  The
+		 * only inodes that come back out of the orphan dir are
+		 * reflink targets.  A reflink target may be moved out
+		 * of the orphan dir between the time we scan the
+		 * directory and the time we process it.  This would
+		 * lead to HAS_REFCOUNT_FL being set but ORPHANED_FL
+		 * not.
+		 */
+               if (di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) {
+                       mlog(0, "Reflinked inode %llu is no longer orphaned.  "
+                            "it must not be deleted\n",
+                            (unsigned long long)oi->ip_blkno);
+                       goto bail;
+		}
+
                /* for lack of a better error? */
                status = -EEXIST;
                mlog(ML_ERROR,
                     "Inode %llu (on-disk %llu) not orphaned! "
                     "Disk flags  0x%x, inode flags 0x%x\n",
                     (unsigned long long)oi->ip_blkno,
                     (unsigned long long)le64_to_cpu(di->i_blkno),
                     le32_to_cpu(di->i_flags), oi->ip_flags);
                goto bail;
	}
-----------------------------------------------------------------

	I find this more readable.  We're just special casing the
reflink behavior.
	Now let's look at our cases.  First, orphan scans.  If the
orphan flag is not set, we know it was moved out.  If ORPHANED_FL is
set, we continue on to wiping.  This checks the open lock.  If the open
lock is held, query_inode_wipe knows it is in use, and it is skipped.
	What about crash recovery?  Well, if it is in the orphan dir, it
will have ORPHANED_FL.  We'll process it like normal.  If it was already
moved out, recovery won't see it.
	I think this covers everything.

Joel

-- 

"I have never let my schooling interfere with my education."
        - Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
