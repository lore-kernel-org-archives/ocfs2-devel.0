From: rae l <crquan@gmail.com>
Date: Tue Dec 11 17:02:55 2007
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs canonical
In-Reply-To: <20071211190633.GA27037@kroah.com>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
	<20071207051224.GA29246@tasint.org>
	<91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
	<20071211190633.GA27037@kroah.com>
Message-ID: <91b13c310712111702x76553ed1w94d044e5b5d0506f@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Dec 12, 2007 3:06 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Dec 07, 2007 at 03:21:20PM +0800, rae l wrote:
> > On Dec 7, 2007 1:12 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> > > On Fri, Dec 07, 2007 at 12:22:17PM +0800, Denis Cheng wrote:
> > > > ocfs2 uses a subsystem under sysfs: /sys/o2cb, which is not good,
> > > >
> > > > the canonical use of sysfs is one kset under /sys/fs, like the approach
> > > > gfs2 does.
> > > >
> > > o2cb is, in theory, independent of the filesystem.  Thus, it doesn't
> > > necessarily belong under /sys/fs.
> > I agree it's independent, but /sys/oc2b just don't conform the uniform
> > of the linux kernel sysfs usage.
>
> And what would that be?  :)
The sysfs entries of ocfs2 are under /sys/oc2b, but I think they
generally should be under /sys/fs/oc2b, aren't they?

But as Joel said, this change will break ocfs2-tools, so the decision
was not made.

On Dec 7, 2007 5:28 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
>         I mean ocfs2-tools.  We have to deal with existing
> installations, not just new tools.
To Joel: I mean this change will be done in new kernels, and new
ocfs2-tools, old kernel require old ocfs2-tools, that does not break
existing installations, is that OK?

-- 
Denis Cheng
