From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 31 Jul 2009 10:46:02 +0800
Subject: [Ocfs2-devel] [PATCH 3/9] Implement quota functions to libocfs2
In-Reply-To: <1248974064-29462-4-git-send-email-jack@suse.cz>
References: <1248974064-29462-1-git-send-email-jack@suse.cz>
	<1248974064-29462-4-git-send-email-jack@suse.cz>
Message-ID: <4A725AEA.5050107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/ocfs2/ocfs2.h     |   87 ++++
>  libocfs2/Makefile         |    1 +
>  libocfs2/feature_string.c |   18 +
>  libocfs2/ocfs2_err.et     |    6 +
>  libocfs2/quota.c          | 1216 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 1328 insertions(+), 0 deletions(-)
>  create mode 100644 libocfs2/quota.c
> 
> diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
> index 47fede3..9f861d6 100644
> --- a/include/ocfs2/ocfs2.h
> +++ b/include/ocfs2/ocfs2.h
> +#define OCFS2_LOCAL_QF_INIT_BLOCKS 2
> +
> +errcode_t ocfs2_init_local_quota_file(ocfs2_filesys *fs, int type,
> +				      uint64_t blkno)
> +{
> +	ocfs2_cached_inode *ci = NULL;
> +	struct ocfs2_dinode *di;
> +	struct ocfs2_disk_dqheader *header;
> +	struct ocfs2_local_disk_dqinfo *info;
> +	unsigned int magics[] = OCFS2_LOCAL_QMAGICS;
> +	int versions[] = OCFS2_LOCAL_QVERSIONS;
> +	char *buf = NULL;
> +	unsigned int written;
> +	int bytes = ocfs2_blocks_to_bytes(fs, OCFS2_LOCAL_QF_INIT_BLOCKS);
> +	errcode_t err;
> +
> +	err = ocfs2_read_cached_inode(fs, blkno, &ci);
> +	if (err)
> +		goto out;
> +
> +	if (!(ci->ci_inode->i_flags & OCFS2_VALID_FL) ||
> +	    !(ci->ci_inode->i_flags & OCFS2_SYSTEM_FL) ||
> +	    !(ci->ci_inode->i_flags & OCFS2_QUOTA_FL)) {
> +		err = OCFS2_ET_INTERNAL_FAILURE;
> +		goto out;
> +	}
> +	di = ci->ci_inode;
> +
> +	/* We need at least two blocks */
> +	err = ocfs2_cached_inode_extend_allocation(ci,
> +		ocfs2_clusters_in_blocks(fs, OCFS2_LOCAL_QF_INIT_BLOCKS));
> +	if (err)
> +		goto out;
> +	di->i_size = bytes;
> +	di->i_mtime = time(NULL);
> +	err = ocfs2_write_inode(fs, blkno, (char *)di);
> +	if (err)
> +		goto out;
> +
> +	err = ocfs2_malloc_blocks(fs->fs_io, bytes, &buf);
hey, ocfs2_malloc_blocks need num_blocks, not "bytes". so maybe 
OCFS2_LOCAL_QF_INIT_BLOCKS?

Oh, I just checked your v1, it was there. I am so sorry for not finding 
it earlier. And please change all of them in this patch.
> +/* Get free block in file (either from free list or create new one) */
> +static errcode_t ocfs2_get_free_dqblk(ocfs2_filesys *fs, int type,
> +				      unsigned int *blk)
> +{
> +	errcode_t err;
> +	char *buf;
> +	struct qt_disk_dqdbheader *dh;
> +	struct ocfs2_global_disk_dqinfo *info = &(fs->qinfo[type].qi_info);
> +	ocfs2_cached_inode *ci = fs->qinfo[type].qi_inode;
> +
> +	err = ocfs2_malloc_block(fs->fs_io, &buf);
> +	if (err)
> +		return err;
> +	dh = (struct qt_disk_dqdbheader *)buf;
> +	if (info->dqi_free_blk) {
> +		*blk = info->dqi_free_blk;
> +		err = read_blk(fs, type, *blk, buf);
> +		if (err)
> +			goto bail;
> +		info->dqi_free_blk = le32_to_cpu(dh->dqdh_next_free);
> +	}
> +	else {
> +		if (info->dqi_blocks ==
> +		    ocfs2_clusters_to_blocks(fs, ci->ci_inode->i_clusters)) {
> +			err = ocfs2_cached_inode_extend_allocation(ci, 1);
> +			if (err)
> +				goto bail;
> +		}
> +		*blk = info->dqi_blocks++;
> +		ci->ci_inode->i_size =
> +				ocfs2_blocks_to_bytes(fs, info->dqi_blocks);
I am interested in this part. I read the kernel part yesterday. There 
you often check whether we need to add a chunk header in which case we 
need to extend the file by 2 blocks actually. But here we just extend 1 
cluster? Is this a little different from the kernel part or we just 
simplify the case in the userspace? Please help me clarify it. Thanks.
> +	}
> +	mark_quotafile_info_dirty(fs, type);
> +bail:
> +	ocfs2_free(&buf);
> +	return err;
> +}

Regards,
Tao
