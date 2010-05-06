From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 5 May 2010 18:54:31 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Make
 ocfs2_find_cpos_for_left_leaf() public.
In-Reply-To: <4BE22060.7040405@oracle.com>
References: <1271059887-12640-1-git-send-email-tristan.ye@oracle.com>
	<20100506011135.GB9955@mail.oracle.com>
	<4BE22060.7040405@oracle.com>
Message-ID: <20100506015430.GD9955@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 06, 2010 at 09:50:24AM +0800, tristan wrote:
> Joel Becker wrote:
> > On Mon, Apr 12, 2010 at 04:11:26PM +0800, Tristan Ye wrote:
> >   
> >> The original idea to pull ocfs2_find_cpos_for_left_leaf() out of
> >> alloc.c is to benefit punching-holes optimization patch, it however,
> >> can also be referred by other funcs in the future who want to do the
> >> same job.
> >>
> >> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> >>     
> >
> > Tristan,
> > 	Don't these patches sit atop another truncate cleanup?  Can you
> > send me an entire series with everything required for cleanup and
> > optimization of truncate and hole clearing.

	If you're rebasing, do it atop merge-window, which is the
already-queued stuff for 2.6.35.

Joel

-- 

"The whole principle is wrong; it's like demanding that grown men 
 live on skim milk because the baby can't eat steak."
        - author Robert A. Heinlein on censorship

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
