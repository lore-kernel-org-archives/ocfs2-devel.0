From: Christoph Hellwig <hch@lst.de>
Date: Fri, 5 Sep 2008 02:27:49 +0200
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Limit inode allocation to
	32bits.
In-Reply-To: <1220497421-8606-2-git-send-email-joel.becker@oracle.com>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
	<1220497421-8606-2-git-send-email-joel.becker@oracle.com>
Message-ID: <20080905002749.GA29097@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 03, 2008 at 08:03:39PM -0700, Joel Becker wrote:
> ocfs2 inode numbers are block numbers.  For any filesystem with less
> than 2^32 blocks, this is not a problem.  However, when ocfs2 starts
> using JDB2, it will be able to support filesystems with more than 2^32
> blocks.  This would result in inode numbers higher than 2^32.
> 
> The problem is that stat(2) can't handle those numbers on 32bit
> machines.  The simple solution is to have ocfs2 allocate all inodes
> below that boundary.

Actually stat64 which most apps should use handles it just fine, but
there are various programs still around not using it.

But limiting your inodes to this lower part of the disk really, really
sucks.  XFS has the same problem because it also has a direct
corelation of inode numbers and disk addresses.  It's so bad for some
workloads that there have been repeated talks about adding a virtual
to physical inode number remapping btree.

At least make this limitation a mount option, similar to inode64 in XFS.
