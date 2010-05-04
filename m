From: Li Dongyang <lidongyang@novell.com>
Date: Tue, 4 May 2010 10:10:26 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
	to buffered v3
In-Reply-To: <20100504014723.GB19213@mail.oracle.com>
References: <201004171749.10674.lidongyang@novell.com>
	<201005040937.49074.lidongyang@novell.com>
	<20100504014723.GB19213@mail.oracle.com>
Message-ID: <201005041010.26562.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tuesday 04 May 2010 09:47:23 Joel Becker wrote:
> On Tue, May 04, 2010 at 09:37:48AM +0800, Li Dongyang wrote:
> > On Saturday 01 May 2010 04:52:43 Joel Becker wrote:
> > > On Fri, Apr 30, 2010 at 01:47:05PM -0700, Joel Becker wrote:
> > > > 	Have you tested this version?  I got a compile error:
> > >
> > > 	I want to be clear - has this patch (v3) been run against the
> > > fsstress that caused the bug report in the first place?  Does the
> > > fsstress now pass?  Let me know so I can send it upstream.
> > >
> > > Joel
> >
> > it's a typo I made on my desktop, I first test it on my 2-node boxes, and
> > it had already running fsstress for at least 70hrs(50 hrs with the
> > OCFS2_INODE_SKIP_ORPHAN_DIR patches),
> > then I checked out the ocfs2/master branch on my desktop in case of the
> > differences between ocfs2/master and linus tree(like the block check in
> > ocfs2_direct_IO_get_blocks). and made changes, then generated the patch,
> > and a typo is made here, what a silly mistake!
> 
> 	And you are sure that the changes made by-hand on your desktop
> are the same as made on your 2-node machines?
> 
> Joel
> 
I just got a diff on my 2-node boxes, and checked it char to char, the only 
difference is the v3 patch lack the comma you pointed.

Br,
Li Dongyang
