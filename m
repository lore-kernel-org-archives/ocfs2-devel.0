From: Li Dongyang <lidongyang@novell.com>
Date: Sat, 10 Apr 2010 17:48:52 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
	to buffered
In-Reply-To: <20100410093717.GA19607@mail.oracle.com>
References: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
	<20100410093717.GA19607@mail.oracle.com>
Message-ID: <201004101748.52550.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Saturday 10 April 2010 17:37:18 Joel Becker wrote:
> On Sat, Apr 10, 2010 at 01:37:58AM -0600, Dong Yang Li wrote:
> > I still get a bug with this check and without my patch:
> >
> >
> > [16179.955148] (13400,1):ocfs2_truncate_file:465 ERROR: bug expression:
> > le64_to_cpu(fe->i_size) != i_size_read(inode) [16179.955157]
> > (13400,1):ocfs2_truncate_file:465 ERROR: Inode 254789, inode i_size =
> > 811008 != di i_size = 809011, i_flags = 0x1 the call trace is the same.
> 
> 	What's the testcase?
> 
> Joel
> 
Just fire up "fsstress -d <ocfs2 mount point> -l 1000 -p 1000 -n 1000", 
fsstress is a tool from ltp package.
JJ first found it on a 3-nodes cluster with user stack, I also can reproduce 
it on a 2-nodes cluster with o2cb.

Li Dongyang
