From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 8 Apr 2020 09:00:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: no need try to truncate file
	beyond i_size
In-Reply-To: <20200407082754.17565-1-chge@linux.alibaba.com>
References: <20200407082754.17565-1-chge@linux.alibaba.com>
Message-ID: <99addbc4-b213-723b-dddd-7f04554dc744@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2020/4/7 16:27, Changwei Ge wrote:
> Linux fallocate(2) with FALLOC_FL_PUNCH_HOLE mode set, its offset can
> exceed inode size. Ocfs2 now does't allow that offset beyond inode size.
> This restriction is not necessary and voilates fallocate(2) semantics.
> 
> If fallocate(2) offset is beyond inode size, just return success and do
> nothing further.
> 
> Otherwise, ocfs2 will crash the kernel.
> 
> ---
> kernel BUG at fs/ocfs2//alloc.c:7264!
>  ocfs2_truncate_inline+0x20f/0x360 [ocfs2]
>  ? ocfs2_read_blocks+0x2f3/0x5f0 [ocfs2]
>  ocfs2_remove_inode_range+0x23c/0xcb0 [ocfs2]
>  ? ocfs2_read_inode_block+0x10/0x20 [ocfs2]
>  ? ocfs2_allocate_extend_trans+0x1a0/0x1a0 [ocfs2]
>  __ocfs2_change_file_space+0x4a5/0x650 [ocfs2]
>  ocfs2_fallocate+0x83/0xa0 [ocfs2]
>  ? __audit_syscall_entry+0xb8/0x100
>  ? __sb_start_write+0x3b/0x70
>  vfs_fallocate+0x148/0x230
>  SyS_fallocate+0x48/0x80
>  do_syscall_64+0x79/0x170
> 
> Signed-off-by: Changwei Ge <chge@linux.alibaba.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> Cc: <stable@vger.kernel.org>
> ---
>  fs/ocfs2/alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 88534eb0e7c..3d5b6b989db 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7403,6 +7403,10 @@ int ocfs2_truncate_inline(struct inode *inode, struct buffer_head *di_bh,
>  	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>  	struct ocfs2_inline_data *idata = &di->id2.i_data;
>  
> +	/* No need to punch hole beyond i_size. */
> +	if (start >= i_size_read(inode))
> +		return 0;
> +
>  	if (end > i_size_read(inode))
>  		end = i_size_read(inode);
>  
> 
