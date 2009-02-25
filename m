From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Feb 2009 18:08:56 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V4)
In-Reply-To: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
References: <200902200924.n1K9Oqp1029041@rgminet15.oracle.com>
Message-ID: <20090225020855.GB5209@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 20, 2009 at 05:23:50PM +0800, wengang wang wrote:
> changes from v3:
> 1, move codes that checks inode allocation bit to subfunction
> ocfs2_test_inode_bit().
> 
> 2, release the suballoc lock just after we get it. we should release it asap
> and doing so doesn't affect functionility.
> 
> 3, add inode alloc slot validation.

Almost there!

> +	/* takes nfs_sync_lock in EX mode */
> +	status = ocfs2_nfs_sync_lock(osb, 1);
> +	if (status < 0) {
> +		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
> +		goto check_err;
> +	}
> +
> +	status = ocfs2_test_inode_bit(osb, blkno, &set);
> +	if (status < 0) {
> +		if (status == -EINVAL) {
> +			/* meta block never be re-allocated as data block.
> +			 * nfsd gives us wrong blkno */
> +			status = -EEXIST;
> +		} else {
> +			mlog(ML_ERROR, "test inode bit failed %d\n", status);
> +		}
> +		goto unlock_nfs_sync;
> +	}

	This looks very nice, but it should return -ESTALE instead
of -EEXIST; it most likely does not exist, and nfs knows how to handle
that error.

>  	result = d_obtain_alias(inode);
> -	if (!IS_ERR(result))
> +	if (!IS_ERR(result)) {
>  		result->d_op = &ocfs2_dentry_ops;
> +	} else {
> +		mlog_errno((int)result);
> +	}

	Use PTR_ERR(result), not (int)result.

> Index: suballoc.c
> ===================================================================
> --- suballoc.c	(revision 139)
> +++ suballoc.c	(working copy)
> @@ -2116,3 +2116,153 @@ out:
>  
>  	return ret;
>  }
> +
> +/* reads(hit disk) the inode specified by blkno to get suballoc_slot
> + * and suballoc_bit
> + * */
> +static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
> +				u16 *suballoc_slot, u16 *suballoc_bit)
> +{
> +	int status;
> +	struct buffer_head *inode_bh = NULL;
> +	struct ocfs2_dinode *inode_fe;
> +
> +	mlog_entry("blkno: %llu\n", blkno);
> +
> +	/* dirty read disk */
> +	status = ocfs2_read_blocks_sync(osb, blkno, 1, &inode_bh);
> +	if (status < 0)
> +		goto bail;
> +
> +	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
> +	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
> +		status = -EINVAL;
> +		goto bail;
> +	}

	Let's add an ML_ERROR here: "invalid inode %llu requested".

> +	if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
> +	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots -1) {
> +		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u"
> +		     "this may be caused by file system crash", blkno,
> +		     (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
> +		status = -EINVAL;
> +		goto bail;
> +	}

	Don't print "this may be caused by file system crash", as it is
much more likely that nfs is asking for a bad block.  Let's jsut say
"inode %llu has an invalid suballoc slot %u".

> +/* test if the bit, which is for the inode specified by blkno, in suballoc is
> + * set or not.
> + * on success, 0 is returned and *res is 1 for SET; 0 otherwise.
> + * when fails, errno is returned and *res is meaningless.
> + * MAKE SURE to hold nfs_sync_lock to revent ocfs2_delete_inode() on another
> + * node from accessing the same suballoc concurrently.
> + * */
> +int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
> +{
> +	int status;
> +	u16 suballoc_bit = 0, suballoc_slot = 0;
> +	struct inode *inode_alloc_inode;
> +	struct buffer_head *alloc_bh = NULL;
> +
> +	/* MAKE SURE nfs_sync_lock is held */
> +
> +	mlog_entry("blkno: %llu", blkno);
> +
> +	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
> +					     &suballoc_bit);
> +	if (status < 0) {
> +		mlog(ML_ERROR, "get alloc slot and bit failed %d\n", status);
> +		goto bail;
> +	}
> +
> +	inode_alloc_inode =
> +		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
> +					    suballoc_slot);
> +	if (!inode_alloc_inode) {
> +		/* the error code could be inaccurate, but we are not able to
> +		 * get the correct one. */
> +		status = -EEXIST;
> +		mlog(ML_ERROR, "unable to get alloc inode in slot %u\n",
> +		     (u32)suballoc_slot);
> +		goto bail;
> +	}
> +
> +	mutex_lock(&inode_alloc_inode->i_mutex);
> +	/* lock down the suballoc lock it to cause other nodes flush disk and
> +	 * then release it immediately to let allocation on other nodes to go
> +	 * asap. the reason we can read the group without lock is that we just
> +	 * want to know if the bit is clear and there can't be a concurrent
> +	 * clearing action because we hold the nfs_sync_lock. sure that there
> +	 * can be a concurrent setting action then. it doesn't matter, we can
> +	 * check generation later. */
> +	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
> +	if (status < 0) {
> +		mutex_unlock(&inode_alloc_inode->i_mutex);
> +		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
> +		     (u32)suballoc_slot, status);
> +		goto bail;
> +	}

	You need to test the suballoc bit inside the lock.  The current
code is unsafe because while the inode set value won't change in a way
that matters, the structure of the alloc inode's groups may.  So move
the ocfs2_test_suballoc_bit() call inside the lock here:

+	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
+					 blkno, suballoc_bit, res);
+	if (status < 0)
+		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	ocfs2_inode_unlock(inode_alloc_inode, 0);
+	mutex_unlock(&inode_alloc_inode->i_mutex);

Update the comment, of course.  Your points about the nfs_sync_lock are
correct.  The only change is that we read the group under the lock.

> +	iput(inode_alloc_inode);
> +	brelse(alloc_bh);
> +bail:
> +	mlog_exit(status);
> +	return status;
> +}

	Otherwise this looks good.

Joel

-- 

#!/bin/perl -sp0777i<X+d*lMLa^*lN%0]dsXx++lMlN/dsM0<j]dsj
$/=unpack('H*',$_);$_=`echo 16dio\U$k"SK$/SM$n\EsN0p[lN*1
lK[d2%Sa2/d0$^Ixp"|dc`;s/\W//g;$_=pack('H*',/((..)*)$/)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
