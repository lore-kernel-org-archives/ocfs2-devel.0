From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 9 Feb 2009 19:25:54 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V2).
In-Reply-To: <4990D968.1050703@oracle.com>
References: <200812120900.mBC90imR012722@localhost.localdomain>
	<20090130011115.GF12502@mail.oracle.com>
	<4990D968.1050703@oracle.com>
Message-ID: <20090210032554.GF4341@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 10, 2009 at 09:33:28AM +0800, Wengang Wang wrote:
> one thing is that, the "nfs_sync_lock" will be one in count or more than 
> one?
> I think having lots of this kind of lock(one for each meta block) will 
> bring us least performance impact for deletions.
> well so much locks eat memory. for balancing, how about setting up 16(or 
> 32) such locks? different inode goes to different lock according to its 
> block number. and 16(or 32) such locks won't take much memory. --just 
> like the idea in my original patch.

	No, we'll have one lock per superblock.  There's no performance
impact unless you have stale NFS clients.  We take the lock in PR mode
in delete_inode, and the lock caching mechanism will keep it for us.
The lock will only be unlocked when a stale NFS client wants to lookup
its handle.  Otherwise, all nodes will share the PR lock.

Joel

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
