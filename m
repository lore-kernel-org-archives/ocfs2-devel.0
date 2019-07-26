From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 26 Jul 2019 17:38:10 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] fs: ocfs2: Fix a possible
 null-pointer dereference in ocfs2_write_end_nolock()
In-Reply-To: <20190726033705.32307-1-baijiaju1990@gmail.com>
References: <20190726033705.32307-1-baijiaju1990@gmail.com>
Message-ID: <cdec8b79-a854-e9b0-21af-897c7eedc454@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jia-Ju Bai <baijiaju1990@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 19/7/26 11:37, Jia-Ju Bai wrote:
> In ocfs2_write_end_nolock(), there are an if statement on lines 1976, 
> 2047 and 2058, to check whether handle is NULL:
>     if (handle)
> 
> When handle is NULL, it is used on line 2045:
> 	ocfs2_update_inode_fsync_trans(handle, inode, 1);
>         oi->i_sync_tid = handle->h_transaction->t_tid;
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, handle is checked before calling
> ocfs2_update_inode_fsync_trans().
> 
> This bug is found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/aops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index a4c905d6b575..5473bd99043e 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2042,7 +2042,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
>  		inode->i_mtime = inode->i_ctime = current_time(inode);
>  		di->i_mtime = di->i_ctime = cpu_to_le64(inode->i_mtime.tv_sec);
>  		di->i_mtime_nsec = di->i_ctime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
> -		ocfs2_update_inode_fsync_trans(handle, inode, 1);
> +		if (handle)
> +			ocfs2_update_inode_fsync_trans(handle, inode, 1);
>  	}
>  	if (handle)
>  		ocfs2_journal_dirty(handle, wc->w_di_bh);
> 
