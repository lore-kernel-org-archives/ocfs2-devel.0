From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 9 Mar 2011 15:01:32 -0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: do not allow fallocate on dir file
In-Reply-To: <201103041510.33128.lidongyang@novell.com>
References: <201103041510.33128.lidongyang@novell.com>
Message-ID: <20110309230132.GF1703@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 04, 2011 at 03:10:33PM +0800, Li Dongyang wrote:
> allowing fallocate() on dir file doesn't make sense, we check if
> we are dealing with a regular file and return -EINVAL when it's not,
> Thanks
> 
> Signed-off-by: Li Dongyang <lidongyang@novell.com>
> ---
>  fs/ocfs2/file.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index a665195..0c68a61 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1870,6 +1870,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  		goto out_inode_unlock;
>  	}
>  
> +	if (!S_ISREG(inode->i_mode)) {
> +		ret = -EINVAL;
> +		goto out_inode_unlock;
> +	}

You might want to move the check into ocfs2_fallocate to mirror what
ocfs2_change_file_space() does. Otherwise, looks like a good catch.
	--Mark

--
Mark Fasheh
