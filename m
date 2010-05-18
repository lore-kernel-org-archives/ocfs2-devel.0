From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 May 2010 15:49:30 -0700
Subject: [Ocfs2-devel] [PATCH 00/17 V2] ocfs2: Support for discontiguous
 block group.
In-Reply-To: <20100518224556.GM3239@mail.oracle.com>
References: <4BCFEF22.7080607@oracle.com>
	<20100517192147.GB22775@mail.oracle.com>
	<4BF1D73F.3030600@oracle.com>
	<20100518224556.GM3239@mail.oracle.com>
Message-ID: <20100518224930.GN3239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 18, 2010 at 03:45:56PM -0700, Joel Becker wrote:
> On Tue, May 18, 2010 at 07:54:39AM +0800, Tao Ma wrote:
> > > 	Let me know if/when your discontig-bg branch has the code you
> > > want to go upstream.  It may already; I'm just confirming before I pull.
> > >   
> > It is ok there. please pull
> > 
> > git://oss.oracle.com/git/tma/linux-2.6.git discontig-bg
> 
> Tao,
> 	This branch has the bogus orig_value_size fix.  The good one is
> in the fixes branch, and they conflict.  Also, you have three patches in
> this branch without descriptions:
> 
>       patch speedup.fix
>       patch unwritten.fix
>       patch DLM.fix
> 
> Please fix this.

	Actually, your discontig-bg branch doesn't look much like this
patch series at all.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
