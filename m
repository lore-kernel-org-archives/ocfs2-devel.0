From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 12 May 2010 14:09:28 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Block signals for
	mkdir/link/symlink/O_CREAT.
In-Reply-To: <20100510190031.GE25670@mail.oracle.com>
References: <20100510185919.GC25670@mail.oracle.com>
	<20100510190031.GE25670@mail.oracle.com>
Message-ID: <4BEB1908.1030806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran<sunil.mushran@oracle.com>

On 05/10/2010 12:00 PM, Joel Becker wrote:
> Once file or link creation gets going, it can't be interrupted by a
> signal.  They're not idempotent.
>
> This blocks signals in ocfs2_mknod(), ocfs2_link(), and ocfs2_symlink()
> once we start actually changing things.  ocfs2_mknod() covers mknod(),
> creat(), mkdir(), and open(O_CREAT).
>
> Signed-off-by: Joel Becker<joel.becker@oracle.com>
> ---
>   fs/ocfs2/namei.c |   21 +++++++++++++++++++++
>   1 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 21d4a33..607084b 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -239,6 +239,8 @@ static int ocfs2_mknod(struct inode *dir,
>   	};
>   	int did_quota_inode = 0;
>   	struct ocfs2_dir_lookup_result lookup = { NULL, };
> +	sigset_t oldset;
> +	int did_block_signals = 0;
>
>   	mlog_entry("(0x%p, 0x%p, %d, %lu, '%.*s')\n", dir, dentry, mode,
>   		   (unsigned long)dev, dentry->d_name.len,
> @@ -350,6 +352,10 @@ static int ocfs2_mknod(struct inode *dir,
>   		goto leave;
>   	}
>
> +	/* Starting to change things, restart is no longer possible. */
> +	ocfs2_block_signals(&oldset);
> +	did_block_signals = 1;
> +
>   	status = dquot_alloc_inode(inode);
>   	if (status)
>   		goto leave;
> @@ -430,6 +436,8 @@ leave:
>   		ocfs2_commit_trans(osb, handle);
>
>   	ocfs2_inode_unlock(dir, 1);
> +	if (did_block_signals)
> +		ocfs2_unblock_signals(&oldset);
>
>   	if (status == -ENOSPC)
>   		mlog(0, "Disk is full\n");
> @@ -618,6 +626,7 @@ static int ocfs2_link(struct dentry *old_dentry,
>   	struct ocfs2_dinode *fe = NULL;
>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>   	struct ocfs2_dir_lookup_result lookup = { NULL, };
> +	sigset_t oldset;
>
>   	mlog_entry("(inode=%lu, old='%.*s' new='%.*s')\n", inode->i_ino,
>   		   old_dentry->d_name.len, old_dentry->d_name.name,
> @@ -674,6 +683,9 @@ static int ocfs2_link(struct dentry *old_dentry,
>   		goto out_unlock_inode;
>   	}
>
> +	/* Starting to change things, restart is no longer possible. */
> +	ocfs2_block_signals(&oldset);
> +
>   	err = ocfs2_journal_access_di(handle, INODE_CACHE(inode), fe_bh,
>   				      OCFS2_JOURNAL_ACCESS_WRITE);
>   	if (err<  0) {
> @@ -710,6 +722,7 @@ static int ocfs2_link(struct dentry *old_dentry,
>
>   out_commit:
>   	ocfs2_commit_trans(osb, handle);
> +	ocfs2_unblock_signals(&oldset);
>   out_unlock_inode:
>   	ocfs2_inode_unlock(inode, 1);
>
> @@ -1568,6 +1581,8 @@ static int ocfs2_symlink(struct inode *dir,
>   	};
>   	int did_quota = 0, did_quota_inode = 0;
>   	struct ocfs2_dir_lookup_result lookup = { NULL, };
> +	sigset_t oldset;
> +	int did_block_signals = 0;
>
>   	mlog_entry("(0x%p, 0x%p, symname='%s' actual='%.*s')\n", dir,
>   		   dentry, symname, dentry->d_name.len, dentry->d_name.name);
> @@ -1663,6 +1678,10 @@ static int ocfs2_symlink(struct inode *dir,
>   		goto bail;
>   	}
>
> +	/* Starting to change things, restart is no longer possible. */
> +	ocfs2_block_signals(&oldset);
> +	did_block_signals = 1;
> +
>   	status = dquot_alloc_inode(inode);
>   	if (status)
>   		goto bail;
> @@ -1766,6 +1785,8 @@ bail:
>   		ocfs2_commit_trans(osb, handle);
>
>   	ocfs2_inode_unlock(dir, 1);
> +	if (did_block_signals)
> +		ocfs2_unblock_signals(&oldset);
>
>   	brelse(new_fe_bh);
>   	brelse(parent_fe_bh);
>    
