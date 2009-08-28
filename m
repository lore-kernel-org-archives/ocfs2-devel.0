From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 28 Aug 2009 01:14:52 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <4A9789E5.9090205@oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
	<20090828011018.GG18962@mail.oracle.com>
	<4A973D1D.70500@oracle.com>
	<20090828053911.GB19658@mail.oracle.com>
	<4A978098.60306@oracle.com>
	<20090828073359.GC19658@mail.oracle.com>
	<4A9789E5.9090205@oracle.com>
Message-ID: <20090828081451.GD19658@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 28, 2009 at 03:40:21PM +0800, Wengang Wang wrote:
> Joel Becker wrote:
> > 	Sunil is right that developers will know what was printed and
> > that we don't need to be terribly detailed about that.  I'm saying that
> > I don't know that entry/exit logs are useful.  We never turn them on
> > because they are too noisy.
> 
> 
> Ok. Then I will pick up the mlog_error()s and mlog(ERR...)s and re-post 
> later...

	Yes, that would be great.  Any time you are debugging some code
and you think "I'd really like to know this value here" or something,
feel free to add an mlog and send it in.  We appreciate it.  It's just
the entry/exit stuff we're trying to get away from.
	(Of course, if you want to start the migration to the new
generic tracepoints...)

Thanks!
Joel

-- 

"The first thing we do, let's kill all the lawyers."
                                        -Henry VI, IV:ii

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
