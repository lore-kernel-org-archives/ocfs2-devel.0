From: piaojun <piaojun@huawei.com>
Date: Wed, 29 Nov 2017 17:05:51 +0800
Subject: [Ocfs2-devel] [PATCH v2 1/3] ocfs2: add ocfs2_try_rw_lock and
 ocfs2_try_inode_lock
In-Reply-To: <1511944612-9629-2-git-send-email-ghe@suse.com>
References: <1511944612-9629-1-git-send-email-ghe@suse.com>
	<1511944612-9629-2-git-send-email-ghe@suse.com>
Message-ID: <5A1E786F.4080103@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, mfasheh@versity.com, jlbec@evilplan.org, rgoldwyn@suse.com, hch@lst.de
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com



On 2017/11/29 16:36, Gang He wrote:
> Add ocfs2_try_rw_lock and ocfs2_try_inode_lock functions, which
> will be used in non-block IO scenarios.
> 
> Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ocfs2/dlmglue.c | 21 +++++++++++++++++++++
>  fs/ocfs2/dlmglue.h |  4 ++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 4689940..a68efa3 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1742,6 +1742,27 @@ int ocfs2_rw_lock(struct inode *inode, int write)
>  	return status;
>  }
>  
> +int ocfs2_try_rw_lock(struct inode *inode, int write)
> +{
> +	int status, level;
> +	struct ocfs2_lock_res *lockres;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	mlog(0, "inode %llu try to take %s RW lock\n",
> +	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> +	     write ? "EXMODE" : "PRMODE");
> +
> +	if (ocfs2_mount_local(osb))
> +		return 0;
> +
> +	lockres = &OCFS2_I(inode)->ip_rw_lockres;
> +
> +	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
> +
> +	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
> +	return status;
> +}
> +
>  void ocfs2_rw_unlock(struct inode *inode, int write)
>  {
>  	int level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
> diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
> index a7fc18b..05910fc 100644
> --- a/fs/ocfs2/dlmglue.h
> +++ b/fs/ocfs2/dlmglue.h
> @@ -116,6 +116,7 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
>  int ocfs2_create_new_inode_locks(struct inode *inode);
>  int ocfs2_drop_inode_locks(struct inode *inode);
>  int ocfs2_rw_lock(struct inode *inode, int write);
> +int ocfs2_try_rw_lock(struct inode *inode, int write);
>  void ocfs2_rw_unlock(struct inode *inode, int write);
>  int ocfs2_open_lock(struct inode *inode);
>  int ocfs2_try_open_lock(struct inode *inode, int write);
> @@ -140,6 +141,9 @@ int ocfs2_inode_lock_with_page(struct inode *inode,
>  /* 99% of the time we don't want to supply any additional flags --
>   * those are for very specific cases only. */
>  #define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full_nested(i, b, e, 0, OI_LS_NORMAL)
> +#define ocfs2_try_inode_lock(i, b, e)\
> +		ocfs2_inode_lock_full_nested(i, b, e, OCFS2_META_LOCK_NOQUEUE,\
> +		OI_LS_NORMAL)
>  void ocfs2_inode_unlock(struct inode *inode,
>  		       int ex);
>  int ocfs2_super_lock(struct ocfs2_super *osb,
> 
