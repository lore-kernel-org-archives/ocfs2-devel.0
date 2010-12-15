From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 15 Dec 2010 12:26:25 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Hold ip_lock when set/clear flags
 for indexed dir.
In-Reply-To: <1292401800-14014-1-git-send-email-tm@tao.ma>
References: <1292401800-14014-1-git-send-email-tm@tao.ma>
Message-ID: <4D092471.9030205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by Sunil Mushran <sunil.mushran@oracle.com>

On 12/15/2010 12:30 AM, Tao Ma wrote:
> From: Tao Ma<boyu.mt@taobao.com>
>
> When we set/clear the dyn_features for an inode we hold the ip_lock.
> So do it when we set/clear OCFS2_INDEXED_DIR_FL also.
>
> Signed-off-by: Tao Ma<boyu.mt@taobao.com>
> ---
>   fs/ocfs2/dir.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index c49f6de..d417b3f 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -2461,8 +2461,10 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
>
>   	di->i_dx_root = cpu_to_le64(dr_blkno);
>
> +	spin_lock(&OCFS2_I(dir)->ip_lock);
>   	OCFS2_I(dir)->ip_dyn_features |= OCFS2_INDEXED_DIR_FL;
>   	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
> +	spin_unlock(&OCFS2_I(dir)->ip_lock);
>
>   	ocfs2_journal_dirty(handle, di_bh);
>
> @@ -4466,8 +4468,10 @@ static int ocfs2_dx_dir_remove_index(struct inode *dir,
>   		goto out_commit;
>   	}
>
> +	spin_lock(&OCFS2_I(dir)->ip_lock);
>   	OCFS2_I(dir)->ip_dyn_features&= ~OCFS2_INDEXED_DIR_FL;
>   	di->i_dyn_features = cpu_to_le16(OCFS2_I(dir)->ip_dyn_features);
> +	spin_unlock(&OCFS2_I(dir)->ip_lock);
>   	di->i_dx_root = cpu_to_le64(0ULL);
>
>   	ocfs2_journal_dirty(handle, di_bh);
