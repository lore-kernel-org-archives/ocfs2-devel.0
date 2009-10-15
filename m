From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 15 Oct 2009 02:15:24 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: add trace event support for
 ocfs2
In-Reply-To: <4AD69189.601@oracle.com>
References: <200909170419.n8H4JFWY027973@rgminet13.oracle.com>
	<20091013203346.GC23257@mail.oracle.com> <4AD69189.601@oracle.com>
Message-ID: <20091015091524.GC14500@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 15, 2009 at 11:05:45AM +0800, Tao Ma wrote:
> Hi Joel/Wengang,
> 
> Joel Becker wrote:
> > On Thu, Sep 17, 2009 at 06:19:44AM +0800, Wengang Wang wrote:
> >> following patches add trace event support for ocfs2.
> > 
> > Wengang,
> > 	This looks like a nice start.  Thank you for getting this going.
> > I'm sorry I haven't gotten back until now, I've been busy.
> > 	What I'd like to do next is get a small starting set of
> > tracepoints.  You have one tracepoint in this patch as a good example,
> > but we should get a few more.  I don't want every mlog changed into a
> > tracepoint.  Some of them are old and useless :-)  Instead, I'd like to
> > find information we often want while debugging.
> > 	Tao, Tiger, and Sunil, what are parts of the code you often come
> > across when debugging?  Certain mlog() prints you always find really
> > important to see.  If you point them out, Wengang can cook up
> > tracepoints for them.
> aops.c maybe? And recovery/dlm(The most awesome part)?

	But what things?  We're not just going to replace every mlog,
and we're not going to do every function.  We really want to figure out
what information is actually useful and add tracepoints for it.  So if
you have particular functions you need data on, or particular mlog()
calls you always like to see, we'd love to hear about it.
	Wengang, dlmglue.c is definitely a place to look at.  I'd love
to see events for the inc/dec of l_ro_holders and l_ex_holders.  I'd
also love to see the mlogs for 'BAST fired' and 'UNLOCK AST fired'
converted, and a similar event for the regular AST.

Joel

-- 

"To fall in love is to create a religion that has a fallible god."
        -Jorge Luis Borges

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
