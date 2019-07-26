From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 26 Jul 2019 17:39:37 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] fs: ocfs2: Fix a possible
 null-pointer dereference in ocfs2_info_scan_inode_alloc()
In-Reply-To: <20190726033717.32359-1-baijiaju1990@gmail.com>
References: <20190726033717.32359-1-baijiaju1990@gmail.com>
Message-ID: <3db34626-a87f-9de8-6f9c-e4a35f863cd6@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jia-Ju Bai <baijiaju1990@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 19/7/26 11:37, Jia-Ju Bai wrote:
> In ocfs2_info_scan_inode_alloc(), there is an if statement on line 283
> to check whether inode_alloc is NULL:
>     if (inode_alloc)
> 
> When inode_alloc is NULL, it is used on line 287:
>     ocfs2_inode_lock(inode_alloc, &bh, 0);
>         ocfs2_inode_lock_full_nested(inode, ...)
>             struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, inode_alloc is checked on line 286.
> 
> This bug is found by a static analysis tool STCheck written by us.       
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index d6f7b299eb23..efeea208fdeb 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -283,7 +283,7 @@ static int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
>  	if (inode_alloc)
>  		inode_lock(inode_alloc);
>  
> -	if (o2info_coherent(&fi->ifi_req)) {
> +	if (inode_alloc && o2info_coherent(&fi->ifi_req)) {
>  		status = ocfs2_inode_lock(inode_alloc, &bh, 0);
>  		if (status < 0) {
>  			mlog_errno(status);
> 
