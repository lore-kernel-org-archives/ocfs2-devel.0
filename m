From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 May 2009 00:12:39 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <cfd18e0f0905032336v4e43cf77l4c4d02555ba9fe7a@mail.gmail.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090503080112.GA27287@infradead.org>
	<20090504024612.GB24653@mail.oracle.com>
	<cfd18e0f0905032336v4e43cf77l4c4d02555ba9fe7a@mail.gmail.com>
Message-ID: <20090504071239.GI24653@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mtk.manpages@gmail.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, May 04, 2009 at 06:36:58PM +1200, Michael Kerrisk wrote:
> On Mon, May 4, 2009 at 2:46 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> > On Sun, May 03, 2009 at 04:01:12AM -0400, Christoph Hellwig wrote:
> >> On Sat, May 02, 2009 at 11:15:01PM -0700, Joel Becker wrote:
> >> > int reflink(const char *oldpath, const char *newpath);
> >> >
> >> > The reflink(2) system call creates reference-counted links. ?It creates
> >> > a new file that shares the data extents of the source file in a
> >> > copy-on-write fashion. ?Its calling semantics are identical to link(2).
> >> > Once complete, programs see the new file as a completely separate entry.
> >>
> >> Just send this as a manpage to Michael, no need to duplicate a
> >> pseudo-manpage in the kernel tree.
> >
> > ? ? ? ?The manpage style was just a convenient way to organize my
> > thoughts. ?The goal was to document the behavior of reflink() for
> > implementors. ?If the pseudo-manpage doesn't work, perhaps I'll try some
> > other form.
> 
> So, I'm late to this thread.  Is reflink() (to be) a user-visible syscall?

	Yes.  The actual call will be reflinkat(), as they're correct
that userspace can wrap reflink() around it.  I did have you on my todo
for notification as it settled down.

Joel

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
