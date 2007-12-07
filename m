From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Dec  7 00:54:22 2007
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs canonical
In-Reply-To: <91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
	<20071207051224.GA29246@tasint.org>
	<91b13c310712062321u7ffe7f9dqbe228d6995ce79e@mail.gmail.com>
Message-ID: <20071207085416.GS28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 07, 2007 at 03:21:20PM +0800, rae l wrote:
> > The bigger problem is that there are tools expecting /sys/o2cb to be
> > there.  We can't just drop it.
> Do you mean the ocfs2-tools? We could also change it. Or any other tools?
> 
> The kernel community doesn't promise a stable kernel API, so does the sysfs,
> Except If it would break many userspace tools, we should consider with
> caution or keep the binary compatibility,

It would break ocfs2-tools, majorly. mount.ocfs2, fsck.ocfs2, tunefs.ocfs2,
mkfs.ocfs2, o2cb_ctl are just the programs which I can think of off the top
of my head which look for o2cb/interface_revision. Basically anything that
needs to interact with the cluster uses that file at least once.

So sorry, but shuffling it around would make many Ocfs2 users very, very
unhappy.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
