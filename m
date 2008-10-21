From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 16:34:46 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add quota calls for allocation	and
	freeing of inodes and space
In-Reply-To: <1224523443806-git-send-email-jack@suse.cz>
References: <1224523443806-git-send-email-jack@suse.cz>
Message-ID: <20081021233446.GI2871@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:58PM +0200, Jan Kara wrote:
> Add quota calls for allocation and freeing of inodes and space, also update
> estimates on number of needed credits for a transaction. Move out inode
> allocation from ocfs2_mknod_locked() because vfs_dq_init() must be called
> outside of a transaction.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> @@ -5954,6 +5955,8 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> +	vfs_dq_free_space_nodirty(inode,
> +			ocfs2_clusters_to_bytes(osb->sb, clusters_to_del));
>  	spin_lock(&OCFS2_I(inode)->ip_lock);
>  	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters) -
>  				      clusters_to_del;

	In this one instance, you don't clean up the quota change on
error, even though clusters_to_del might remain allocated.  How come?
	On that note, I don't see us a) fixing the inode up on failure
or b) writing out the new values.  Now, I remember from the past that we
allow a smaller i_clusters than actually in the tree, because our alloc
code can handle that.  So I'm sure that the fallout from us not fixing
up i_clusters and/or writing it is safe.
	But I wonder what the right behavior is with regards to quota.

> @@ -908,7 +911,8 @@ void ocfs2_delete_inode(struct inode *inode)
>  
>  	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
>  
> -	if (is_bad_inode(inode)) {
> +	/* Inode left after unsuccessful inode allocation? */
> +	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno) {
>  		mlog(0, "Skipping delete of bad inode\n");
>  		goto bail;
>  	}

	!ip_blkno is your way of saying you called
ocfs2_get_init_inode() but failed ocfs2_claim_new_inode() in
ocfs2_mknod_locked(), right?  Probably want to adjust your comment to
point out that is_bad_inode() comes from read_inode(), !ip_blkno from
mknod().
	I checked into just having your failed mknod() call
make_bad_inode(), but it doesn't fit.  We don't even want to get there.

Joel

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
