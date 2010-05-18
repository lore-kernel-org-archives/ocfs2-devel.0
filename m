From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 May 2010 16:53:05 -0700
Subject: [Ocfs2-devel] [PATCH 00/17 V2] ocfs2: Support for discontiguous
 block group.
In-Reply-To: <4BF31C10.5040206@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
	<20100517192147.GB22775@mail.oracle.com>
	<4BF1D73F.3030600@oracle.com>
	<20100518224556.GM3239@mail.oracle.com>
	<4BF31C10.5040206@oracle.com>
Message-ID: <20100518235305.GO3239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 19, 2010 at 07:00:32AM +0800, Tao Ma wrote:
> Joel Becker wrote:
> > On Tue, May 18, 2010 at 07:54:39AM +0800, Tao Ma wrote:
> >   
> >>> 	Let me know if/when your discontig-bg branch has the code you
> >>> want to go upstream.  It may already; I'm just confirming before I pull.
> >>>   
> >>>       
> >> It is ok there. please pull
> >>
> >> git://oss.oracle.com/git/tma/linux-2.6.git discontig-bg
> >>     
> >
> > Tao,
> > 	This branch has the bogus orig_value_size fix.  The good one is
> > in the fixes branch, and they conflict.  Also, you have three patches in
> > this branch without descriptions:
> >
> >       patch speedup.fix
> >       patch unwritten.fix
> >       patch DLM.fix
> >
> > Please fix this.
> >   
> done. Sorry for the inconvenience.

	It's now in the merge-window branch of ocfs2.git.

Joel

-- 

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
