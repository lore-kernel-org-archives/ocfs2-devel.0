From: Jan Kara <jack@suse.cz>
Date: Wed, 3 Jun 2009 23:48:52 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add lockdep annotations
In-Reply-To: <20090603163155.GD24166@mail.oracle.com>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
	<1243945445-25847-8-git-send-email-jack@suse.cz>
	<20090603163155.GD24166@mail.oracle.com>
Message-ID: <20090603214852.GA11423@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi Joel,

  thanks for review.

On Wed 03-06-09 09:31:56, Joel Becker wrote:
> On Tue, Jun 02, 2009 at 02:24:05PM +0200, Jan Kara wrote:
> > Add lockdep support to OCFS2. The support also covers all of the cluster
> > locks except for open locks, journal locks, and local quotafile locks. These
> > are special because they are acquired for a node, not for a particular process
> > and lockdep cannot deal with such type of locking.
> 
> 	I like the idea of ocfs2 having lockdep on everything.
> 
> > -static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > -				 struct ocfs2_lock_res *lockres,
> > -				 int level);
> > +static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > +				   struct ocfs2_lock_res *lockres,
> > +				   int level, unsigned long ip);
> > +static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > +					struct ocfs2_lock_res *lockres,
> > +					int level)
> > +{
> > +	__ocfs2_cluster_unlock(osb, lockres, level, _RET_IP_);
> > +}
> 
> 	I don't know why 'ip' needs to be part of the function prototype
> - every place you use it, you just pass _RET_IP_.
  The problem is following: I need to give to lockdep code an IP of a
function which acquires a lock. For this to be useful I don't want to show
"ocfs2_cluster_lock" or "ocfs2_rw_lock" all the time. So I have to get IP
of the function calling e.g. ocfs2_rw_lock and that's why there's this
ip argument because it's hard to find what the IP of the caller of our
caller is...

