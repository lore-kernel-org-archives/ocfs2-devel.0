From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 26 Feb 2010 16:27:31 -0800
Subject: [Ocfs2-devel] [PATCH 10/11] ocfs2_dlmfs: Use the stackglue.
In-Reply-To: <1265794074-19539-11-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
	<1265794074-19539-11-git-send-email-joel.becker@oracle.com>
Message-ID: <4B8866F3.8090004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mfasheh@suse.com, linux-kernel@vger.kernel.org

Signed-off-by: Sunil Mushranr <sunil.mushran@oracle.com>


Joel Becker wrote:
> Rather than directly using o2dlm, dlmfs can now use the stackglue.  This
> allows it to use userspace cluster stacks and fs/dlm.  This commit
> forces o2cb for now.  A latter commit will bump the protocol version and
> allow non-o2cb stacks.
>
> This is one big sed, really.  LKM_xxMODE becomes DLM_LOCK_xx.  LKM_flag
> becomes DLM_LKF_flag.
>
> We also learn to check that the LVB is valid before reading it.  Any DLM
> can lose the contents of the LVB during a complicated recovery.  userdlm
> should be checking this.  Now it does.  dlmfs will return 0 from read(2)
> if the LVB was invalid.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/dlmfs/dlmfs.c   |   57 ++++------
>  fs/ocfs2/dlmfs/userdlm.c |  266 +++++++++++++++++++++++----------------------
>  fs/ocfs2/dlmfs/userdlm.h |   16 ++--
>  3 files changed, 166 insertions(+), 173 deletions(-)
>
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 13ac2bf..8697366 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -47,21 +47,13 @@
>  
>  #include <asm/uaccess.h>
>  
> -
> -#include "cluster/nodemanager.h"
> -#include "cluster/heartbeat.h"
> -#include "cluster/tcp.h"
> -
> -#include "dlm/dlmapi.h"
> -
> +#include "stackglue.h"
>  #include "userdlm.h"
> -
>  #include "dlmfsver.h"
>  
>  #define MLOG_MASK_PREFIX ML_DLMFS
>  #include "cluster/masklog.h"
>  
> -#include "ocfs2_lockingver.h"
>  
>  static const struct super_operations dlmfs_ops;
>  static const struct file_operations dlmfs_file_operations;
> @@ -72,15 +64,6 @@ static struct kmem_cache *dlmfs_inode_cache;
>  
>  struct workqueue_struct *user_dlm_worker;
>  
> -/*
> - * This is the userdlmfs locking protocol version.
> - *
> - * See fs/ocfs2/dlmglue.c for more details on locking versions.
> - */
> -static const struct dlm_protocol_version user_locking_protocol = {
> -	.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
> -	.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
> -};
>  
>  
>  /*
> @@ -259,7 +242,7 @@ static ssize_t dlmfs_file_read(struct file *filp,
>  			       loff_t *ppos)
>  {
>  	int bytes_left;
> -	ssize_t readlen;
> +	ssize_t readlen, got;
>  	char *lvb_buf;
>  	struct inode *inode = filp->f_path.dentry->d_inode;
>  
> @@ -285,9 +268,13 @@ static ssize_t dlmfs_file_read(struct file *filp,
>  	if (!lvb_buf)
>  		return -ENOMEM;
>  
> -	user_dlm_read_lvb(inode, lvb_buf, readlen);
> -	bytes_left = __copy_to_user(buf, lvb_buf, readlen);
> -	readlen -= bytes_left;
> +	got = user_dlm_read_lvb(inode, lvb_buf, readlen);
> +	if (got) {
> +		BUG_ON(got != readlen);
> +		bytes_left = __copy_to_user(buf, lvb_buf, readlen);
> +		readlen -= bytes_left;
> +	} else
> +		readlen = 0;
>  
>  	kfree(lvb_buf);
>  
> @@ -346,7 +333,7 @@ static void dlmfs_init_once(void *foo)
>  	struct dlmfs_inode_private *ip =
>  		(struct dlmfs_inode_private *) foo;
>  
> -	ip->ip_dlm = NULL;
> +	ip->ip_conn = NULL;
>  	ip->ip_parent = NULL;
>  
>  	inode_init_once(&ip->ip_vfs_inode);
> @@ -388,14 +375,14 @@ static void dlmfs_clear_inode(struct inode *inode)
>  		goto clear_fields;
>  	}
>  
> -	mlog(0, "we're a directory, ip->ip_dlm = 0x%p\n", ip->ip_dlm);
> +	mlog(0, "we're a directory, ip->ip_conn = 0x%p\n", ip->ip_conn);
>  	/* we must be a directory. If required, lets unregister the
>  	 * dlm context now. */
> -	if (ip->ip_dlm)
> -		user_dlm_unregister_context(ip->ip_dlm);
> +	if (ip->ip_conn)
> +		user_dlm_unregister(ip->ip_conn);
>  clear_fields:
>  	ip->ip_parent = NULL;
> -	ip->ip_dlm = NULL;
> +	ip->ip_conn = NULL;
>  }
>  
>  static struct backing_dev_info dlmfs_backing_dev_info = {
> @@ -445,7 +432,7 @@ static struct inode *dlmfs_get_inode(struct inode *parent,
>  	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>  
>  	ip = DLMFS_I(inode);
> -	ip->ip_dlm = DLMFS_I(parent)->ip_dlm;
> +	ip->ip_conn = DLMFS_I(parent)->ip_conn;
>  
>  	switch (mode & S_IFMT) {
>  	default:
> @@ -499,13 +486,12 @@ static int dlmfs_mkdir(struct inode * dir,
>  	struct inode *inode = NULL;
>  	struct qstr *domain = &dentry->d_name;
>  	struct dlmfs_inode_private *ip;
> -	struct dlm_ctxt *dlm;
> -	struct dlm_protocol_version proto = user_locking_protocol;
> +	struct ocfs2_cluster_connection *conn;
>  
>  	mlog(0, "mkdir %.*s\n", domain->len, domain->name);
>  
>  	/* verify that we have a proper domain */
> -	if (domain->len >= O2NM_MAX_NAME_LEN) {
> +	if (domain->len >= GROUP_NAME_MAX) {
>  		status = -EINVAL;
>  		mlog(ML_ERROR, "invalid domain name for directory.\n");
>  		goto bail;
> @@ -520,14 +506,14 @@ static int dlmfs_mkdir(struct inode * dir,
>  
>  	ip = DLMFS_I(inode);
>  
> -	dlm = user_dlm_register_context(domain, &proto);
> -	if (IS_ERR(dlm)) {
> -		status = PTR_ERR(dlm);
> +	conn = user_dlm_register(domain);
> +	if (IS_ERR(conn)) {
> +		status = PTR_ERR(conn);
>  		mlog(ML_ERROR, "Error %d could not register domain \"%.*s\"\n",
>  		     status, domain->len, domain->name);
>  		goto bail;
>  	}
> -	ip->ip_dlm = dlm;
> +	ip->ip_conn = conn;
>  
>  	inc_nlink(dir);
>  	d_instantiate(dentry, inode);
> @@ -696,6 +682,7 @@ static int __init init_dlmfs_fs(void)
>  	}
>  	cleanup_worker = 1;
>  
> +	user_dlm_set_locking_protocol();
>  	status = register_filesystem(&dlmfs_fs_type);
>  bail:
>  	if (status) {
> diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> index 6adae70..c1b6a56 100644
> --- a/fs/ocfs2/dlmfs/userdlm.c
> +++ b/fs/ocfs2/dlmfs/userdlm.c
> @@ -34,18 +34,19 @@
>  #include <linux/types.h>
>  #include <linux/crc32.h>
>  
> -
> -#include "cluster/nodemanager.h"
> -#include "cluster/heartbeat.h"
> -#include "cluster/tcp.h"
> -
> -#include "dlm/dlmapi.h"
> -
> +#include "ocfs2_lockingver.h"
> +#include "stackglue.h"
>  #include "userdlm.h"
>  
>  #define MLOG_MASK_PREFIX ML_DLMFS
>  #include "cluster/masklog.h"
>  
> +
> +static inline struct user_lock_res *user_lksb_to_lock_res(struct ocfs2_dlm_lksb *lksb)
> +{
> +	return container_of(lksb, struct user_lock_res, l_lksb);
> +}
> +
>  static inline int user_check_wait_flag(struct user_lock_res *lockres,
>  				       int flag)
>  {
> @@ -73,15 +74,15 @@ static inline void user_wait_on_blocked_lock(struct user_lock_res *lockres)
>  }
>  
>  /* I heart container_of... */
> -static inline struct dlm_ctxt *
> -dlm_ctxt_from_user_lockres(struct user_lock_res *lockres)
> +static inline struct ocfs2_cluster_connection *
> +cluster_connection_from_user_lockres(struct user_lock_res *lockres)
>  {
>  	struct dlmfs_inode_private *ip;
>  
>  	ip = container_of(lockres,
>  			  struct dlmfs_inode_private,
>  			  ip_lockres);
> -	return ip->ip_dlm;
> +	return ip->ip_conn;
>  }
>  
>  static struct inode *
> @@ -103,9 +104,9 @@ static inline void user_recover_from_dlm_error(struct user_lock_res *lockres)
>  }
>  
>  #define user_log_dlm_error(_func, _stat, _lockres) do {			\
> -	mlog(ML_ERROR, "Dlm error \"%s\" while calling %s on "		\
> -		"resource %.*s: %s\n", dlm_errname(_stat), _func,	\
> -		_lockres->l_namelen, _lockres->l_name, dlm_errmsg(_stat)); \
> +	mlog(ML_ERROR, "Dlm error %d while calling %s on "		\
> +		"resource %.*s\n", _stat, _func,			\
> +		_lockres->l_namelen, _lockres->l_name); 		\
>  } while (0)
>  
>  /* WARNING: This function lives in a world where the only three lock
> @@ -113,34 +114,34 @@ static inline void user_recover_from_dlm_error(struct user_lock_res *lockres)
>   * lock types are added. */
>  static inline int user_highest_compat_lock_level(int level)
>  {
> -	int new_level = LKM_EXMODE;
> +	int new_level = DLM_LOCK_EX;
>  
> -	if (level == LKM_EXMODE)
> -		new_level = LKM_NLMODE;
> -	else if (level == LKM_PRMODE)
> -		new_level = LKM_PRMODE;
> +	if (level == DLM_LOCK_EX)
> +		new_level = DLM_LOCK_NL;
> +	else if (level == DLM_LOCK_PR)
> +		new_level = DLM_LOCK_PR;
>  	return new_level;
>  }
>  
> -static void user_ast(void *opaque)
> +static void user_ast(struct ocfs2_dlm_lksb *lksb)
>  {
> -	struct user_lock_res *lockres = opaque;
> -	struct dlm_lockstatus *lksb;
> +	struct user_lock_res *lockres = user_lksb_to_lock_res(lksb);
> +	int status;
>  
>  	mlog(0, "AST fired for lockres %.*s\n", lockres->l_namelen,
>  	     lockres->l_name);
>  
>  	spin_lock(&lockres->l_lock);
>  
> -	lksb = &(lockres->l_lksb);
> -	if (lksb->status != DLM_NORMAL) {
> +	status = ocfs2_dlm_lock_status(&lockres->l_lksb);
> +	if (status) {
>  		mlog(ML_ERROR, "lksb status value of %u on lockres %.*s\n",
> -		     lksb->status, lockres->l_namelen, lockres->l_name);
> +		     status, lockres->l_namelen, lockres->l_name);
>  		spin_unlock(&lockres->l_lock);
>  		return;
>  	}
>  
> -	mlog_bug_on_msg(lockres->l_requested == LKM_IVMODE,
> +	mlog_bug_on_msg(lockres->l_requested == DLM_LOCK_IV,
>  			"Lockres %.*s, requested ivmode. flags 0x%x\n",
>  			lockres->l_namelen, lockres->l_name, lockres->l_flags);
>  
> @@ -148,13 +149,13 @@ static void user_ast(void *opaque)
>  	if (lockres->l_requested < lockres->l_level) {
>  		if (lockres->l_requested <=
>  		    user_highest_compat_lock_level(lockres->l_blocking)) {
> -			lockres->l_blocking = LKM_NLMODE;
> +			lockres->l_blocking = DLM_LOCK_NL;
>  			lockres->l_flags &= ~USER_LOCK_BLOCKED;
>  		}
>  	}
>  
>  	lockres->l_level = lockres->l_requested;
> -	lockres->l_requested = LKM_IVMODE;
> +	lockres->l_requested = DLM_LOCK_IV;
>  	lockres->l_flags |= USER_LOCK_ATTACHED;
>  	lockres->l_flags &= ~USER_LOCK_BUSY;
>  
> @@ -193,11 +194,11 @@ static void __user_dlm_cond_queue_lockres(struct user_lock_res *lockres)
>  		return;
>  
>  	switch (lockres->l_blocking) {
> -	case LKM_EXMODE:
> +	case DLM_LOCK_EX:
>  		if (!lockres->l_ex_holders && !lockres->l_ro_holders)
>  			queue = 1;
>  		break;
> -	case LKM_PRMODE:
> +	case DLM_LOCK_PR:
>  		if (!lockres->l_ex_holders)
>  			queue = 1;
>  		break;
> @@ -209,9 +210,9 @@ static void __user_dlm_cond_queue_lockres(struct user_lock_res *lockres)
>  		__user_dlm_queue_lockres(lockres);
>  }
>  
> -static void user_bast(void *opaque, int level)
> +static void user_bast(struct ocfs2_dlm_lksb *lksb, int level)
>  {
> -	struct user_lock_res *lockres = opaque;
> +	struct user_lock_res *lockres = user_lksb_to_lock_res(lksb);
>  
>  	mlog(0, "Blocking AST fired for lockres %.*s. Blocking level %d\n",
>  	     lockres->l_namelen, lockres->l_name, level);
> @@ -227,15 +228,15 @@ static void user_bast(void *opaque, int level)
>  	wake_up(&lockres->l_event);
>  }
>  
> -static void user_unlock_ast(void *opaque, enum dlm_status status)
> +static void user_unlock_ast(struct ocfs2_dlm_lksb *lksb, int status)
>  {
> -	struct user_lock_res *lockres = opaque;
> +	struct user_lock_res *lockres = user_lksb_to_lock_res(lksb);
>  
>  	mlog(0, "UNLOCK AST called on lock %.*s\n", lockres->l_namelen,
>  	     lockres->l_name);
>  
> -	if (status != DLM_NORMAL && status != DLM_CANCELGRANT)
> -		mlog(ML_ERROR, "Dlm returns status %d\n", status);
> +	if (status)
> +		mlog(ML_ERROR, "dlm returns status %d\n", status);
>  
>  	spin_lock(&lockres->l_lock);
>  	/* The teardown flag gets set early during the unlock process,
> @@ -243,7 +244,7 @@ static void user_unlock_ast(void *opaque, enum dlm_status status)
>  	 * for a concurrent cancel. */
>  	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN
>  	    && !(lockres->l_flags & USER_LOCK_IN_CANCEL)) {
> -		lockres->l_level = LKM_IVMODE;
> +		lockres->l_level = DLM_LOCK_IV;
>  	} else if (status == DLM_CANCELGRANT) {
>  		/* We tried to cancel a convert request, but it was
>  		 * already granted. Don't clear the busy flag - the
> @@ -254,7 +255,7 @@ static void user_unlock_ast(void *opaque, enum dlm_status status)
>  	} else {
>  		BUG_ON(!(lockres->l_flags & USER_LOCK_IN_CANCEL));
>  		/* Cancel succeeded, we want to re-queue */
> -		lockres->l_requested = LKM_IVMODE; /* cancel an
> +		lockres->l_requested = DLM_LOCK_IV; /* cancel an
>  						    * upconvert
>  						    * request. */
>  		lockres->l_flags &= ~USER_LOCK_IN_CANCEL;
> @@ -271,6 +272,21 @@ out_noclear:
>  	wake_up(&lockres->l_event);
>  }
>  
> +/*
> + * This is the userdlmfs locking protocol version.
> + *
> + * See fs/ocfs2/dlmglue.c for more details on locking versions.
> + */
> +static struct ocfs2_locking_protocol user_dlm_lproto = {
> +	.lp_max_version = {
> +		.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
> +		.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
> +	},
> +	.lp_lock_ast		= user_ast,
> +	.lp_blocking_ast	= user_bast,
> +	.lp_unlock_ast		= user_unlock_ast,
> +};
> +
>  static inline void user_dlm_drop_inode_ref(struct user_lock_res *lockres)
>  {
>  	struct inode *inode;
> @@ -283,7 +299,8 @@ static void user_dlm_unblock_lock(struct work_struct *work)
>  	int new_level, status;
>  	struct user_lock_res *lockres =
>  		container_of(work, struct user_lock_res, l_work);
> -	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
> +	struct ocfs2_cluster_connection *conn =
> +		cluster_connection_from_user_lockres(lockres);
>  
>  	mlog(0, "processing lockres %.*s\n", lockres->l_namelen,
>  	     lockres->l_name);
> @@ -322,20 +339,17 @@ static void user_dlm_unblock_lock(struct work_struct *work)
>  		lockres->l_flags |= USER_LOCK_IN_CANCEL;
>  		spin_unlock(&lockres->l_lock);
>  
> -		status = dlmunlock(dlm,
> -				   &lockres->l_lksb,
> -				   LKM_CANCEL,
> -				   user_unlock_ast,
> -				   lockres);
> -		if (status != DLM_NORMAL)
> -			user_log_dlm_error("dlmunlock", status, lockres);
> +		status = ocfs2_dlm_unlock(conn, &lockres->l_lksb,
> +					  DLM_LKF_CANCEL);
> +		if (status)
> +			user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
>  		goto drop_ref;
>  	}
>  
>  	/* If there are still incompat holders, we can exit safely
>  	 * without worrying about re-queueing this lock as that will
>  	 * happen on the last call to user_cluster_unlock. */
> -	if ((lockres->l_blocking == LKM_EXMODE)
> +	if ((lockres->l_blocking == DLM_LOCK_EX)
>  	    && (lockres->l_ex_holders || lockres->l_ro_holders)) {
>  		spin_unlock(&lockres->l_lock);
>  		mlog(0, "can't downconvert for ex: ro = %u, ex = %u\n",
> @@ -343,7 +357,7 @@ static void user_dlm_unblock_lock(struct work_struct *work)
>  		goto drop_ref;
>  	}
>  
> -	if ((lockres->l_blocking == LKM_PRMODE)
> +	if ((lockres->l_blocking == DLM_LOCK_PR)
>  	    && lockres->l_ex_holders) {
>  		spin_unlock(&lockres->l_lock);
>  		mlog(0, "can't downconvert for pr: ex = %u\n",
> @@ -360,17 +374,12 @@ static void user_dlm_unblock_lock(struct work_struct *work)
>  	spin_unlock(&lockres->l_lock);
>  
>  	/* need lock downconvert request now... */
> -	status = dlmlock(dlm,
> -			 new_level,
> -			 &lockres->l_lksb,
> -			 LKM_CONVERT|LKM_VALBLK,
> -			 lockres->l_name,
> -			 lockres->l_namelen,
> -			 user_ast,
> -			 lockres,
> -			 user_bast);
> -	if (status != DLM_NORMAL) {
> -		user_log_dlm_error("dlmlock", status, lockres);
> +	status = ocfs2_dlm_lock(conn, new_level, &lockres->l_lksb,
> +				DLM_LKF_CONVERT|DLM_LKF_VALBLK,
> +				lockres->l_name,
> +				lockres->l_namelen);
> +	if (status) {
> +		user_log_dlm_error("ocfs2_dlm_lock", status, lockres);
>  		user_recover_from_dlm_error(lockres);
>  	}
>  
> @@ -382,10 +391,10 @@ static inline void user_dlm_inc_holders(struct user_lock_res *lockres,
>  					int level)
>  {
>  	switch(level) {
> -	case LKM_EXMODE:
> +	case DLM_LOCK_EX:
>  		lockres->l_ex_holders++;
>  		break;
> -	case LKM_PRMODE:
> +	case DLM_LOCK_PR:
>  		lockres->l_ro_holders++;
>  		break;
>  	default:
> @@ -410,10 +419,11 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
>  			  int lkm_flags)
>  {
>  	int status, local_flags;
> -	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
> +	struct ocfs2_cluster_connection *conn =
> +		cluster_connection_from_user_lockres(lockres);
>  
> -	if (level != LKM_EXMODE &&
> -	    level != LKM_PRMODE) {
> +	if (level != DLM_LOCK_EX &&
> +	    level != DLM_LOCK_PR) {
>  		mlog(ML_ERROR, "lockres %.*s: invalid request!\n",
>  		     lockres->l_namelen, lockres->l_name);
>  		status = -EINVAL;
> @@ -422,7 +432,7 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
>  
>  	mlog(0, "lockres %.*s: asking for %s lock, passed flags = 0x%x\n",
>  	     lockres->l_namelen, lockres->l_name,
> -	     (level == LKM_EXMODE) ? "LKM_EXMODE" : "LKM_PRMODE",
> +	     (level == DLM_LOCK_EX) ? "DLM_LOCK_EX" : "DLM_LOCK_PR",
>  	     lkm_flags);
>  
>  again:
> @@ -457,35 +467,26 @@ again:
>  	}
>  
>  	if (level > lockres->l_level) {
> -		local_flags = lkm_flags | LKM_VALBLK;
> -		if (lockres->l_level != LKM_IVMODE)
> -			local_flags |= LKM_CONVERT;
> +		local_flags = lkm_flags | DLM_LKF_VALBLK;
> +		if (lockres->l_level != DLM_LOCK_IV)
> +			local_flags |= DLM_LKF_CONVERT;
>  
>  		lockres->l_requested = level;
>  		lockres->l_flags |= USER_LOCK_BUSY;
>  		spin_unlock(&lockres->l_lock);
>  
> -		BUG_ON(level == LKM_IVMODE);
> -		BUG_ON(level == LKM_NLMODE);
> +		BUG_ON(level == DLM_LOCK_IV);
> +		BUG_ON(level == DLM_LOCK_NL);
>  
>  		/* call dlm_lock to upgrade lock now */
> -		status = dlmlock(dlm,
> -				 level,
> -				 &lockres->l_lksb,
> -				 local_flags,
> -				 lockres->l_name,
> -				 lockres->l_namelen,
> -				 user_ast,
> -				 lockres,
> -				 user_bast);
> -		if (status != DLM_NORMAL) {
> -			if ((lkm_flags & LKM_NOQUEUE) &&
> -			    (status == DLM_NOTQUEUED))
> -				status = -EAGAIN;
> -			else {
> -				user_log_dlm_error("dlmlock", status, lockres);
> -				status = -EINVAL;
> -			}
> +		status = ocfs2_dlm_lock(conn, level, &lockres->l_lksb,
> +					local_flags, lockres->l_name,
> +					lockres->l_namelen);
> +		if (status) {
> +			if ((lkm_flags & DLM_LKF_NOQUEUE) &&
> +			    (status != -EAGAIN))
> +				user_log_dlm_error("ocfs2_dlm_lock",
> +						   status, lockres);
>  			user_recover_from_dlm_error(lockres);
>  			goto bail;
>  		}
> @@ -506,11 +507,11 @@ static inline void user_dlm_dec_holders(struct user_lock_res *lockres,
>  					int level)
>  {
>  	switch(level) {
> -	case LKM_EXMODE:
> +	case DLM_LOCK_EX:
>  		BUG_ON(!lockres->l_ex_holders);
>  		lockres->l_ex_holders--;
>  		break;
> -	case LKM_PRMODE:
> +	case DLM_LOCK_PR:
>  		BUG_ON(!lockres->l_ro_holders);
>  		lockres->l_ro_holders--;
>  		break;
> @@ -522,8 +523,8 @@ static inline void user_dlm_dec_holders(struct user_lock_res *lockres,
>  void user_dlm_cluster_unlock(struct user_lock_res *lockres,
>  			     int level)
>  {
> -	if (level != LKM_EXMODE &&
> -	    level != LKM_PRMODE) {
> +	if (level != DLM_LOCK_EX &&
> +	    level != DLM_LOCK_PR) {
>  		mlog(ML_ERROR, "lockres %.*s: invalid request!\n",
>  		     lockres->l_namelen, lockres->l_name);
>  		return;
> @@ -540,33 +541,40 @@ void user_dlm_write_lvb(struct inode *inode,
>  			unsigned int len)
>  {
>  	struct user_lock_res *lockres = &DLMFS_I(inode)->ip_lockres;
> -	char *lvb = lockres->l_lksb.lvb;
> +	char *lvb;
>  
>  	BUG_ON(len > DLM_LVB_LEN);
>  
>  	spin_lock(&lockres->l_lock);
>  
> -	BUG_ON(lockres->l_level < LKM_EXMODE);
> +	BUG_ON(lockres->l_level < DLM_LOCK_EX);
> +	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
>  	memcpy(lvb, val, len);
>  
>  	spin_unlock(&lockres->l_lock);
>  }
>  
> -void user_dlm_read_lvb(struct inode *inode,
> -		       char *val,
> -		       unsigned int len)
> +ssize_t user_dlm_read_lvb(struct inode *inode,
> +			  char *val,
> +			  unsigned int len)
>  {
>  	struct user_lock_res *lockres = &DLMFS_I(inode)->ip_lockres;
> -	char *lvb = lockres->l_lksb.lvb;
> +	char *lvb;
> +	ssize_t ret = len;
>  
>  	BUG_ON(len > DLM_LVB_LEN);
>  
>  	spin_lock(&lockres->l_lock);
>  
> -	BUG_ON(lockres->l_level < LKM_PRMODE);
> -	memcpy(val, lvb, len);
> +	BUG_ON(lockres->l_level < DLM_LOCK_PR);
> +	if (ocfs2_dlm_lvb_valid(&lockres->l_lksb)) {
> +		lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
> +		memcpy(val, lvb, len);
> +	} else
> +		ret = 0;
>  
>  	spin_unlock(&lockres->l_lock);
> +	return ret;
>  }
>  
>  void user_dlm_lock_res_init(struct user_lock_res *lockres,
> @@ -576,9 +584,9 @@ void user_dlm_lock_res_init(struct user_lock_res *lockres,
>  
>  	spin_lock_init(&lockres->l_lock);
>  	init_waitqueue_head(&lockres->l_event);
> -	lockres->l_level = LKM_IVMODE;
> -	lockres->l_requested = LKM_IVMODE;
> -	lockres->l_blocking = LKM_IVMODE;
> +	lockres->l_level = DLM_LOCK_IV;
> +	lockres->l_requested = DLM_LOCK_IV;
> +	lockres->l_blocking = DLM_LOCK_IV;
>  
>  	/* should have been checked before getting here. */
>  	BUG_ON(dentry->d_name.len >= USER_DLM_LOCK_ID_MAX_LEN);
> @@ -592,7 +600,8 @@ void user_dlm_lock_res_init(struct user_lock_res *lockres,
>  int user_dlm_destroy_lock(struct user_lock_res *lockres)
>  {
>  	int status = -EBUSY;
> -	struct dlm_ctxt *dlm = dlm_ctxt_from_user_lockres(lockres);
> +	struct ocfs2_cluster_connection *conn =
> +		cluster_connection_from_user_lockres(lockres);
>  
>  	mlog(0, "asked to destroy %.*s\n", lockres->l_namelen, lockres->l_name);
>  
> @@ -627,14 +636,9 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
>  	lockres->l_flags |= USER_LOCK_BUSY;
>  	spin_unlock(&lockres->l_lock);
>  
> -	status = dlmunlock(dlm,
> -			   &lockres->l_lksb,
> -			   LKM_VALBLK,
> -			   user_unlock_ast,
> -			   lockres);
> -	if (status != DLM_NORMAL) {
> -		user_log_dlm_error("dlmunlock", status, lockres);
> -		status = -EINVAL;
> +	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
> +	if (status) {
> +		user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
>  		goto bail;
>  	}
>  
> @@ -645,32 +649,34 @@ bail:
>  	return status;
>  }
>  
> -struct dlm_ctxt *user_dlm_register_context(struct qstr *name,
> -					   struct dlm_protocol_version *proto)
> +static void user_dlm_recovery_handler_noop(int node_num,
> +					   void *recovery_data)
>  {
> -	struct dlm_ctxt *dlm;
> -	u32 dlm_key;
> -	char *domain;
> -
> -	domain = kmalloc(name->len + 1, GFP_NOFS);
> -	if (!domain) {
> -		mlog_errno(-ENOMEM);
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	/* We ignore recovery events */
> +	return;
> +}
>  
> -	dlm_key = crc32_le(0, name->name, name->len);
> +void user_dlm_set_locking_protocol(void)
> +{
> +	ocfs2_stack_glue_set_max_proto_version(&user_dlm_lproto.lp_max_version);
> +}
>  
> -	snprintf(domain, name->len + 1, "%.*s", name->len, name->name);
> +struct ocfs2_cluster_connection *user_dlm_register(struct qstr *name)
> +{
> +	int rc;
> +	struct ocfs2_cluster_connection *conn;
>  
> -	dlm = dlm_register_domain(domain, dlm_key, proto);
> -	if (IS_ERR(dlm))
> -		mlog_errno(PTR_ERR(dlm));
> +	rc = ocfs2_cluster_connect("o2cb", name->name, name->len,
> +				   &user_dlm_lproto,
> +				   user_dlm_recovery_handler_noop,
> +				   NULL, &conn);
> +	if (rc)
> +		mlog_errno(rc);
>  
> -	kfree(domain);
> -	return dlm;
> +	return rc ? ERR_PTR(rc) : conn;
>  }
>  
> -void user_dlm_unregister_context(struct dlm_ctxt *dlm)
> +void user_dlm_unregister(struct ocfs2_cluster_connection *conn)
>  {
> -	dlm_unregister_domain(dlm);
> +	ocfs2_cluster_disconnect(conn, 0);
>  }
> diff --git a/fs/ocfs2/dlmfs/userdlm.h b/fs/ocfs2/dlmfs/userdlm.h
> index 0c3cc03..3b42d79 100644
> --- a/fs/ocfs2/dlmfs/userdlm.h
> +++ b/fs/ocfs2/dlmfs/userdlm.h
> @@ -57,7 +57,7 @@ struct user_lock_res {
>  	int                      l_level;
>  	unsigned int             l_ro_holders;
>  	unsigned int             l_ex_holders;
> -	struct dlm_lockstatus    l_lksb;
> +	struct ocfs2_dlm_lksb    l_lksb;
>  
>  	int                      l_requested;
>  	int                      l_blocking;
> @@ -80,15 +80,15 @@ void user_dlm_cluster_unlock(struct user_lock_res *lockres,
>  void user_dlm_write_lvb(struct inode *inode,
>  			const char *val,
>  			unsigned int len);
> -void user_dlm_read_lvb(struct inode *inode,
> -		       char *val,
> -		       unsigned int len);
> -struct dlm_ctxt *user_dlm_register_context(struct qstr *name,
> -					   struct dlm_protocol_version *proto);
> -void user_dlm_unregister_context(struct dlm_ctxt *dlm);
> +ssize_t user_dlm_read_lvb(struct inode *inode,
> +			  char *val,
> +			  unsigned int len);
> +struct ocfs2_cluster_connection *user_dlm_register(struct qstr *name);
> +void user_dlm_unregister(struct ocfs2_cluster_connection *conn);
> +void user_dlm_set_locking_protocol(void);
>  
>  struct dlmfs_inode_private {
> -	struct dlm_ctxt             *ip_dlm;
> +	struct ocfs2_cluster_connection	*ip_conn;
>  
>  	struct user_lock_res ip_lockres; /* unused for directories. */
>  	struct inode         *ip_parent;
>   
