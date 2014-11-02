From: Julia Lawall <julia.lawall@lip6.fr>
Date: Sun, 2 Nov 2014 11:51:40 +0100 (CET)
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Deletion of unnecessary checks
 before two function calls
In-Reply-To: <5455FC05.4010606@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5455FC05.4010606@users.sourceforge.net>
Message-ID: <alpine.DEB.2.02.1411021150540.2239@localhost6.localdomain6>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cocci@systeme.lip6.fr

On Sun, 2 Nov 2014, SF Markus Elfring wrote:

> The functions iput() and ocfs2_free_path() test whether their argument
> is NULL and then return immediately. Thus the test around the call
> is not needed.

Please check whether more labels could be added to avoid executing 
unnecessary code.

julia


> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/ocfs2/alloc.c      | 15 +++++----------
>  fs/ocfs2/ioctl.c      |  3 +--
>  fs/ocfs2/journal.c    |  9 +++------
>  fs/ocfs2/localalloc.c |  9 +++------
>  fs/ocfs2/namei.c      |  3 +--
>  fs/ocfs2/slot_map.c   |  3 +--
>  fs/ocfs2/super.c      |  3 +--
>  7 files changed, 15 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index a93bf98..2e0ab63 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -3453,8 +3453,7 @@ static int ocfs2_merge_rec_right(struct ocfs2_path *left_path,
>  					   subtree_index);
>  	}
>  out:
> -	if (right_path)
> -		ocfs2_free_path(right_path);
> +	ocfs2_free_path(right_path);
>  	return ret;
>  }
> 
> @@ -3647,8 +3646,7 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
>  						   right_path, subtree_index);
>  	}
>  out:
> -	if (left_path)
> -		ocfs2_free_path(left_path);
> +	ocfs2_free_path(left_path);
>  	return ret;
>  }
> 
> @@ -4431,10 +4429,8 @@ ocfs2_figure_merge_contig_type(struct ocfs2_extent_tree *et,
>  	}
> 
>  out:
> -	if (left_path)
> -		ocfs2_free_path(left_path);
> -	if (right_path)
> -		ocfs2_free_path(right_path);
> +	ocfs2_free_path(left_path);
> +	ocfs2_free_path(right_path);
> 
>  	return ret;
>  }
> @@ -6157,8 +6153,7 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
>  	}
> 
>  bail:
> -	if (tl_inode)
> -		iput(tl_inode);
> +	iput(tl_inode);
>  	brelse(tl_bh);
> 
>  	if (status < 0 && (*tl_copy)) {
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index 53e6c40..28afb56 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -606,8 +606,7 @@ bail:
>  	if (gb_inode)
>  		mutex_unlock(&gb_inode->i_mutex);
> 
> -	if (gb_inode)
> -		iput(gb_inode);
> +	iput(gb_inode);
> 
>  	brelse(bh);
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 4b0c688..f94be68 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -1009,8 +1009,7 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
> 
>  //	up_write(&journal->j_trans_barrier);
>  done:
> -	if (inode)
> -		iput(inode);
> +	iput(inode);
>  }
> 
>  static void ocfs2_clear_journal_error(struct super_block *sb,
> @@ -1646,8 +1645,7 @@ done:
>  	if (got_lock)
>  		ocfs2_inode_unlock(inode, 1);
> 
> -	if (inode)
> -		iput(inode);
> +	iput(inode);
> 
>  	brelse(bh);
> 
> @@ -1755,8 +1753,7 @@ static int ocfs2_trylock_journal(struct ocfs2_super *osb,
> 
>  	ocfs2_inode_unlock(inode, 1);
>  bail:
> -	if (inode)
> -		iput(inode);
> +	iput(inode);
> 
>  	return status;
>  }
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 0440134..7eca277 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -358,8 +358,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>  bail:
>  	if (status < 0)
>  		brelse(alloc_bh);
> -	if (inode)
> -		iput(inode);
> +	iput(inode);
> 
>  	trace_ocfs2_load_local_alloc(osb->local_alloc_bits);
> 
> @@ -473,8 +472,7 @@ out_mutex:
>  	iput(main_bm_inode);
> 
>  out:
> -	if (local_alloc_inode)
> -		iput(local_alloc_inode);
> +	iput(local_alloc_inode);
> 
>  	kfree(alloc_copy);
>  }
> @@ -1328,8 +1326,7 @@ bail:
> 
>  	brelse(main_bm_bh);
> 
> -	if (main_bm_inode)
> -		iput(main_bm_inode);
> +	iput(main_bm_inode);
> 
>  	kfree(alloc_copy);
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 8add6f1..a02593d 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1607,8 +1607,7 @@ bail:
>  	if (new_inode)
>  		sync_mapping_buffers(old_inode->i_mapping);
> 
> -	if (new_inode)
> -		iput(new_inode);
> +	iput(new_inode);
> 
>  	ocfs2_free_dir_lookup_result(&target_lookup_res);
>  	ocfs2_free_dir_lookup_result(&old_entry_lookup);
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index a88b2a4..c5c6eb0 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -322,8 +322,7 @@ static void __ocfs2_free_slot_info(struct ocfs2_slot_info *si)
>  	if (si == NULL)
>  		return;
> 
> -	if (si->si_inode)
> -		iput(si->si_inode);
> +	iput(si->si_inode);
>  	if (si->si_bh) {
>  		for (i = 0; i < si->si_blocks; i++) {
>  			if (si->si_bh[i]) {
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 4142546..5860f0f 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1723,8 +1723,7 @@ static int ocfs2_statfs(struct dentry *dentry, struct
> kstatfs *buf)
>  	ocfs2_inode_unlock(inode, 0);
>  	status = 0;
>  bail:
> -	if (inode)
> -		iput(inode);
> +	iput(inode);
> 
>  	if (status)
>  		mlog_errno(status);
> -- 
> 2.1.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
