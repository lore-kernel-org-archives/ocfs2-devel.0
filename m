From: Bruce Schwartz <bruce.schwartz@gmail.com>
Date: Wed Jul  6 12:38:36 2005
Subject: [Ocfs2-devel] 256 node limit
In-Reply-To: <42CB1689.8040800@oracle.com>
References: <200507011649.j61GnMlY022352@oss.oracle.com>
	<20050701170449.GG26608@marowsky-bree.de>
	<42C5899E.2000209@oracle.com>
	<11fa5cce05070116517b7339b5@mail.gmail.com>
	<42CB1689.8040800@oracle.com>
Message-ID: <11fa5cce050706103855a0470f@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks. From looking at the code it appears that the maximum number of nodes 
are controlled by some #defines (OCFS2_NODE_MAP_MAX_NODES, O2NM_MAX_NODES) 
and that bumping the number up to something like 300 should be a simple 
matter. There is a note in the code that reads: "if we need more, we can do 
a kmalloc for the map" which I would guess addresses the case where you'd 
want thousands of nodes.

Is my reading correct? And would it be a bad idea to try to set up a 300+ 
node OCFS2 system?

Thanks,
Bruce

On 7/5/05, Sunil Mushran <Sunil.Mushran@oracle.com> wrote:
> 
> It's actually 255. Yes, that doc needs to be updated.
> 
> No, the algorithms did not play much role in setting this limit.
> Guess, can say the limit is part arbitrary, part practical.
> (That extra byte adds up pretty quickly.)
> 
> Bruce Schwartz wrote:
> 
> > Hi all --
> >
> > In the "what's new in OCFS2" document at
> > 
> http://oss.oracle.com/projects/ocfs2/dist/documentation/ocfs2-whats-new.txt
> > it says that the 256 node limit is a software limit and could be
> > lifted. Why is that limit there? Are there some algorithms that
> > don't scale nicely with larger number of nodes? I'm guessing that
> > there is more to it than saving a byte of RAM in a few data structures.
> >
> > Thanks,
> > Bruce
> >
> >------------------------------------------------------------------------
> >
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel@oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20050706/fa6dc4e6/attachment.html
