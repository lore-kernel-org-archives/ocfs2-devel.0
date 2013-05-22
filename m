From: shencanquan <shencanquan@huawei.com>
Date: Wed, 22 May 2013 10:31:59 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_prep_new_orphaned_file should
 return ret
In-Reply-To: <1369186996-7127-1-git-send-email-xiaowei.hu@oracle.com>
References: <1369186996-7127-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <519C2E1F.40507@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

if return 0,  what's wrong with this?
On 2013/5/22 9:43, xiaowei.hu at oracle.com wrote:
> From: "Xiaowei.Hu"<xiaowei.hu@oracle.com>
>
> ---
>   fs/ocfs2/namei.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 50c93a8..422cbe0 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2216,7 +2216,7 @@ out:
>
>   	brelse(orphan_dir_bh);
>
> -	return 0;
> +	return ret;
>   }
>
>   int ocfs2_create_inode_in_orphan(struct inode *dir,
