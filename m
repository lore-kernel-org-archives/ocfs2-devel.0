From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 9 Jun 2010 12:53:58 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
 inode_setattr.
In-Reply-To: <20100609101434.GA17108@lst.de>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
	<20100609091604.GX26335@laptop> <4C0F5F01.8010807@oracle.com>
	<20100609093804.GY26335@laptop>
	<20100609101207.GB21239@mail.oracle.com>
	<20100609101434.GA17108@lst.de>
Message-ID: <20100609195357.GD21239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <npiggin@suse.de>, Tao Ma <tao.ma@oracle.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

On Wed, Jun 09, 2010 at 12:14:34PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 09, 2010 at 03:12:07AM -0700, Joel Becker wrote:
> > > OK, can you comment that or just open-code the truncate part of
> > > simple_setsize? It should be helpful for example with Christoph's
> > > truncate cleanup work.
> > 
> > 	Just open-code it.  The void calls are much nicer than useless
> > return code boilerplate. 
> 
> Note that if you rebase against vfs.git #for_next simple_setsize is
> replaced with a truncate_setsize that does all the work but the
> inode_newsize_ok check.  As I mentioned before please do the work ontop
> of that branch, it does make the ->setattr ATTR_SIZE implementation much
> nicer for the filesystems.

	Works for me.

Joel

-- 

"Glory is fleeting, but obscurity is forever."  
         - Napoleon Bonaparte

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
