From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 10 Sep 2010 17:22:43 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2/dlm: make dynamic lvb alloc work
In-Reply-To: <201008261310.o7Q90KvJ016660@acsinet15.oracle.com>
References: <201008261310.o7Q90KvJ016660@acsinet15.oracle.com>
Message-ID: <4C8ACBD3.4090706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

BTW, you are forgetting user_dlm. Not userspace dlm, but user dlm.
So the premise here is that we can skip allocating space for the lvb
based on the lockname. That will work for fs locks. But not for dlmfs/
userdlm because we allow users to create any lockname.

Now granted we can then say that lvb is not available for userdlm.
But we do provide that facility right now.

Joel, Thoughts?

On 08/26/2010 06:08 AM, Wengang Wang wrote:
> This fat patch tries to allocate lvb for dlm_lock.
> It also tried to do with the followings.
> 1. locate the lvb. Since so far we support both dlm(fs/dlm) and o2dlm
>     (fs/ocfs2/dlm), lvbs are at different offsets in the two stacks.
> 2. deal with the situation when we can't determine the location of lvb.
>     location of lvb depends on the stack we use. before the stack is available
>     we don't know lvb's location. but we need to setup some dlm_lock before
>     stack is available.
> 3. deal with special dlm_locks, such as those for quota and dentry.
> 4. deal with user dlm.
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dcache.c        |    1 +
>   fs/ocfs2/dlm/dlmapi.h    |    2 +-
>   fs/ocfs2/dlm/dlmcommon.h |    1 +
>   fs/ocfs2/dlm/dlmlock.c   |    7 +++++
>   fs/ocfs2/dlm/dlmmaster.c |    2 +-
>   fs/ocfs2/dlmglue.c       |    7 +++++
>   fs/ocfs2/quota_local.c   |    7 +++++
>   fs/ocfs2/stack_user.c    |    7 -----
>   fs/ocfs2/stackglue.c     |   49 +++++++++++++++++++++++++++++++++++++
>   fs/ocfs2/stackglue.h     |   19 ++++----------
>   fs/ocfs2/super.c         |   60 +++++++++++++++++++++++++++++++++++++++++++++-
>   11 files changed, 139 insertions(+), 23 deletions(-)
>
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index b4957c7..b3ae021 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -275,6 +275,7 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>   		return ret;
>   	}
>
> +	*ocfs2_retrieve_lvb(&dl->dl_lockres.l_lksb) = NULL;
>   	dl->dl_count = 0;
>   	/*
>   	 * Does this have to happen below, for all attaches, in case
> diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
> index 3cfa114..c42bdfd 100644
> --- a/fs/ocfs2/dlm/dlmapi.h
> +++ b/fs/ocfs2/dlm/dlmapi.h
> @@ -112,7 +112,7 @@ struct dlm_lockstatus {
>   	enum dlm_status status;
>   	u32 flags;
>   	struct dlm_lock *lockid;
> -	char lvb[DLM_LVB_LEN];
> +	char *lvb;
>   };
>
>   /* Valid lock modes. */
> diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> index 4e10aa6..c5f3ce3 100644
> --- a/fs/ocfs2/dlm/dlmcommon.h
> +++ b/fs/ocfs2/dlm/dlmcommon.h
> @@ -861,6 +861,7 @@ struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
>   struct dlm_lock_resource *dlm_new_lockres(struct dlm_ctxt *dlm,
>   					  const char *name,
>   					  unsigned int namelen);
> +int dlm_lockres_uses_lvb(struct dlm_lock_resource *res);
>
>   #define dlm_lockres_set_refmap_bit(bit,res)  \
>   	__dlm_lockres_set_refmap_bit(bit,res,__FILE__,__LINE__)
> diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
> index 7d0bef2..232eeaf 100644
> --- a/fs/ocfs2/dlm/dlmlock.c
> +++ b/fs/ocfs2/dlm/dlmlock.c
> @@ -370,6 +370,7 @@ static void dlm_lock_release(struct kref *kref)
>
>   	if (lock->lksb_kernel_allocated) {
>   		mlog(0, "freeing kernel-allocated lksb\n");
> +		kfree(lock->lksb->lvb);
>   		kfree(lock->lksb);
>   	}
>   	kmem_cache_free(dlm_lock_cache, lock);
> @@ -449,6 +450,12 @@ struct dlm_lock * dlm_new_lock(int type, u8 node, u64 cookie,
>   			kfree(lock);
>   			return NULL;
>   		}
> +		
> +		if (dlm_lockres_uses_lvb(res)&&  (!dlm_alloc_lvb(&lksb->lvb))) {
> +			kfree(lksb);
> +			kfree(lock);
> +			return NULL;
> +		}
>   		kernel_allocated = 1;
>   	}
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 77315a4..a7b9bd4 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -554,7 +554,7 @@ void dlm_lockres_put(struct dlm_lock_resource *res)
>   	kref_put(&res->refs, dlm_lockres_release);
>   }
>
> -static int dlm_lockres_uses_lvb(struct dlm_lock_resource *res)
> +int dlm_lockres_uses_lvb(struct dlm_lock_resource *res)
>   {
>   	switch (res->lockname.name[0]) {
>   	case 'M':
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 5e02a89..84b2f32 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -729,6 +729,9 @@ void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
>
>   void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
>   {
> +	char **lvbpp = ocfs2_retrieve_lvb(&res->l_lksb);
> +	char *lvb = lvbpp? *lvbpp: NULL;
> +
>   	mlog_entry_void();
>
>   	if (!(res->l_flags&  OCFS2_LOCK_INITIALIZED))
> @@ -754,6 +757,10 @@ void ocfs2_lock_res_free(struct ocfs2_lock_res *res)
>
>   	/* Need to clear out the lock status block for the dlm */
>   	memset(&res->l_lksb, 0, sizeof(res->l_lksb));
> +	if (lvb) {
> +		memset(lvb, 0, DLM_LVB_LEN);
> +		*lvbpp = lvb;
> +	}
>
>   	res->l_flags = 0UL;
>   	mlog_exit_void();
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index dc78764..cc458f4 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -700,6 +700,11 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>   			       " info.");
>   		goto out_err;
>   	}
> +	if (ocfs2_alloc_lvb(&oinfo->dqi_gqlock.l_lksb)) {
> +		mlog(ML_ERROR, "no memory for lvb\n");
> +		goto out_err;
> +	}
> +
>   	info->dqi_priv = oinfo;
>   	oinfo->dqi_type = type;
>   	INIT_LIST_HEAD(&oinfo->dqi_chunk);
> @@ -781,6 +786,7 @@ out_err:
>   		if (locked)
>   			ocfs2_inode_unlock(lqinode, 1);
>   		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
> +		ocfs2_free_lvb(&oinfo->dqi_gqlock.l_lksb);
>   		kfree(oinfo);
>   	}
>   	brelse(bh);
> @@ -862,6 +868,7 @@ out:
>   	ocfs2_inode_unlock(sb_dqopt(sb)->files[type], 1);
>   	brelse(oinfo->dqi_libh);
>   	brelse(oinfo->dqi_lqi_bh);
> +	ocfs2_free_lvb(&oinfo->dqi_gqlock.l_lksb);
>   	kfree(oinfo);
>   	return 0;
>   }
> diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
> index 2dc57bc..7534795 100644
> --- a/fs/ocfs2/stack_user.c
> +++ b/fs/ocfs2/stack_user.c
> @@ -701,10 +701,6 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
>   {
>   	int ret;
>
> -	if (!lksb->lksb_fsdlm.sb_lvbptr)
> -		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
> -					     sizeof(struct dlm_lksb);
> -
>   	ret = dlm_lock(conn->cc_lockspace, mode,&lksb->lksb_fsdlm,
>   		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
>   		       fsdlm_lock_ast_wrapper, lksb,
> @@ -737,9 +733,6 @@ static int user_dlm_lvb_valid(struct ocfs2_dlm_lksb *lksb)
>
>   static void *user_dlm_lvb(struct ocfs2_dlm_lksb *lksb)
>   {
> -	if (!lksb->lksb_fsdlm.sb_lvbptr)
> -		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
> -					     sizeof(struct dlm_lksb);
>   	return (void *)(lksb->lksb_fsdlm.sb_lvbptr);
>   }
>
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 39abf89..a32bdf3 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -719,6 +719,55 @@ static void __exit ocfs2_stack_glue_exit(void)
>   		unregister_sysctl_table(ocfs2_table_header);
>   }
>
> +char ** ocfs2_retrieve_lvb(struct ocfs2_dlm_lksb *lksb)
> +{
> +	char **lvb = NULL;
> +
> +	if(!active_stack)
> +		return NULL;
> +
> +	if (strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_O2CB) == 0)
> +		lvb =&lksb->lksb_o2dlm.lvb;
> +	else if (strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_USER) == 0)
> +		lvb =&lksb->lksb_fsdlm.sb_lvbptr;
> +	else
> +		BUG();
> +
> +	return lvb;
> +}
> +EXPORT_SYMBOL_GPL(ocfs2_retrieve_lvb);
> +
> +int ocfs2_alloc_lvb(struct ocfs2_dlm_lksb *lksb)
> +{
> +	char **lvb;
> +
> +	lvb = ocfs2_retrieve_lvb(lksb);
> +	/*
> +	 * when called in ocfs2_initialize_super, active_stack is not valid yet
> +	 */
> +	if (!lvb) {
> +		memset(lksb, 0, sizeof(struct ocfs2_dlm_lksb));
> +		return 0;
> +	}
> +	*lvb = kzalloc(DLM_LVB_LEN, GFP_NOFS);
> +	if (!*lvb)
> +		return -ENOMEM;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ocfs2_alloc_lvb);
> +
> +void ocfs2_free_lvb(struct ocfs2_dlm_lksb *lksb)
> +{
> +	char **lvb;
> +
> +	lvb = ocfs2_retrieve_lvb(lksb);
> +	if (!lvb)
> +		return;
> +	kfree(*lvb);
> +	*lvb = NULL;
> +}
> +EXPORT_SYMBOL_GPL(ocfs2_free_lvb);
> +
>   MODULE_AUTHOR("Oracle");
>   MODULE_DESCRIPTION("ocfs2 cluter stack glue layer");
>   MODULE_LICENSE("GPL");
> diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
> index 8ce7398..f557d2e 100644
> --- a/fs/ocfs2/stackglue.h
> +++ b/fs/ocfs2/stackglue.h
> @@ -56,16 +56,6 @@ struct ocfs2_protocol_version {
>   };
>
>   /*
> - * The dlm_lockstatus struct includes lvb space, but the dlm_lksb struct only
> - * has a pointer to separately allocated lvb space.  This struct exists only to
> - * include in the lksb union to make space for a combined dlm_lksb and lvb.
> - */
> -struct fsdlm_lksb_plus_lvb {
> -	struct dlm_lksb lksb;
> -	char lvb[DLM_LVB_LEN];
> -};
> -
> -/*
>    * A union of all lock status structures.  We define it here so that the
>    * size of the union is known.  Lock status structures are embedded in
>    * ocfs2 inodes.
> @@ -73,9 +63,8 @@ struct fsdlm_lksb_plus_lvb {
>   struct ocfs2_cluster_connection;
>   struct ocfs2_dlm_lksb {
>   	 union {
> -		 struct dlm_lockstatus lksb_o2dlm;
> -		 struct dlm_lksb lksb_fsdlm;
> -		 struct fsdlm_lksb_plus_lvb padding;
> +		struct dlm_lockstatus lksb_o2dlm;
> +		struct dlm_lksb lksb_fsdlm;
>   	 };
>   	 struct ocfs2_cluster_connection *lksb_conn;
>   };
> @@ -289,4 +278,8 @@ void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_p
>   int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
>   void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
>
> +int ocfs2_alloc_lvb(struct ocfs2_dlm_lksb *lksb);
> +void ocfs2_free_lvb(struct ocfs2_dlm_lksb *lksb);
> +char ** ocfs2_retrieve_lvb(struct ocfs2_dlm_lksb *lksb);
> +
>   #endif  /* STACKGLUE_H */
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index fa1be1b..fa70c7b 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -477,6 +477,35 @@ bail:
>   	return status;
>   }
>
> +static int ocfs2_alloc_sys_inode_lvb(struct ocfs2_super *osb)
> +{
> +	int i, status;
> +	struct inode *inode;
> +
> +	status = ocfs2_alloc_lvb(&OCFS2_I(osb->root_inode)->
> +					ip_inode_lockres.l_lksb);
> +	if (status)
> +		return status;
> +	status = ocfs2_alloc_lvb(&OCFS2_I(osb->sys_root_inode)->
> +					ip_inode_lockres.l_lksb);
> +	if (status)
> +		return status;
> +
> +	for (i = OCFS2_FIRST_ONLINE_SYSTEM_INODE;
> +	     i<  NUM_SYSTEM_INODES; i++) {
> +		if (!ocfs2_need_system_inode(osb, i))
> +			continue;
> +		inode = ocfs2_get_system_file_inode(osb, i, osb->slot_num);
> +		BUG_ON(!inode);
> +		status = ocfs2_alloc_lvb(&OCFS2_I(inode)->ip_inode_lockres.l_lksb);
> +		iput(inode);
> +		if (status)
> +			return status;
> +	}
> +
> +	return 0;
> +}
> +
>   static int ocfs2_init_local_system_inodes(struct ocfs2_super *osb)
>   {
>   	struct inode *new = NULL;
> @@ -544,14 +573,23 @@ static struct inode *ocfs2_alloc_inode(struct super_block *sb)
>
>   	oi = kmem_cache_alloc(ocfs2_inode_cachep, GFP_NOFS);
>   	if (!oi)
> -		return NULL;
> +		goto nomem;
> +	memset(&oi->ip_inode_lockres.l_lksb, 0, sizeof(struct ocfs2_dlm_lksb));
> +
> +	if (ocfs2_alloc_lvb(&oi->ip_inode_lockres.l_lksb))
> +		goto nomem;
>
>   	jbd2_journal_init_jbd_inode(&oi->ip_jinode,&oi->vfs_inode);
>   	return&oi->vfs_inode;
> +nomem:
> +	if (oi)
> +		kmem_cache_free(ocfs2_inode_cachep, oi);
> +	return NULL;
>   }
>
>   static void ocfs2_destroy_inode(struct inode *inode)
>   {
> +	ocfs2_free_lvb(&OCFS2_I(inode)->ip_inode_lockres.l_lksb);
>   	kmem_cache_free(ocfs2_inode_cachep, OCFS2_I(inode));
>   }
>
> @@ -1837,6 +1875,18 @@ static int ocfs2_mount_volume(struct super_block *sb)
>   		goto leave;
>   	}
>
> +	if (ocfs2_alloc_lvb(&osb->osb_rename_lockres.l_lksb)) {
> +		status = -ENOMEM;
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
> +	if (ocfs2_alloc_lvb(&osb->osb_orphan_scan.os_lockres.l_lksb)) {
> +		status = -ENOMEM;
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
>   	status = ocfs2_super_lock(osb, 1);
>   	if (status<  0) {
>   		mlog_errno(status);
> @@ -1858,6 +1908,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
>   		goto leave;
>   	}
>
> +	status = ocfs2_alloc_sys_inode_lvb(osb);
> +	if (status) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
>   	status = ocfs2_check_volume(osb);
>   	if (status<  0) {
>   		mlog_errno(status);
> @@ -2467,6 +2523,8 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
>
>   	ocfs2_free_slot_info(osb);
>
> +	ocfs2_free_lvb(&osb->osb_rename_lockres.l_lksb);
> +	ocfs2_free_lvb(&osb->osb_orphan_scan.os_lockres.l_lksb);
>   	kfree(osb->osb_orphan_wipes);
>   	kfree(osb->slot_recovery_generations);
>   	/* FIXME
>    
