From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 26 Feb 2010 16:09:33 -0800
Subject: [Ocfs2-devel] [PATCH 08/11] ocfs2: Pass the locking protocol
 into ocfs2_cluster_connect().
In-Reply-To: <1265794074-19539-9-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
	<1265794074-19539-9-git-send-email-joel.becker@oracle.com>
Message-ID: <4B8862BD.4050608@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mfasheh@suse.com, linux-kernel@vger.kernel.org

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Joel Becker wrote:
> Inside the stackglue, the locking protocol structure is hanging off of
> the ocfs2_cluster_connection.  This takes it one further; the locking
> protocol is passed into ocfs2_cluster_connect().  Now different cluster
> connections can have different locking protocols with distinct asts.
> Note that all locking protocols have to keep their maximum protocol
> version in lock-step.
>
> With the protocol structure set in ocfs2_cluster_connect(), there is no
> need for the stackglue to have a static pointer to a specific protocol
> structure.  We can change initialization to only pass in the maximum
> protocol version.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c   |  168 +++++++++++++++++++++++++-------------------------
>  fs/ocfs2/stackglue.c |   43 ++++++++-----
>  fs/ocfs2/stackglue.h |    3 +-
>  3 files changed, 110 insertions(+), 104 deletions(-)
>
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 4cb3ac2..dde55c4 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1036,7 +1036,6 @@ static unsigned int lockres_set_pending(struct ocfs2_lock_res *lockres)
>  	return lockres->l_pending_gen;
>  }
>  
> -
>  static void ocfs2_blocking_ast(struct ocfs2_dlm_lksb *lksb, int level)
>  {
>  	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
> @@ -1130,6 +1129,88 @@ out:
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  }
>  
> +static void ocfs2_unlock_ast(struct ocfs2_dlm_lksb *lksb, int error)
> +{
> +	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
> +	unsigned long flags;
> +
> +	mlog_entry_void();
> +
> +	mlog(0, "UNLOCK AST called on lock %s, action = %d\n", lockres->l_name,
> +	     lockres->l_unlock_action);
> +
> +	spin_lock_irqsave(&lockres->l_lock, flags);
> +	if (error) {
> +		mlog(ML_ERROR, "Dlm passes error %d for lock %s, "
> +		     "unlock_action %d\n", error, lockres->l_name,
> +		     lockres->l_unlock_action);
> +		spin_unlock_irqrestore(&lockres->l_lock, flags);
> +		mlog_exit_void();
> +		return;
> +	}
> +
> +	switch(lockres->l_unlock_action) {
> +	case OCFS2_UNLOCK_CANCEL_CONVERT:
> +		mlog(0, "Cancel convert success for %s\n", lockres->l_name);
> +		lockres->l_action = OCFS2_AST_INVALID;
> +		/* Downconvert thread may have requeued this lock, we
> +		 * need to wake it. */
> +		if (lockres->l_flags & OCFS2_LOCK_BLOCKED)
> +			ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));
> +		break;
> +	case OCFS2_UNLOCK_DROP_LOCK:
> +		lockres->l_level = DLM_LOCK_IV;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
> +	lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
> +	wake_up(&lockres->l_event);
> +	spin_unlock_irqrestore(&lockres->l_lock, flags);
> +
> +	mlog_exit_void();
> +}
> +
> +/*
> + * This is the filesystem locking protocol.  It provides the lock handling
> + * hooks for the underlying DLM.  It has a maximum version number.
> + * The version number allows interoperability with systems running at
> + * the same major number and an equal or smaller minor number.
> + *
> + * Whenever the filesystem does new things with locks (adds or removes a
> + * lock, orders them differently, does different things underneath a lock),
> + * the version must be changed.  The protocol is negotiated when joining
> + * the dlm domain.  A node may join the domain if its major version is
> + * identical to all other nodes and its minor version is greater than
> + * or equal to all other nodes.  When its minor version is greater than
> + * the other nodes, it will run at the minor version specified by the
> + * other nodes.
> + *
> + * If a locking change is made that will not be compatible with older
> + * versions, the major number must be increased and the minor version set
> + * to zero.  If a change merely adds a behavior that can be disabled when
> + * speaking to older versions, the minor version must be increased.  If a
> + * change adds a fully backwards compatible change (eg, LVB changes that
> + * are just ignored by older versions), the version does not need to be
> + * updated.
> + */
> +static struct ocfs2_locking_protocol lproto = {
> +	.lp_max_version = {
> +		.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
> +		.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
> +	},
> +	.lp_lock_ast		= ocfs2_locking_ast,
> +	.lp_blocking_ast	= ocfs2_blocking_ast,
> +	.lp_unlock_ast		= ocfs2_unlock_ast,
> +};
> +
> +void ocfs2_set_locking_protocol(void)
> +{
> +	ocfs2_stack_glue_set_max_proto_version(&lproto.lp_max_version);
> +}
> +
>  static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
>  						int convert)
>  {
> @@ -2959,7 +3040,7 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
>  	status = ocfs2_cluster_connect(osb->osb_cluster_stack,
>  				       osb->uuid_str,
>  				       strlen(osb->uuid_str),
> -				       ocfs2_do_node_down, osb,
> +				       &lproto, ocfs2_do_node_down, osb,
>  				       &conn);
>  	if (status) {
>  		mlog_errno(status);
> @@ -3026,50 +3107,6 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
>  	mlog_exit_void();
>  }
>  
> -static void ocfs2_unlock_ast(struct ocfs2_dlm_lksb *lksb, int error)
> -{
> -	struct ocfs2_lock_res *lockres = ocfs2_lksb_to_lock_res(lksb);
> -	unsigned long flags;
> -
> -	mlog_entry_void();
> -
> -	mlog(0, "UNLOCK AST called on lock %s, action = %d\n", lockres->l_name,
> -	     lockres->l_unlock_action);
> -
> -	spin_lock_irqsave(&lockres->l_lock, flags);
> -	if (error) {
> -		mlog(ML_ERROR, "Dlm passes error %d for lock %s, "
> -		     "unlock_action %d\n", error, lockres->l_name,
> -		     lockres->l_unlock_action);
> -		spin_unlock_irqrestore(&lockres->l_lock, flags);
> -		mlog_exit_void();
> -		return;
> -	}
> -
> -	switch(lockres->l_unlock_action) {
> -	case OCFS2_UNLOCK_CANCEL_CONVERT:
> -		mlog(0, "Cancel convert success for %s\n", lockres->l_name);
> -		lockres->l_action = OCFS2_AST_INVALID;
> -		/* Downconvert thread may have requeued this lock, we
> -		 * need to wake it. */
> -		if (lockres->l_flags & OCFS2_LOCK_BLOCKED)
> -			ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));
> -		break;
> -	case OCFS2_UNLOCK_DROP_LOCK:
> -		lockres->l_level = DLM_LOCK_IV;
> -		break;
> -	default:
> -		BUG();
> -	}
> -
> -	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
> -	lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
> -	wake_up(&lockres->l_event);
> -	spin_unlock_irqrestore(&lockres->l_lock, flags);
> -
> -	mlog_exit_void();
> -}
> -
>  static int ocfs2_drop_lock(struct ocfs2_super *osb,
>  			   struct ocfs2_lock_res *lockres)
>  {
> @@ -3843,45 +3880,6 @@ void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex)
>  		ocfs2_cluster_unlock(osb, lockres, level);
>  }
>  
> -/*
> - * This is the filesystem locking protocol.  It provides the lock handling
> - * hooks for the underlying DLM.  It has a maximum version number.
> - * The version number allows interoperability with systems running at
> - * the same major number and an equal or smaller minor number.
> - *
> - * Whenever the filesystem does new things with locks (adds or removes a
> - * lock, orders them differently, does different things underneath a lock),
> - * the version must be changed.  The protocol is negotiated when joining
> - * the dlm domain.  A node may join the domain if its major version is
> - * identical to all other nodes and its minor version is greater than
> - * or equal to all other nodes.  When its minor version is greater than
> - * the other nodes, it will run at the minor version specified by the
> - * other nodes.
> - *
> - * If a locking change is made that will not be compatible with older
> - * versions, the major number must be increased and the minor version set
> - * to zero.  If a change merely adds a behavior that can be disabled when
> - * speaking to older versions, the minor version must be increased.  If a
> - * change adds a fully backwards compatible change (eg, LVB changes that
> - * are just ignored by older versions), the version does not need to be
> - * updated.
> - */
> -static struct ocfs2_locking_protocol lproto = {
> -	.lp_max_version = {
> -		.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
> -		.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
> -	},
> -	.lp_lock_ast		= ocfs2_locking_ast,
> -	.lp_blocking_ast	= ocfs2_blocking_ast,
> -	.lp_unlock_ast		= ocfs2_unlock_ast,
> -};
> -
> -void ocfs2_set_locking_protocol(void)
> -{
> -	ocfs2_stack_glue_set_locking_protocol(&lproto);
> -}
> -
> -
>  static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
>  				       struct ocfs2_lock_res *lockres)
>  {
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index fc184c7..31db2e8 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -36,7 +36,7 @@
>  #define OCFS2_STACK_PLUGIN_USER		"user"
>  #define OCFS2_MAX_HB_CTL_PATH		256
>  
> -static struct ocfs2_locking_protocol *lproto;
> +static struct ocfs2_protocol_version locking_max_version;
>  static DEFINE_SPINLOCK(ocfs2_stack_lock);
>  static LIST_HEAD(ocfs2_stack_list);
>  static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
> @@ -176,7 +176,7 @@ int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin)
>  	spin_lock(&ocfs2_stack_lock);
>  	if (!ocfs2_stack_lookup(plugin->sp_name)) {
>  		plugin->sp_count = 0;
> -		plugin->sp_max_proto = lproto->lp_max_version;
> +		plugin->sp_max_proto = locking_max_version;
>  		list_add(&plugin->sp_list, &ocfs2_stack_list);
>  		printk(KERN_INFO "ocfs2: Registered cluster interface %s\n",
>  		       plugin->sp_name);
> @@ -213,23 +213,23 @@ void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin)
>  }
>  EXPORT_SYMBOL_GPL(ocfs2_stack_glue_unregister);
>  
> -void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto)
> +void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_proto)
>  {
>  	struct ocfs2_stack_plugin *p;
>  
> -	BUG_ON(proto == NULL);
> -
>  	spin_lock(&ocfs2_stack_lock);
> -	BUG_ON(active_stack != NULL);
> +	if (memcmp(max_proto, &locking_max_version,
> +		   sizeof(struct ocfs2_protocol_version))) {
> +		BUG_ON(locking_max_version.pv_major != 0);
>  
> -	lproto = proto;
> -	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
> -		p->sp_max_proto = lproto->lp_max_version;
> +		locking_max_version = *max_proto;
> +		list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
> +			p->sp_max_proto = locking_max_version;
> +		}
>  	}
> -
>  	spin_unlock(&ocfs2_stack_lock);
>  }
> -EXPORT_SYMBOL_GPL(ocfs2_stack_glue_set_locking_protocol);
> +EXPORT_SYMBOL_GPL(ocfs2_stack_glue_set_max_proto_version);
>  
>  
>  /*
> @@ -245,8 +245,6 @@ int ocfs2_dlm_lock(struct ocfs2_cluster_connection *conn,
>  		   void *name,
>  		   unsigned int namelen)
>  {
> -	BUG_ON(lproto == NULL);
> -
>  	if (!lksb->lksb_conn)
>  		lksb->lksb_conn = conn;
>  	else
> @@ -260,7 +258,6 @@ int ocfs2_dlm_unlock(struct ocfs2_cluster_connection *conn,
>  		     struct ocfs2_dlm_lksb *lksb,
>  		     u32 flags)
>  {
> -	BUG_ON(lproto == NULL);
>  	BUG_ON(lksb->lksb_conn == NULL);
>  
>  	return active_stack->sp_ops->dlm_unlock(conn, lksb, flags);
> @@ -314,6 +311,7 @@ EXPORT_SYMBOL_GPL(ocfs2_plock);
>  int ocfs2_cluster_connect(const char *stack_name,
>  			  const char *group,
>  			  int grouplen,
> +			  struct ocfs2_locking_protocol *lproto,
>  			  void (*recovery_handler)(int node_num,
>  						   void *recovery_data),
>  			  void *recovery_data,
> @@ -331,6 +329,12 @@ int ocfs2_cluster_connect(const char *stack_name,
>  		goto out;
>  	}
>  
> +	if (memcmp(&lproto->lp_max_version, &locking_max_version,
> +		   sizeof(struct ocfs2_protocol_version))) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
>  	new_conn = kzalloc(sizeof(struct ocfs2_cluster_connection),
>  			   GFP_KERNEL);
>  	if (!new_conn) {
> @@ -456,10 +460,10 @@ static ssize_t ocfs2_max_locking_protocol_show(struct kobject *kobj,
>  	ssize_t ret = 0;
>  
>  	spin_lock(&ocfs2_stack_lock);
> -	if (lproto)
> +	if (locking_max_version.pv_major)
>  		ret = snprintf(buf, PAGE_SIZE, "%u.%u\n",
> -			       lproto->lp_max_version.pv_major,
> -			       lproto->lp_max_version.pv_minor);
> +			       locking_max_version.pv_major,
> +			       locking_max_version.pv_minor);
>  	spin_unlock(&ocfs2_stack_lock);
>  
>  	return ret;
> @@ -688,7 +692,10 @@ static int __init ocfs2_stack_glue_init(void)
>  
>  static void __exit ocfs2_stack_glue_exit(void)
>  {
> -	lproto = NULL;
> +	memset(&locking_max_version, 0,
> +	       sizeof(struct ocfs2_protocol_version));
> +	locking_max_version.pv_major = 0;
> +	locking_max_version.pv_minor = 0;
>  	ocfs2_sysfs_exit();
>  	if (ocfs2_table_header)
>  		unregister_sysctl_table(ocfs2_table_header);
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index 77a7a9a..b1981ba 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -241,6 +241,7 @@ struct ocfs2_stack_plugin {
>  int ocfs2_cluster_connect(const char *stack_name,
>  			  const char *group,
>  			  int grouplen,
> +			  struct ocfs2_locking_protocol *lproto,
>  			  void (*recovery_handler)(int node_num,
>  						   void *recovery_data),
>  			  void *recovery_data,
> @@ -270,7 +271,7 @@ int ocfs2_stack_supports_plocks(void);
>  int ocfs2_plock(struct ocfs2_cluster_connection *conn, u64 ino,
>  		struct file *file, int cmd, struct file_lock *fl);
>  
> -void ocfs2_stack_glue_set_locking_protocol(struct ocfs2_locking_protocol *proto);
> +void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_proto);
>  
>  
>  /* Used by stack plugins */
>   
