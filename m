From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 2 Jul 2013 12:17:53 -0700
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: xattr: fix inlined xattr reflink
In-Reply-To: <20130702154040.GD26307@localhost>
References: <1372388183-6378-1-git-send-email-junxiao.bi@oracle.com>
	<20130701225746.GC965@localhost> <51D22814.7050500@oracle.com>
	<20130702015040.GJ965@localhost> <51D24521.4080202@oracle.com>
	<20130702154040.GD26307@localhost>
Message-ID: <20130702121753.3fac0cc4fb35893aec154178@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2 Jul 2013 08:40:42 -0700 Joel Becker <jlbec@evilplan.org> wrote:

> On Tue, Jul 02, 2013 at 11:12:33AM +0800, Junxiao Bi wrote:
> > 
> > 4244         mutex_lock_nested(&new_inode->i_mutex, I_MUTEX_CHILD);
> > 4245         ret = ocfs2_inode_lock_nested(new_inode, &new_bh, 1,
> > 4246                                       OI_LS_REFLINK_TARGET);
> 
> 	The i_mutex protects the VFS inode.  The ocfs2_inode_lock
> protects against other nodes in the cluster.  new_oi->ip_lock protects
> the ocfs2_inode_info specific stuff.
> 	Reading a bit out of new_oi->ip_dyn_features is probably safe;
> we are protected from inline data being converted to extents.  So I
> suppose this isn't terribly different than xattr_ibody_init().

Was that a soggy ack?  :)
