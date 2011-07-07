From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 07 Jul 2011 13:09:11 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: let ocfs2_dir_foreach return
 the error turned by filldir
In-Reply-To: <201107060539.p665dfRB020547@acsmt356.oracle.com>
References: <201107060539.p665dfRB020547@acsmt356.oracle.com>
Message-ID: <4E161267.8050000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/05/2011 09:40 PM, Wengang Wang wrote:
> Let ocfs2_dir_foreach return the error turned by filldir.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dir.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8582e3f..6d7560a 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -2005,6 +2005,8 @@ int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
>
>   	if (ret>  0)
>   		ret = -EIO;
> +	if (!ret)
> +		ret = filldir_err;
>
>   	return 0;
>   }

That's not enough. Shouldn't it be "return ret" too.

Have you triggered this error manually? I have never seen reports of it
before.
