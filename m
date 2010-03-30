From: Jan Kara <jack@suse.cz>
Date: Tue, 30 Mar 2010 18:36:57 +0200
Subject: [Ocfs2-devel] lockdep warning in ocfs2 quota
In-Reply-To: <20100324220138.GA14310@mail.oracle.com>
References: <20100324220138.GA14310@mail.oracle.com>
Message-ID: <20100330163656.GD3424@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi Joel,

On Wed 24-03-10 15:01:39, Joel Becker wrote:
> 	I got this on an ocfs2 filesystem with quota features enabled
> (but quota enforcement not turned on).  Non-clustered ocfs2.  Fresh
> mkfs.  Untarring a kernel tree.
  Thanks for the lockdep trace.

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.34-rc1-kvm #179
> -------------------------------------------------------
> tar/2546 is trying to acquire lock:
>  (&s->s_dquot.dqio_mutex){+.+...}, at: [<c10e980f>]
> dquot_commit+0x26/0xc8
> 
> but task is already holding lock:
>  (&s->s_dquot.dqptr_sem){++++..}, at: [<c10ec9a4>]
> dquot_alloc_inode+0x63/0x133
  This is the other way around than it should be - dqptr_sem ranks above
dqio_mutex. So lockdep must have somehow established a dependency chain
in an inverse order.

> -> #1 (&journal->j_trans_barrier){.+.+..}:
>        [<c10574f2>] __lock_acquire+0x10ad/0x139e
>        [<c105787a>] lock_acquire+0x97/0xbb
>        [<c1226f90>] down_read+0x31/0x45
>        [<db4b78ab>] ocfs2_start_trans+0x9b/0x178 [ocfs2]
>        [<db4e10b1>] ocfs2_global_read_dquot+0x163/0x265 [ocfs2]
>        [<db4dda2b>] ocfs2_local_read_dquot+0x73/0xb42 [ocfs2]
>        [<c10e99a4>] dquot_acquire+0x51/0xde
>        [<db4e1949>] ocfs2_acquire_dquot+0x8c/0xee [ocfs2]
>        [<c10eb1e9>] dqget+0x293/0x2cb
>        [<c10eb67f>] __dquot_initialize+0x7c/0x155
>        [<c10ebed4>] dquot_initialize+0x10/0x12
>        [<db4bee9a>] ocfs2_get_init_inode+0xdf/0xe9 [ocfs2]
>        [<db4bf71c>] ocfs2_mknod+0x358/0xd8c [ocfs2]
>        [<db4c01c7>] ocfs2_mkdir+0x77/0xcd [ocfs2]
>        [<c10c07a0>] vfs_mkdir+0x66/0xc9
>        [<c10c2622>] sys_mkdirat+0x7f/0xba
>        [<c10c2672>] sys_mkdir+0x15/0x17
>        [<c1228035>] syscall_call+0x7/0xb
  This is the culprit - we have to do some writes when reading dquot (to
increase dquot use count and possibly also allocate space for further
writes) but ocfs2_local_read_dquot is already called with dqio_mutex
held so when ocfs2_global_read_dquot tries to start a transaction it
is a violation of lock ordering.
  I guess I'll have to move all the code from ocfs2_local_read_dquot
to ocfs2_acquire_dquot and do all the handling there with proper locking.
I'll have a look at it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
