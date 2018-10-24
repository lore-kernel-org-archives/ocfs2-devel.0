From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 24 Oct 2018 18:37:49 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: dlmfs: remove set but not used
	variable 'status'
In-Reply-To: <1540300179-26697-1-git-send-email-zhongjiang@huawei.com>
References: <1540300179-26697-1-git-send-email-zhongjiang@huawei.com>
Message-ID: <ffed747e-b06e-d691-0df0-e0d39ae4ac5c@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhong jiang <zhongjiang@huawei.com>, akpm@linux-foundation.org, mark@fasheh.com, jlbec@evilplan.org
Cc: dhowells@redhat.com, piaojun@huawei.com, viro@zeniv.linux.org.uk, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 18/10/23 21:09, zhong jiang wrote:
> status is not used after setting its value. It is safe to remove
> the unused variable.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Acked-by: Joseph Qi <jiangqi903@gmail.com>

> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 642e471..b03dd46 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -179,7 +179,7 @@ static int dlmfs_file_open(struct inode *inode,
>  static int dlmfs_file_release(struct inode *inode,
>  			      struct file *file)
>  {
> -	int level, status;
> +	int level;
>  	struct dlmfs_inode_private *ip = DLMFS_I(inode);
>  	struct dlmfs_filp_private *fp = file->private_data;
>  
> @@ -188,7 +188,6 @@ static int dlmfs_file_release(struct inode *inode,
>  
>  	mlog(0, "close called on inode %lu\n", inode->i_ino);
>  
> -	status = 0;
>  	if (fp) {
>  		level = fp->fp_lock_level;
>  		if (level != DLM_LOCK_IV)
> 
