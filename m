From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 28 Aug 2009 00:34:00 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <4A978098.60306@oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
	<20090828011018.GG18962@mail.oracle.com>
	<4A973D1D.70500@oracle.com>
	<20090828053911.GB19658@mail.oracle.com>
	<4A978098.60306@oracle.com>
Message-ID: <20090828073359.GC19658@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 28, 2009 at 03:00:40PM +0800, Wengang Wang wrote:
> >> and for the patch its self, I think the log contents are for developers 
> >> to check(not for customer to view), so we can know what are printed by 
> >> checking the src... so I am printing some parameters without pointing 
> >> out what they are.
> > 
> > 	Yeah, I just don't know that we care :-
> Oh, excuse for my poor English :P, what do you mean here?
> you think it's OK that we don't point out what are printed? or you think 
> we should point them out exactly in log contents?

	Sunil is right that developers will know what was printed and
that we don't need to be terribly detailed about that.  I'm saying that
I don't know that entry/exit logs are useful.  We never turn them on
because they are too noisy.

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
