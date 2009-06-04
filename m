From: Jan Kara <jack@suse.cz>
Date: Thu, 4 Jun 2009 12:22:47 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add lockdep annotations
In-Reply-To: <20090603224241.GB7933@mail.oracle.com>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
	<1243945445-25847-8-git-send-email-jack@suse.cz>
	<20090603163155.GD24166@mail.oracle.com>
	<20090603214852.GA11423@duck.suse.cz>
	<20090603224241.GB7933@mail.oracle.com>
Message-ID: <20090604102247.GB2859@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 03-06-09 15:42:41, Joel Becker wrote:
> On Wed, Jun 03, 2009 at 11:48:52PM +0200, Jan Kara wrote:
> > On Wed 03-06-09 09:31:56, Joel Becker wrote:
> > > On Tue, Jun 02, 2009 at 02:24:05PM +0200, Jan Kara wrote:
> > > > Add lockdep support to OCFS2. The support also covers all of the cluster
> > > > locks except for open locks, journal locks, and local quotafile locks. These
> > > > are special because they are acquired for a node, not for a particular process
> > > > and lockdep cannot deal with such type of locking.
> > > 
> > > 	I like the idea of ocfs2 having lockdep on everything.
> > > 
> > > > -static void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > > > -				 struct ocfs2_lock_res *lockres,
> > > > -				 int level);
> > > > +static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > > > +				   struct ocfs2_lock_res *lockres,
> > > > +				   int level, unsigned long ip);
> > > > +static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> > > > +					struct ocfs2_lock_res *lockres,
> > > > +					int level)
> > > > +{
> > > > +	__ocfs2_cluster_unlock(osb, lockres, level, _RET_IP_);
> > > > +}
> > > 
> > > 	I don't know why 'ip' needs to be part of the function prototype
> > > - every place you use it, you just pass _RET_IP_.
> >   The problem is following: I need to give to lockdep code an IP of a
> > function which acquires a lock. For this to be useful I don't want to show
> > "ocfs2_cluster_lock" or "ocfs2_rw_lock" all the time. So I have to get IP
> > of the function calling e.g. ocfs2_rw_lock and that's why there's this
> > ip argument because it's hard to find what the IP of the caller of our
> > caller is...
> 
> 	Doesn't lockdep provide backtraces when things go wrong?  Or is
> this used to differentiate between callers internally in lockdep?
  Yes, it does. But this IP is for the message like:
 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.25-0.161.rc7.fc9.i686 #1
 -------------------------------------------------------
 NetworkManager/2308 is trying to acquire lock:
  (events){--..}, at: [flush_workqueue+0/133] flush_workqueue+0x0/0x85
                       ^^^^^^^^^^^^^^^^^^^^^^ HERE
 
 but task is already holding lock:
  (rtnl_mutex){--..}, at: [rtnetlink_rcv+18/38] rtnetlink_rcv+0x12/0x26
                          ^^^^^^^^^^^^^^^^^^^^ HERE
 
 which lock already depends on the new lock.
 =======================================================

So it's usually possible to find all the needed information in the
backtraces but it's much more convenient to find it here at the beginning.
BTW: What I did just mimics which IP is passed for ordinary mutexes so it's
also more consistent.

> > > > @@ -1239,11 +1256,21 @@ static int ocfs2_wait_for_mask_interruptible(struct ocfs2_mask_waiter *mw,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > -static int ocfs2_cluster_lock(struct ocfs2_super *osb,
> > > > -			      struct ocfs2_lock_res *lockres,
> > > > -			      int level,
> > > > -			      u32 lkm_flags,
> > > > -			      int arg_flags)
> > > > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > > > +static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> > > > +				struct ocfs2_lock_res *lockres,
> > > > +				int level,
> > > > +				u32 lkm_flags,
> > > > +				int arg_flags,
> > > > +				int l_subclass,
> > > > +				unsigned long ip)
> > > > +#else
> > > > +static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> > > > +				struct ocfs2_lock_res *lockres,
> > > > +				int level,
> > > > +				u32 lkm_flags,
> > > > +				int arg_flags)
> > > > +#endif
> > > >  {
> > > >  	struct ocfs2_mask_waiter mw;
> > > >  	int wait, catch_signals = !(osb->s_mount_opt & OCFS2_MOUNT_NOINTR);
> > > > @@ -1386,13 +1413,45 @@ out:
> > > >  	}
> > > >  	ocfs2_update_lock_stats(lockres, level, &mw, ret);
> > > >  
> > > > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > > > +	if (!ret && lockres->l_lockdep_map.key != NULL) {
> > > > +		if (level == DLM_LOCK_PR)
> > > > +			rwsem_acquire_read(&lockres->l_lockdep_map, l_subclass,
> > > > +				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
> > > > +		else
> > > > +			rwsem_acquire(&lockres->l_lockdep_map, l_subclass,
> > > > +				!!(arg_flags & OCFS2_META_LOCK_NOQUEUE), ip);
> > > > +	}
> > > > +#endif
> > > >  	mlog_exit(ret);
> > > >  	return ret;
> > > >  }
> > > 
> > > 	Here again you've wrapped an ifdef around whether 'ip' is in the
> > > argument list or not.  Since it's always _RET_IP_, why not just leave it
> > > out of the argument list and just pas _RET_IP_ to the rwsem_acquire
> > > calls?  That also eliminates the ugly ifdefs and need for
> > > __ocfs2_cluster_lock().
> >   I agree ifdefs aren't nice but I wanted to avoid the unnecessary argument
> > in !LOCKDEP case. I could also just always pass _RET_IP_ and hope that
> > compiler optimizes this in case we don't use the value of ip argument in
> > !LOCKDEP case.
> >   I can do that if you think it's better.
> 
> 	I would much rather you just rename to __ocfs2.., add the
> argument, call it "caller_ip", and then wrap it with a static inline.
> This keeps the ifdefs in one place and much more readable.  You can pass
> 0 when lockdep isn't enabled:
> 
> #ifdef CONFIG_DEBUG_LOCK_ALLOC
> static inline int ocfs2_cluster_lock(struct ocfs2_super *osb,
> 				     struct ocfs2_lock_res *lockres,
> 				     int level,
> 				     u32 lkm_flags,
> 				     int arg_flags)
> {
> 	return __ocfs2_cluster_lock(osb, lockres, level, lkm_flags,
> 				    arg_flags, _RET_IP_);
> }
> 
> static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> 					struct ocfs2_lock_res *lockres,
> 					int level)
> {
> 	return __ocfs2_cluster_unlock(osb, lockres, level, _RET_IP_);
> }
> #else
> static inline int ocfs2_cluster_lock(struct ocfs2_super *osb,
> 				     struct ocfs2_lock_res *lockres,
> 				     int level,
> 				     u32 lkm_flags,
> 				     int arg_flags)
> {
> 	return __ocfs2_cluster_lock(osb, lockres, level, lkm_flags,
> 				    arg_flags, 0);
> }
> 
> static inline void ocfs2_cluster_unlock(struct ocfs2_super *osb,
> 					struct ocfs2_lock_res *lockres,
> 					int level)
> {
> 	return __ocfs2_cluster_unlock(osb, lockres, level, 0);
> }
> #endif
> 
> 	Don't worry about the efficiency of passing a sixth argument.
> That generally fits on x86, and ocfs2 is one of the worst abusers of
> 12-argument functions anyway.  Locking code really, really wants
> readability first.
  OK, I like what you suggest. Will do.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
