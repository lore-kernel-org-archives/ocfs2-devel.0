From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Sun, 14 Jun 2020 20:26:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: avoid inode removed while nfsd
 access it
In-Reply-To: <20200612001956.57851-1-junxiao.bi@oracle.com>
References: <20200612001956.57851-1-junxiao.bi@oracle.com>
Message-ID: <1675b72f-2c8f-d375-d1ad-87c2930a7b85@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 2020/6/12 08:19, Junxiao Bi wrote:
> When nfsd is getting file dentry using handle or parent dentry of some
> dentry, one cluster lock is used to avoid inode removed from other node,
> but it still could be removed from local node, so use a rw lock to avoid
> this.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c | 17 ++++++++++++++---
>  fs/ocfs2/ocfs2.h   |  1 +
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 152a0fc4e905..c5e84314e203 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -678,15 +678,17 @@ static void ocfs2_rename_lock_res_init(struct ocfs2_lock_res *res,
>  				   &ocfs2_rename_lops, osb);
>  }
>  
> -static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_lock_res *res,
> -					 struct ocfs2_super *osb)
> +static void ocfs2_nfs_sync_lock_res_init(struct ocfs2_super *osb)
>  {
> +	struct ocfs2_lock_res *res = &osb->osb_nfs_sync_lockres;
> +
>  	/* nfs_sync lockres doesn't come from a slab so we call init
>  	 * once on it manually.  */
>  	ocfs2_lock_res_init_once(res);
>  	ocfs2_build_lock_name(OCFS2_LOCK_TYPE_NFS_SYNC, 0, 0, res->l_name);
>  	ocfs2_lock_res_init_common(osb, res, OCFS2_LOCK_TYPE_NFS_SYNC,
>  				   &ocfs2_nfs_sync_lops, osb);
> +	init_rwsem(&osb->nfs_sync_rwlock);
>  }

Can we leave this and introduce a new one to initialize both
osb_nfs_sync_lockres and nfs_sync_rwlock? Then we can let all
lockres initialization look the same.
Something like:
static void ocfs2_nfs_sync_lock_init(struct ocfs2_super *osb)
{
	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
	init_rwsem(&osb->nfs_sync_rwlock);
}

Thanks,
Joseph

>  
>  void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb)
> @@ -2855,6 +2857,11 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
>  	if (ocfs2_is_hard_readonly(osb))
>  		return -EROFS;
>  
> +	if (ex)
> +		down_write(&osb->nfs_sync_rwlock);
> +	else
> +		down_read(&osb->nfs_sync_rwlock);
> +
>  	if (ocfs2_mount_local(osb))
>  		return 0;
>  
> @@ -2873,6 +2880,10 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
>  	if (!ocfs2_mount_local(osb))
>  		ocfs2_cluster_unlock(osb, lockres,
>  				     ex ? LKM_EXMODE : LKM_PRMODE);
> +	if (ex)
> +		up_write(&osb->nfs_sync_rwlock);
> +	else
> +		up_read(&osb->nfs_sync_rwlock);
>  }
>  
>  int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
> @@ -3340,7 +3351,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>  local:
>  	ocfs2_super_lock_res_init(&osb->osb_super_lockres, osb);
>  	ocfs2_rename_lock_res_init(&osb->osb_rename_lockres, osb);
> -	ocfs2_nfs_sync_lock_res_init(&osb->osb_nfs_sync_lockres, osb);
> +	ocfs2_nfs_sync_lock_res_init(osb);
>  	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
>  
>  	osb->cconn = conn;
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index ee5d98516212..2dd71d626196 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -395,6 +395,7 @@ struct ocfs2_super
>  	struct ocfs2_lock_res osb_super_lockres;
>  	struct ocfs2_lock_res osb_rename_lockres;
>  	struct ocfs2_lock_res osb_nfs_sync_lockres;
> +	struct rw_semaphore nfs_sync_rwlock;
>  	struct ocfs2_lock_res osb_trim_fs_lockres;
>  	struct mutex obs_trim_fs_mutex;
>  	struct ocfs2_dlm_debug *osb_dlm_debug;
> 
