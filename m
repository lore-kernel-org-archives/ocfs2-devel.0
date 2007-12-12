From: Greg KH <greg@kroah.com>
Date: Wed, 12 Dec 2007 22:30:47 -0000
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs	canonical
In-Reply-To: <91b13c310712111702x76553ed1w94d044e5b5d0506f@mail.gmail.com>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
	<20071207051224.GA29246@tasint.org>
	<91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
	<20071211190633.GA27037@kroah.com>
	<91b13c310712111702x76553ed1w94d044e5b5d0506f@mail.gmail.com>
Message-ID: <20071212222857.GF16474@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 12, 2007 at 09:02:41AM +0800, rae l wrote:
> On Dec 12, 2007 3:06 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Dec 07, 2007 at 03:21:20PM +0800, rae l wrote:
> > > On Dec 7, 2007 1:12 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> > > > On Fri, Dec 07, 2007 at 12:22:17PM +0800, Denis Cheng wrote:
> > > > > ocfs2 uses a subsystem under sysfs: /sys/o2cb, which is not good,
> > > > >
> > > > > the canonical use of sysfs is one kset under /sys/fs, like the approach
> > > > > gfs2 does.
> > > > >
> > > > o2cb is, in theory, independent of the filesystem.  Thus, it doesn't
> > > > necessarily belong under /sys/fs.
> > > I agree it's independent, but /sys/oc2b just don't conform the uniform
> > > of the linux kernel sysfs usage.
> >
> > And what would that be?  :)
> The sysfs entries of ocfs2 are under /sys/oc2b, but I think they
> generally should be under /sys/fs/oc2b, aren't they?

Yes, they should be, it looks like someone messed up putting them in the
sysfs root directory.

> But as Joel said, this change will break ocfs2-tools, so the decision
> was not made.

It should be pretty simple to change the tools to work for both places,
right?

thanks,

greg k-h
