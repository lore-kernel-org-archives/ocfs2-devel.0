From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 26 Feb 2010 15:28:07 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle deletion of refcounted
 oprhan_inode correctly.
In-Reply-To: <1266740977-8638-2-git-send-email-tristan.ye@oracle.com>
References: <1266740977-8638-1-git-send-email-tristan.ye@oracle.com>
	<1266740977-8638-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100226232807.GF23730@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Feb 21, 2010 at 04:29:37PM +0800, Tristan Ye wrote:
> Current ocfs2 semantic for reflinking a file firstly create a
> new orphan_inode in orphan_dir, then remove it to target dir
> after refcounting operation done, these 2 steps makes logic
> straightfoward, and guarantee a crash during reflinking can
> be replayed(half-refcounted inode can be removed), while it
> brings us another issue cause these 2 steps is acquiring the
> orphan_dir lock respectively, the problem is, orphan_scan()
> may detect the half-refcounted inode in orphan_dir as its
> proper candidates to wipe off in a later time. actually it's
> not of course, we'd handle this correctly.

	Why is this necessary?  Don't we have the open lock on the
reflink target?  That should keep an orphan scan from wiping a life
refount target.  Tao, do we not have the open lock?

> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 88459bd..61fb546 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -892,14 +892,30 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
>  	di = (struct ocfs2_dinode *) di_bh->b_data;
>  	if (!(di->i_flags & cpu_to_le32(OCFS2_ORPHANED_FL))) {
>  		/* for lack of a better error? */
> -		status = -EEXIST;
> -		mlog(ML_ERROR,
> -		     "Inode %llu (on-disk %llu) not orphaned! "
> -		     "Disk flags  0x%x, inode flags 0x%x\n",
> -		     (unsigned long long)oi->ip_blkno,
> -		     (unsigned long long)le64_to_cpu(di->i_blkno),
> -		     le32_to_cpu(di->i_flags), oi->ip_flags);
> -		goto bail;

	This should not be inside the ORPHANED_FL check.  Every inode in
the orphan_dir, whether a reflink target or an unlinked inode, should
have ORPHANED_FL set.  I think this is why others were confused.
	Tao, were you removing the ORPHANED_FL from reflink targets?

> +		if (!(di->i_dyn_features &
> +		      cpu_to_le16(OCFS2_HAS_REFCOUNT_FL))) {
> +			status = -EEXIST;
> +			mlog(ML_ERROR,
> +			     "Inode %llu (on-disk %llu) not orphaned! "
> +			     "Disk flags  0x%x, inode flags 0x%x\n",
> +			     (unsigned long long)oi->ip_blkno,
> +			     (unsigned long long)le64_to_cpu(di->i_blkno),
> +			     le32_to_cpu(di->i_flags), oi->ip_flags);
> +			goto bail;
> +		} else {
> +			/*
> +			 * It did happen to us, though it's a rare case:
> +			 * orphan_scan() detects the half-refcounted inode
> +			 * in orphan_dir, and delete_inode() attempts to
> +			 * wipe it after reflink operation done later. now
> +			 * we're not allowed to delete such a valid inode,
> +			 * instead, just bail out.
> +			 */
> +			mlog(0, "Skipping delete of %llu because it's a "
> +			     "reflinked inode\n",
> +			     (unsigned long long)oi->ip_blkno);
> +			goto bail;

	Second, this looks like it skips all reflink targets.  That's
not OK.  Sometimes they do need to be deleted.

Joel

-- 

Life's Little Instruction Book #306

	"Take a nap on Sunday afternoons."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
