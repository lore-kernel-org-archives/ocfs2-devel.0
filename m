From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Jun 2009 15:42:41 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add lockdep annotations
In-Reply-To: <20090603214852.GA11423@duck.suse.cz>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
	<1243945445-25847-8-git-send-email-jack@suse.cz>
	<20090603163155.GD24166@mail.oracle.com>
	<20090603214852.GA11423@duck.suse.cz>
Message-ID: <20090603224241.GB7933@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 03, 2009 at 11:48:52PM +0200, Jan Kara wrote:
> On Wed 03-06-09 09:31:56, Joel Becker wrote:
> > On Tue, Jun 02, 2009 at 02:24:05PM +0200, Jan Kara wrote:
> > > Add lockdep support to OCFS2. The support also covers all of the cluster
> > > locks except for open locks, journal locks, and local quotafile locks. These
> > > are special because they are acquired for a node, not for a particular process
> > > and lockdep cannot deal with such type of locking.
> > 
> > 	I like the idea of ocfs2 having lockdep on everything.
> > 
> > > -static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > > -				 struct ocfs2_lock_res *lockres,
> > > -				 int level);
> > > +static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > > +				   struct ocfs2_lock_res *lockres,
> > > +				   int level, unsigned long ip);
> > > +static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > > +					struct ocfs2_lock_res *lockres,
> > > +					int level)
> > > +{
> > > +	__ocfs2_cluster_unlock(osb, lockres, level, _RET_IP_);
> > > +}
> > 
> > 	I don't know why 'ip' needs to be part of the function prototype
> > - every place you use it, you just pass _RET_IP_.
>   The problem is following: I need to give to lockdep code an IP of a
> function which acquires a lock. For this to be useful I don't want to show
> "ocfs2_cluster_lock" or "ocfs2_rw_lock" all the time. So I have to get IP
> of the function calling e.g. ocfs2_rw_lock and that's why there's this
> ip argument because it's hard to find what the IP of the caller of our
> caller is...

	Doesn't lockdep provide backtraces when things go wrong?  Or is
this used to differentiate between callers internally in lockdep?

> > > @@ -1239,11 +1256,21 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
> > >  	return ret;
> > >  }
> > >  
> > > -static int ocfs2_cluster_lock(struct ocfs2_super *osb,
> > > -			      struct ocfs2_lock_res *lockres,
> > > -			      int level,
> > > -			      u32 lkm_flags,
> > > -			      int arg_flags)
> > > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > > +static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> > > +				struct ocfs2_lock_res *lockres,
> > > +				int level,
> > > +				u32 lkm_flags,
> > > +				int arg_flags,
> > > +				int l_subclass,
> > > +				unsigned long ip)
> > > +#else
> > > +static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> > > +				struct ocfs2_lock_res *lockres,
> > > +				int level,
> > > +				u32 lkm_flags,
> > > +				int arg_flags)
> > > +#endif
> > >  {
> > >  	struct ocfs2_mask_waiter mw;
> > >  	int wait, catch_signals = !(osb->s_mount_opt & OCFS2_MOUNT_NOINTR);
> > > @@ -1386,13 +1413,45 @@ out:
> > >  	}
> > >  	ocfs2_update_lock_stats(lockres, level, &mw, ret);
> > >  
> > > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > > +	if (!ret && lockres->l_lockdep_map.key != NULL) {
> > > +		if (level == DLM_LOCK_PR)
> > > +			rwsem_acquire_read(&lockres->l_lockdep_map, l_subclass,
> > > +				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
> > > +		else
> > > +			rwsem_acquire(&lockres->l_lockdep_map, l_subclass,
> > > +				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
> > > +	}
> > > +#endif
> > >  	mlog_exit(ret);
> > >  	return ret;
> > >  }
> > 
> > 	Here again you've wrapped an ifdef around whether 'ip' is in the
> > argument list or not.  Since it's always _RET_IP_, why not just leave it
> > out of the argument list and just pas _RET_IP_ to the rwsem_acquire
> > calls?  That also eliminates the ugly ifdefs and need for
> > __ocfs2_cluster_lock().
>   I agree ifdefs aren't nice but I wanted to avoid the unnecessary argument
> in !LOCKDEP case. I could also just always pass _RET_IP_ and hope that
> compiler optimizes this in case we don't use the value of ip argument in
> !LOCKDEP case.
>   I can do that if you think it's better.

	I would much rather you just rename to __ocfs2.., add the
argument, call it "caller_ip", and then wrap it with a static inline.
This keeps the ifdefs in one place and much more readable.  You can pass
0 when lockdep isn't enabled:

#ifdef CONFIG_DEBUG_LOCK_ALLOC
static inline int ocfs2_cluster_lock(struct ocfs2_super *osb,
				     struct ocfs2_lock_res *lockres,
				     int level,
				     u32 lkm_flags,
				     int arg_flags)
{
	return __ocfs2_cluster_lock(osb, lockres, level, lkm_flags,
				    arg_flags, _RET_IP_);
}

static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
					struct ocfs2_lock_res *lockres,
					int level)
{
	return __ocfs2_cluster_unlock(osb, lockres, level, _RET_IP_);
}
#else
static inline int ocfs2_cluster_lock(struct ocfs2_super *osb,
				     struct ocfs2_lock_res *lockres,
				     int level,
				     u32 lkm_flags,
				     int arg_flags)
{
	return __ocfs2_cluster_lock(osb, lockres, level, lkm_flags,
				    arg_flags, 0);
}

static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
					struct ocfs2_lock_res *lockres,
					int level)
{
	return __ocfs2_cluster_unlock(osb, lockres, level, 0);
}
#endif

	Don't worry about the efficiency of passing a sixth argument.
That generally fits on x86, and ocfs2 is one of the worst abusers of
12-argument functions anyway.  Locking code really, really wants
readability first.

> > > @@ -223,6 +225,15 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
> > >  	if (args->fi_sysfile_type != 0)
> > >  		lockdep_set_class(&inode->i_mutex,
> > >  			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
> > > +	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
> > > +	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
> > > +	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
> > > +	    args->fi_sysfile_type == LOCAL_GROUP_QUOTA_SYSTEM_INODE)
> > > +		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
> > > +				  &ocfs2_quota_ip_alloc_sem_key);
> > > +	else
> > > +		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
> > > +				  &ocfs2_file_ip_alloc_sem_key);
> > 
> > 	These keys don't need to be intialized?
>   No. The key here is the fixed adress of that variable - see
> include/linux/lockdep.h:
> /*
>  * Lock-classes are keyed via unique addresses, by embedding the
>  * lockclass-key into the kernel (or module) .data section. (For
>  * static locks we use the lock address itself as the key.)
>  */
> struct lockdep_subclass_key {
>         char __one_byte;
> } __attribute__ ((__packed__));
> 
> struct lock_class_key {
>         struct lockdep_subclass_key     subkeys[MAX_LOCKDEP_SUBCLASSES];
> };

	Ok, got it.

Joel

-- 

"Heav'n hath no rage like love to hatred turn'd, nor Hell a fury,
 like a woman scorn'd."
        - William Congreve

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
