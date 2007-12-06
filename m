From: rae l <crquan@gmail.com>
Date: Thu Dec  6 23:21:32 2007
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs canonical
In-Reply-To: <20071207051224.GA29246@tasint.org>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
	<20071207051224.GA29246@tasint.org>
Message-ID: <91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Dec 7, 2007 1:12 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Fri, Dec 07, 2007 at 12:22:17PM +0800, Denis Cheng wrote:
> > ocfs2 uses a subsystem under sysfs: /sys/o2cb, which is not good,
> >
> > the canonical use of sysfs is one kset under /sys/fs, like the approach
> > gfs2 does.
> >
> o2cb is, in theory, independent of the filesystem.  Thus, it doesn't
> necessarily belong under /sys/fs.
I agree it's independent, but /sys/oc2b just don't conform the uniform
of the linux kernel sysfs usage.

> The bigger problem is that there are tools expecting /sys/o2cb to be
> there.  We can't just drop it.
Do you mean the ocfs2-tools? We could also change it. Or any other tools?

The kernel community doesn't promise a stable kernel API, so does the sysfs,
Except If it would break many userspace tools, we should consider with
caution or keep the binary compatibility,

As time goes by, the wrong way shouldn't be continued, we are to make
changes sooner or later.

-- 
Denis Cheng
