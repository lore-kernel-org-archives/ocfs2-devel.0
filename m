From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 2 Sep 2008 18:11:45 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix a bug in direct IO read.
In-Reply-To: <1220316655-4400-1-git-send-email-tao.ma@oracle.com>
References: <1220316655-4400-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20080903011145.GC4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 02, 2008 at 08:50:55AM +0800, Tao Ma wrote:
> ocfs2 will become read-only if we try to read the bytes which pass
> the end of i_size. This can be easily reproduced by following steps:
> 1. mkfs a ocfs2 volume with bs=4k cs=4k and nosparse.
> 2. create a small file(say less than 100 bytes) and we will create the file
>    which is allocated 1 cluster.
> 3. read 8196 bytes from the kernel using O_DIRECT which exceeds the limit.
> 4. The ocfs2 volume becomes read-only and dmesg shows:
> OCFS2: ERROR (device sda13): ocfs2_direct_IO_get_blocks:
> Inode 66010 has a hole at block 1
> File system is now read-only due to the potential of on-disk corruption.
> Please run fsck.ocfs2 once the file system is unmounted.
> 
> I have checked the code of 1.2 and copy the read check there.
> And actually I think even with sparse-enabled, this read check is ok.

Hmm - in this case we're supposed to return a short read. I think actually
the fix is a bit below at this line, where you're hitting the problem:

	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno) {
		ocfs2_error(inode->i_sb,
			    "Inode %llu has a hole at block %llu\n",
			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
			    (unsigned long long)iblock);
		ret = -EROFS;
		goto bail;
	}


How about changing that to:

        if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno && create) {


So that we only check if there's a write (which really *is* something that
shouldn't happen for Ocfs2).

The rest of the code looks like it should handle things by clearing the
mapped bitt, which is correct.
	--Mark

> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/aops.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 80fa3fc..f27c1cc 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -576,6 +576,14 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
>  	inode_blocks = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
>  
>  	/*
> +	 * For a read which begins past the end of file, we return a hole.
> +	 */
> +	if (!create && (iblock >= inode_blocks)) {
> +		ret = 0;
> +		goto bail;
> +	}
> +
> +	/*
>  	 * Any write past EOF is not allowed because we'd be extending.
>  	 */
>  	if (create && (iblock + max_blocks) > inode_blocks) {
> -- 
> 1.5.4.GIT
--
Mark Fasheh
