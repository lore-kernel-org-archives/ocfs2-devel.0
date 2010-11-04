From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Nov 2010 23:32:21 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <4CD220C9.20907@oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
	<1288782126-13007-2-git-send-email-tristan.ye@oracle.com>
	<20101104012949.GB14640@mail.oracle.com>
	<4CD220C9.20907@oracle.com>
Message-ID: <20101104063221.GC22663@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 04, 2010 at 10:56:09AM +0800, tristan wrote:
> While the user-specified chunksize is brand-new concept here;), it 
> splits the whole bitmap from chunk to chunk sequentially.
> and then to see how many of this sequential/fixed-size chunks are free. 
> it sounds like the concept of page frame for main memory.
> When a user is doing I/Os in a very size-fixed fashion, they may be 
> happy to see how many chunks were fully free there.

	Let me see if I understand this.  If the user specified a
chunksize of 64M and you find a free extent of 640M, your free list will
say, "I've got one free extent of more than 128M," while your chunksize
logic also reports, "I've got ten 64M chunks?"  Is that right?

> >> +		status = ocfs2_read_inode_block(gb_inode, &bh);
> >> +		if (status < 0) {
> >> +			mlog_errno(status);
> >> +			goto bail;
> >> +		}
> >> +	}
> >
> > 	Same thoughts about ocfs2_ilookup() here.
> 
> Why we need to think about ocfs2_ilookup? since we're just trying to get 
> a inode block here, not a cached VFS inode.

	If you already have the blkno, you're not igetting, and that's
fine.  My bad.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
