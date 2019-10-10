From: Joseph Qi <jiangqi903@gmail.com>
Date: Thu, 10 Oct 2019 16:49:46 +0800
Subject: [Ocfs2-devel] (RESEND) [PATCH] ocfs2: Fix error handling in
	ocfs2_setattr()
In-Reply-To: <20191010082349.1134-1-cgxu519@mykernel.net>
References: <20191010082349.1134-1-cgxu519@mykernel.net>
Message-ID: <6c6a49dd-f1e6-da3e-8481-071071c91b06@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengguang Xu <cgxu519@mykernel.net>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com



On 19/10/10 16:23, Chengguang Xu wrote:
> Should set transfer_to[USRQUOTA/GRPQUOTA] to NULL
> on error case before jump to do dqput().
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Looks good.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/file.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 2e982db3e1ae..53939bf9d7d2 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1230,6 +1230,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
>  			if (IS_ERR(transfer_to[USRQUOTA])) {
>  				status = PTR_ERR(transfer_to[USRQUOTA]);
> +				transfer_to[USRQUOTA] = NULL;
>  				goto bail_unlock;
>  			}
>  		}
> @@ -1239,6 +1240,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
>  			if (IS_ERR(transfer_to[GRPQUOTA])) {
>  				status = PTR_ERR(transfer_to[GRPQUOTA]);
> +				transfer_to[GRPQUOTA] = NULL;
>  				goto bail_unlock;
>  			}
>  		}
> 
