From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 2 Jul 2013 14:21:03 -0700
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: xattr: fix inlined xattr reflink
In-Reply-To: <20130702121753.3fac0cc4fb35893aec154178@linux-foundation.org>
References: <1372388183-6378-1-git-send-email-junxiao.bi@oracle.com>
	<20130701225746.GC965@localhost> <51D22814.7050500@oracle.com>
	<20130702015040.GJ965@localhost> <51D24521.4080202@oracle.com>
	<20130702154040.GD26307@localhost>
	<20130702121753.3fac0cc4fb35893aec154178@linux-foundation.org>
Message-ID: <20130702212102.GI26307@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 02, 2013 at 12:17:53PM -0700, Andrew Morton wrote:
> On Tue, 2 Jul 2013 08:40:42 -0700 Joel Becker <jlbec@evilplan.org> wrote:
> 
> > On Tue, Jul 02, 2013 at 11:12:33AM +0800, Junxiao Bi wrote:
> > > 
> > > 4244         mutex_lock_nested(&new_inode->i_mutex, I_MUTEX_CHILD);
> > > 4245         ret = ocfs2_inode_lock_nested(new_inode, &new_bh, 1,
> > > 4246                                       OI_LS_REFLINK_TARGET);
> > 
> > 	The i_mutex protects the VFS inode.  The ocfs2_inode_lock
> > protects against other nodes in the cluster.  new_oi->ip_lock protects
> > the ocfs2_inode_info specific stuff.
> > 	Reading a bit out of new_oi->ip_dyn_features is probably safe;
> > we are protected from inline data being converted to extents.  So I
> > suppose this isn't terribly different than xattr_ibody_init().
> 
> Was that a soggy ack?  :)

It was :-)  I've been trying to silence the niggles in the back of my
head.  But I think I comfortable.

Acked-by: Joel Becker <jlbec@evilplan.org>

> 

-- 

"You cannot bring about prosperity by discouraging thrift. You cannot
 strengthen the weak by weakening the strong. You cannot help the wage
 earner by pulling down the wage payer. You cannot further the
 brotherhood of man by encouraging class hatred. You cannot help the
 poor by destroying the rich. You cannot build character and courage by
 taking away a man's initiative and independence. You cannot help men
 permanently by doing for them what they could and should do for
 themselves."
	- Abraham Lincoln 

			http://www.jlbec.org/
			jlbec at evilplan.org
