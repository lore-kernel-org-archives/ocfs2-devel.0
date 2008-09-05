From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 4 Sep 2008 18:38:16 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Limit inode allocation
	to	32bits.
In-Reply-To: <20080905002749.GA29097@lst.de>
References: <1220497421-8606-1-git-send-email-joel.becker@oracle.com>
	<1220497421-8606-2-git-send-email-joel.becker@oracle.com>
	<20080905002749.GA29097@lst.de>
Message-ID: <20080905013816.GA28061@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 05, 2008 at 02:27:49AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 03, 2008 at 08:03:39PM -0700, Joel Becker wrote:
> > ocfs2 inode numbers are block numbers.  For any filesystem with less
> > than 2^32 blocks, this is not a problem.  However, when ocfs2 starts
> > using JDB2, it will be able to support filesystems with more than 2^32
> > blocks.  This would result in inode numbers higher than 2^32.
> > 
> > The problem is that stat(2) can't handle those numbers on 32bit
> > machines.  The simple solution is to have ocfs2 allocate all inodes
> > below that boundary.
> 
> Actually stat64 which most apps should use handles it just fine, but
> there are various programs still around not using it.

	Somehow I got the impression that some systems couldn't handle
inode64 at all.  If it's just some userspace, that gives us more
flexibility.

Joel

-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
