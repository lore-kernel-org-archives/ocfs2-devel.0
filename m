From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 17 Jun 2011 16:16:22 -0700
Subject: [Ocfs2-devel] How can ecc be corrected?
In-Reply-To: <4DFBA79C.8060405@oracle.com>
References: <BANLkTi=SHS1W7umXmY9egUrGK0SWeOjQ7w@mail.gmail.com>
	<4DFB8694.6080303@oracle.com>
	<BANLkTi=Ar_iixpHfu+O53optr37=oj2q+Q@mail.gmail.com>
	<4DFBA79C.8060405@oracle.com>
Message-ID: <20110617231621.GA16287@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 17, 2011 at 12:14:36PM -0700, Sunil Mushran wrote:
> >> If you have ideas, do share.
> > No ideas as such. I raised this question because a customer was facing
> > this issue with the superblock and no way to fix it. Fortunately, he
> > can still use the filesystem. It is debugfs.ocfs2 which is failing. I
> > guess I will have to work on a patch to fix this.
> 
> So I remember we had a bug in tunefs that changed the superblock
> without recomputing the checksum. It has been fixed since.
> 
> How can he still use the fs?
> 
> One solution is to disable it... manually. And then re-enable it using
> the latest tunefs.

	I thought we were going to patch fsck.ocfs2 to run in an
ignore-metaecc mode?

Joel


-- 

"Hey mister if you're gonna walk on water,
 Could you drop a line my way?"

			http://www.jlbec.org/
			jlbec at evilplan.org
