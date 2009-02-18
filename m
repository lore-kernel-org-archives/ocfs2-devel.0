From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 17 Feb 2009 17:37:01 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V3)
In-Reply-To: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>
References: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>
Message-ID: <20090218013700.GA26431@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 17, 2009 at 08:53:47PM +0800, wengang wang wrote:
> For nfs exporting, ocfs2_get_dentry() returns the dentry for fh.
> ocfs2_get_dentry() may read from disk(when inode not in memory) without
> any cross cluster lock. this leads to load a stale inode.
> 
> this patch fixes above problem.

	This patch is almost there.  Excellent!

> this patch is based on 1.4 git.

	Going forward, fixes really need to be against mainline.  Let's
finish out this patch against 1.4 and then you can port it to mainline.
But for the future, we fix against mainline and backport.

> +	status = ocfs2_get_suballoc_slot_bit(osb, blkno, &suballoc_slot,
> +					     &suballoc_bit);
> +	if (status < 0) {
> +		if (status == -EINVAL) {
> +			/* meta block never be re-allocated as data block.
> +			 * nfsd gives us wrong blkno */
> +			status = -EEXIST;
> +		} else {
> +			mlog(ML_ERROR, "get alloc slot and bit failed %d\n",
> +			     status);
> +		}
> +		goto unlock_nfs_sync;
> +	}
> +	inode_alloc_inode =
> +		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
> +					    suballoc_slot);
> +	if (!inode_alloc_inode) {
> +		status = -EEXIST;
> +		mlog(ML_ERROR, "unable to get alloc inode in slot %u\n",
> +		     (u32)suballoc_slot);
> +		goto unlock_nfs_sync;
> +	}
> +
> +	mutex_lock(&inode_alloc_inode->i_mutex);
> +	status = ocfs2_inode_lock(inode_alloc_inode, &alloc_bh, 0);
> +	if (status < 0) {
> +		mlog(ML_ERROR, "lock on alloc inode on slot %u failed %d\n",
> +		     (u32)suballoc_slot, status);
> +		goto unlock_mutex;
> +	}
> +	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
> +					 blkno, suballoc_bit, &set);
> +	if (status < 0) {
> +		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +		goto inode_unlock;
> +	}
> +	/* allocate bit is clear, inode is a stale inode */
> +	if (!set) {
> +		status = -ESTALE;
> +		goto inode_unlock;
> +	}

	You can drop the suballocator lock here.  Taking the lock has
made sure that other nodes flushed their journals.  You have just
validated that the bit is set, and other nodes cannot clear the bit
until they get the nfs_sync lock, which you already hold.  So it is safe
to call ocfs2_inode_unlock(inode_alloc_inode, 0) and
mutex_unlock(&inode_alloc_inode->i_mutex) before calling ocfs2_iget().
	This has two benefits.  Number 1, we don't take the suballoc
lock and the inode lock (in iget()) at the same time.  The fewer locks
we take at the same time, the better.  Number 2, this means the entire
suballocator lookup code above can be made into a subfunction.  This
improves the readability of the code.

> +/* reads(hit disk) the inode specified by blkno to get suballoc_slot
> + * and suballoc_bit
> + * */
> +int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
> +				u16 *suballoc_slot, u16 *suballoc_bit)
> +{
> +	int status;
> +	struct buffer_head *inode_bh = NULL;
> +	struct ocfs2_dinode *inode_fe;
> +
> +	mlog_entry("blkno: %llu\n", blkno);
> +
> +	/* dirty read disk */
> +	status = ocfs2_read_block(osb, blkno, &inode_bh, 0, NULL);
> +	if (status < 0)
> +		goto bail;
> +
> +	inode_fe = (struct ocfs2_dinode *) inode_bh->b_data;
> +	if (!OCFS2_IS_VALID_DINODE(inode_fe)) {
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
> +	if (suballoc_slot)
> +		*suballoc_slot = le16_to_cpu(inode_fe->i_suballoc_slot);

	Probably want to validate that suballoc_slot is within the range
of valid slot numbers.  Just in case.
	Otherwise, everything looks good.  The nfs_sync_lock is good.
It will need to be added to debugfs.ocfs2's lock displays.

Joel

-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
