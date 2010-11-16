From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 16 Nov 2010 09:19:08 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlmfs: use GFP_KERNEL instead of
 GFP_NOFS
In-Reply-To: <201011161537.oAG4gEQI002875@acsinet15.oracle.com>
References: <201011161537.oAG4gEQI002875@acsinet15.oracle.com>
Message-ID: <4CE2BD0C.3020501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We do NOFS allocs in the dlm to prevent deadlocks (not live locks).
And you are right we don't have to do NOFS allocs here. But the sizes
we are talking about are really small. Do we really care?

On 11/16/2010 07:33 AM, Wengang Wang wrote:
> There is no need for dlmfs to sync data to disk so that no memory is needed
> for that purpose. So no worry about the live lock: sync data ->  alloc mem ->
> sync data ->.... We'd better use GFP_KERNEL instead of GFP_NOFS to allow FS sync
> during the memory allocation.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dlmfs/dlmfs.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index b2df490..979b593 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -151,7 +151,7 @@ static int dlmfs_file_open(struct inode *inode,
>   	 * doesn't make sense for LVB writes. */
>   	file->f_flags&= ~O_APPEND;
>
> -	fp = kmalloc(sizeof(*fp), GFP_NOFS);
> +	fp = kmalloc(sizeof(*fp), GFP_KERNEL);
>   	if (!fp) {
>   		status = -ENOMEM;
>   		goto bail;
> @@ -265,7 +265,7 @@ static ssize_t dlmfs_file_read(struct file *filp,
>   	else
>   		readlen = count;
>
> -	lvb_buf = kmalloc(readlen, GFP_NOFS);
> +	lvb_buf = kmalloc(readlen, GFP_KERNEL);
>   	if (!lvb_buf)
>   		return -ENOMEM;
>
> @@ -313,7 +313,7 @@ static ssize_t dlmfs_file_write(struct file *filp,
>   	else
>   		writelen = count - *ppos;
>
> -	lvb_buf = kmalloc(writelen, GFP_NOFS);
> +	lvb_buf = kmalloc(writelen, GFP_KERNEL);
>   	if (!lvb_buf)
>   		return -ENOMEM;
>
> @@ -344,7 +344,7 @@ static struct inode *dlmfs_alloc_inode(struct super_block *sb)
>   {
>   	struct dlmfs_inode_private *ip;
>
> -	ip = kmem_cache_alloc(dlmfs_inode_cache, GFP_NOFS);
> +	ip = kmem_cache_alloc(dlmfs_inode_cache, GFP_KERNEL);
>   	if (!ip)
>   		return NULL;
>
