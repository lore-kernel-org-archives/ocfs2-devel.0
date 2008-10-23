From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Oct 2008 01:16:51 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: fix for nfs getting
	stale	inode.
In-Reply-To: <200810230419.m9N4JLpn012453@localhost.localdomain>
References: <200810230419.m9N4JLpn012453@localhost.localdomain>
Message-ID: <20081023081650.GA1580@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 23, 2008 at 12:19:21PM +0800, wengang wang wrote:
> Ocfs2 supports exporting. 
> 
> PROBLEM:
> There are 2 problems
> (1) Current version of ocfs2_get_dentry() may read from disk
> the inode WITHOUT any cross cluster lock. This may lead to load a stale inode.
> (2) for deleting an inode, ocfs2_remove_inode() doesn't sync/checkpoint to disk.
> This also may lead ocfs2_get_dentry() from other node read out stale inode.
> 
<snip> 
> SOLUTION:
> (I) adds cross cluster lock for deletion and reading inode from nfs. Deletion
> takes EX lock which blocks readings on the same inode block; readings take PR
> lock which blocks deleting the same inode block.
> (II) checkpoints disk updates for deletion within the cross cluster lock.

	Cluster locking in an already slow path really bothers me,
especially since I gotta believe we already have the state to do this
locally.
	What's the problem other than ESTALE?  That's perfectly valid in
the world of NFS.

Joel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
