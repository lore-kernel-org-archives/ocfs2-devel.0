From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 17 Nov 2010 10:40:14 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2-1.4: Backport mainline commit
 'Journaling i_flags and i_orphaned_slot when adding inode to orphan dir' to
 ocfs2-1.4
In-Reply-To: <1289969189-4322-1-git-send-email-tristan.ye@oracle.com>
References: <1289969189-4322-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <4CE4218E.7020607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks. Please push it to the 1.4 repo.

On 11/16/2010 08:46 PM, Tristan Ye wrote:
> Mainline commit 3939fda4b389993caf8741df5739b3e49f33a263
>
> Currently, some callers were missing to journal the dirty inode after
> adding it to orphan dir.
>
> Now we're going to journal such modifications within the ocfs2_orphan_add()
> itself, It's safe to do so, though some existing caller may duplicate this,
> and it makes the logic look more straightforward anyway.
>
> Signed-off-by: Tristan Ye<tristan.ye@oracle.com>
> Signed-off-by: Joel Becker<joel.becker@oracle.com>
> ---
>   fs/ocfs2/namei.c |   26 ++++++++++++++++++++++----
>   1 files changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index eba1148..d6fd4df 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -82,7 +82,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
>   static int ocfs2_orphan_add(struct ocfs2_super *osb,
>   			    handle_t *handle,
>   			    struct inode *inode,
> -			    struct ocfs2_dinode *fe,
> +			    struct buffer_head *fe_bh,
>   			    char *name,
>   			    struct buffer_head *de_bh,
>   			    struct inode *orphan_dir_inode);
> @@ -792,7 +792,7 @@ static int ocfs2_unlink(struct inode *dir,
>   	fe = (struct ocfs2_dinode *) fe_bh->b_data;
>
>   	if (inode_is_unlinkable(inode)) {
> -		status = ocfs2_orphan_add(osb, handle, inode, fe, orphan_name,
> +		status = ocfs2_orphan_add(osb, handle, inode, fe_bh, orphan_name,
>   					  orphan_entry_bh, orphan_dir);
>   		if (status<  0) {
>   			mlog_errno(status);
> @@ -1206,7 +1206,7 @@ static int ocfs2_rename(struct inode *old_dir,
>   		if (S_ISDIR(new_inode->i_mode) ||
>   		    (newfe->i_links_count == cpu_to_le16(1))){
>   			status = ocfs2_orphan_add(osb, handle, new_inode,
> -						  newfe, orphan_name,
> +						  newfe_bh, orphan_name,
>   						  orphan_entry_bh, orphan_dir);
>   			if (status<  0) {
>   				mlog_errno(status);
> @@ -1742,7 +1742,7 @@ leave:
>   static int ocfs2_orphan_add(struct ocfs2_super *osb,
>   			    handle_t *handle,
>   			    struct inode *inode,
> -			    struct ocfs2_dinode *fe,
> +			    struct buffer_head *fe_bh,
>   			    char *name,
>   			    struct buffer_head *de_bh,
>   			    struct inode *orphan_dir_inode)
> @@ -1750,6 +1750,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>   	struct buffer_head *orphan_dir_bh = NULL;
>   	int status = 0;
>   	struct ocfs2_dinode *orphan_fe;
> +	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
>
>   	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
>
> @@ -1791,6 +1792,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>   		goto leave;
>   	}
>
> +	/*
> +	 * We're going to journal the change of i_flags and i_orphaned_slot.
> +	 * It's safe anyway, though some callers may duplicate the journaling.
> +	 * Journaling within the func just make the logic look more
> +	 * straightforward.
> +	 */
> +	status = ocfs2_journal_access_di(handle,
> +					 INODE_CACHE(inode),
> +					 fe_bh,
> +					 OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status<  0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
>   	le32_add_cpu(&fe->i_flags, OCFS2_ORPHANED_FL);
>
>   	/* Record which orphan dir our inode now resides
> @@ -1798,6 +1814,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>   	 * dir to lock. */
>   	fe->i_orphaned_slot = cpu_to_le16(osb->slot_num);
>
> +	ocfs2_journal_dirty(handle, fe_bh);
> +
>   	mlog(0, "Inode %llu orphaned in slot %d\n",
>   	     (unsigned long long)OCFS2_I(inode)->ip_blkno, osb->slot_num);
>
