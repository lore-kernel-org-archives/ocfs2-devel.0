From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 21:44:10 +0800
Subject: [Ocfs2-devel] [patch] ocfs2: potential ERR_PTR dereference on
	error paths
In-Reply-To: <20100422093929.GK29647@bicker>
References: <20100422093929.GK29647@bicker>
Message-ID: <4BD052AA.2090401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dan Carpenter wrote:
> If "handle" is non null at the end of the function then we assume it's a
> valid pointer and pass it to ocfs2_commit_trans();
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 07cc8bb..ae8e161 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -558,6 +558,7 @@ static int ocfs2_truncate_for_delete(struct ocfs2_super *osb,
>  		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
>  		if (IS_ERR(handle)) {
>  			status = PTR_ERR(handle);
> +			handle = NULL;
>  			mlog_errno(status);
>  			goto out;
>  		}
>   
Good catch.
Acked-by: Tao Ma <tao.ma@oracle.com>
