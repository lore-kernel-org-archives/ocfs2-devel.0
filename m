From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec  7 01:28:19 2007
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs canonical
In-Reply-To: <91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
	<20071207051224.GA29246@tasint.org>
	<91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
Message-ID: <20071207092807.GA29158@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 07, 2007 at 03:21:20PM +0800, rae l wrote:
> On Dec 7, 2007 1:12 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> > o2cb is, in theory, independent of the filesystem.  Thus, it doesn't
> > necessarily belong under /sys/fs.
> I agree it's independent, but /sys/oc2b just don't conform the uniform
> of the linux kernel sysfs usage.

	By your measure.  By others, it does.  In fact, we asked around
before we put it there.

> > The bigger problem is that there are tools expecting /sys/o2cb to be
> > there.  We can't just drop it.
> Do you mean the ocfs2-tools? We could also change it. Or any other tools?

	I mean ocfs2-tools.  We have to deal with existing
installations, not just new tools.

> The kernel community doesn't promise a stable kernel API, so does the sysfs,
> Except If it would break many userspace tools, we should consider with
> caution or keep the binary compatibility,

	sysfs is a userspace ABI.  The kernel *does* try to keep
userspace ABI stable or backwards compatible.

Joel

-- 

"What do you take me for, an idiot?"  
        - General Charles de Gaulle, when a journalist asked him
          if he was happy.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
