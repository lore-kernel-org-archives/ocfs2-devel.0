From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 9 Feb 2009 20:14:55 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V2).
In-Reply-To: <4990F7F1.9000903@oracle.com>
References: <200812120900.mBC90imR012722@localhost.localdomain>
	<20090130011115.GF12502@mail.oracle.com>
	<4990D968.1050703@oracle.com>
	<20090210032554.GF4341@mail.oracle.com>
	<4990F7F1.9000903@oracle.com>
Message-ID: <20090210041455.GH4341@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 10, 2009 at 11:43:45AM +0800, Wengang Wang wrote:
> Joel Becker wrote:
> > On Tue, Feb 10, 2009 at 09:33:28AM +0800, Wengang Wang wrote:
> >> one thing is that, the "nfs_sync_lock" will be one in count or more than 
> >> one?
> >> I think having lots of this kind of lock(one for each meta block) will 
> >> bring us least performance impact for deletions.
> >> well so much locks eat memory. for balancing, how about setting up 16(or 
> >> 32) such locks? different inode goes to different lock according to its 
> >> block number. and 16(or 32) such locks won't take much memory. --just 
> >> like the idea in my original patch.
> > 
> > 	No, we'll have one lock per superblock.  There's no performance
> > impact unless you have stale NFS clients.  We take the lock in PR mode
> > in delete_inode, and the lock caching mechanism will keep it for us.
> > The lock will only be unlocked when a stale NFS client wants to lookup
> > its handle.  Otherwise, all nodes will share the PR lock.
> 
> yes. I know what EX/PR mean and lock caching.
> for NFS backed on OCFS2, I think there could be stale clients according 
> to the file accessing mode(create, delete on so on) on ocfs2.
> when a EX lock is held for nfs, all delete_inode()s have to wait. that's 
> a big lock and could be a performance impact. here, I emphasize ALL. I 
> don't think it's simply like rename lock.
> 
> is that an abnormal case?

	Yes, all delete_inode()s have to wait.  That's what we want.  It
shouldn't be a performance impact, because it shouldn't be the normal
case.
	In the normal case, the inode cache has the inode.  When an NFS
client asks for an inode (access(2), open(2), stat(2), etc...), the NFS
server has to look up the inode.  This will put it in the inode cache.
When the NFS client open(2)s the inode, it will get an fh.  The NFS
server will have the inode in the cache.  Thus, when the NFS client asks
for an operation, the ocfs2_get_dentry() function will turn the fh into
an inode/dentry via hte ocfs2_ilookup() function you've added.   The
ocfs2_get_dentry() function never goes near the nfs_sync_lock in the
normal case.
	The nfs_sync_lock is only needed when the ocfs2_ilookup() fails.
This will happen in two cases:

1) If the NFS client went silent for a long time and the NFS server had
   memory pressure, the server may decide to flush the inode from the
   cache.  I'm not sure the Linux NFS server even does this.  It may
   keep the inode around forever until the client closes it or
   disconnects or something.

2) The NFS server rebooted for some reason.  Now the client comes back
   with a live fh and asks for the inode.  The NFS server, being
   stateless, has to re-open the file and pretend it was open all along.
   This is what we're really dealing with here.

	Both cases 1 and 2 are rare.  If they go a little slow, we don't
care.  What we don't want to do is penalize the normal case just to
optimize these exceptional cases.

Joel

-- 

"Not being known doesn't stop the truth from being true."
        - Richard Bach

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