> > @@ -1239,11 +1256,21 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
> >  	return ret;
> >  }
> >  
> > -static int ocfs2_cluster_lock(struct ocfs2_super *osb,
> > -			      struct ocfs2_lock_res *lockres,
> > -			      int level,
> > -			      u32 lkm_flags,
> > -			      int arg_flags)
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> > +				struct ocfs2_lock_res *lockres,
> > +				int level,
> > +				u32 lkm_flags,
> > +				int arg_flags,
> > +				int l_subclass,
> > +				unsigned long ip)
> > +#else
> > +static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> > +				struct ocfs2_lock_res *lockres,
> > +				int level,
> > +				u32 lkm_flags,
> > +				int arg_flags)
> > +#endif
> >  {
> >  	struct ocfs2_mask_waiter mw;
> >  	int wait, catch_signals = !(osb->s_mount_opt & OCFS2_MOUNT_NOINTR);
> > @@ -1386,13 +1413,45 @@ out:
> >  	}
> >  	ocfs2_update_lock_stats(lockres, level, &mw, ret);
> >  
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +	if (!ret && lockres->l_lockdep_map.key != NULL) {
> > +		if (level == DLM_LOCK_PR)
> > +			rwsem_acquire_read(&lockres->l_lockdep_map, l_subclass,
> > +				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
> > +		else
> > +			rwsem_acquire(&lockres->l_lockdep_map, l_subclass,
> > +				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
> > +	}
> > +#endif
> >  	mlog_exit(ret);
> >  	return ret;
> >  }
> 
> 	Here again you've wrapped an ifdef around whether 'ip' is in the
> argument list or not.  Since it's always _RET_IP_, why not just leave it
> out of the argument list and just pas _RET_IP_ to the rwsem_acquire
> calls?  That also eliminates the ugly ifdefs and need for
> __ocfs2_cluster_lock().
  I agree ifdefs aren't nice but I wanted to avoid the unnecessary argument
in !LOCKDEP case. I could also just always pass _RET_IP_ and hope that
compiler optimizes this in case we don't use the value of ip argument in
!LOCKDEP case.
  I can do that if you think it's better.
 
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > +				   struct ocfs2_lock_res *lockres,
> > +				   int level,
> > +				   unsigned long ip)
> > +#else
> > +static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > +				   struct ocfs2_lock_res *lockres,
> > +				   int level)
> > +#endif
> >  {
> >  	unsigned long flags;
> >  
> > @@ -1401,6 +1460,10 @@ static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> >  	ocfs2_dec_holders(lockres, level);
> >  	ocfs2_downconvert_on_unlock(osb, lockres);
> >  	spin_unlock_irqrestore(&lockres->l_lock, flags);
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +	if (lockres->l_lockdep_map.key != NULL)
> > +		rwsem_release(&lockres->l_lockdep_map, 1, ip);
> > +#endif
> >  	mlog_exit_void();
> >  }
> 
> 	Same here.
> 
> > @@ -2145,10 +2208,11 @@ static int ocfs2_assign_bh(struct inode *inode,
> >   * returns < 0 error if the callback will never be called, otherwise
> >   * the result of the lock will be communicated via the callback.
> >   */
> > -int ocfs2_inode_lock_full(struct inode *inode,
> > -			 struct buffer_head **ret_bh,
> > -			 int ex,
> > -			 int arg_flags)
> > +int ocfs2_inode_lock_full_nested(struct inode *inode,
> > +				 struct buffer_head **ret_bh,
> > +				 int ex,
> > +				 int arg_flags,
> > +				 int subclass)
> >  {
> >  	int status, level, acquired;
> >  	u32 dlm_flags;
> > @@ -2186,7 +2250,12 @@ int ocfs2_inode_lock_full(struct inode *inode,
> >  	if (arg_flags & OCFS2_META_LOCK_NOQUEUE)
> >  		dlm_flags |= DLM_LKF_NOQUEUE;
> >  
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +	status = __ocfs2_cluster_lock(osb, lockres, level, dlm_flags,
> > +				      arg_flags, subclass, _RET_IP_);
> > +#else
> >  	status = ocfs2_cluster_lock(osb, lockres, level, dlm_flags, arg_flags);
> > +#endif
> 
> 	This hunk wouldn't be necessary either.
> 
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -215,6 +215,8 @@ bail:
> >  static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
> >  {
> >  	struct ocfs2_find_inode_args *args = opaque;
> > +	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
> > +				     ocfs2_file_ip_alloc_sem_key;
> >  
> >  	mlog_entry("inode = %p, opaque = %p\n", inode, opaque);
> >  
> > @@ -223,6 +225,15 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
> >  	if (args->fi_sysfile_type != 0)
> >  		lockdep_set_class(&inode->i_mutex,
> >  			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
> > +	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
> > +	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
> > +	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
> > +	    args->fi_sysfile_type == LOCAL_GROUP_QUOTA_SYSTEM_INODE)
> > +		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
> > +				  &ocfs2_quota_ip_alloc_sem_key);
> > +	else
> > +		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
> > +				  &ocfs2_file_ip_alloc_sem_key);
> 
> 	These keys don't need to be intialized?
  No. The key here is the fixed adress of that variable - see
include/linux/lockdep.h:
/*
 * Lock-classes are keyed via unique addresses, by embedding the
 * lockclass-key into the kernel (or module) .data section. (For
 * static locks we use the lock address itself as the key.)
 */
struct lockdep_subclass_key {
        char __one_byte;
} __attribute__ ((__packed__));

struct lock_class_key {
        struct lockdep_subclass_key     subkeys[MAX_LOCKDEP_SUBCLASSES];
};

> > diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
> > index ea71525..7096516 100644
> > --- a/fs/ocfs2/inode.h
> > +++ b/fs/ocfs2/inode.h
> > @@ -109,6 +109,14 @@ struct ocfs2_inode_info
> >  /* Indicates that the metadata cache should be used as an array. */
> >  #define OCFS2_INODE_CACHE_INLINE	0x00000080
> >  
> > +/* Locking subclasses of inode cluster lock */
> > +enum {
> > +	OI_LS_NORMAL,
> > +	OI_LS_PARENT,
> > +	OI_LS_RENAME1,
> > +	OI_LS_RENAME2,
> > +};
> > +
> 
> 	I couldn't see where OI_LS_NORMAL was ever used, until I 
> realized that your #define of ocfs2_inode_lock_full hardcodes
> OI_LS_NORMAL as '0'.  It should really use the subclass name, right?
  Ah, right. Thanks for spotting this. Fixed.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
