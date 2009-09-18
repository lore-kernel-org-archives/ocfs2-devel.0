From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 18 Sep 2009 11:37:57 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <4AB38C5A.4070506@draigBrady.com>
References: <20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<20090918014333.GD15620@mail.oracle.com>
	<4AB38C5A.4070506@draigBrady.com>
Message-ID: <20090918183757.GA8551@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Fri, Sep 18, 2009 at 02:34:18PM +0100, P?draig Brady wrote:
> Joel Becker wrote:
> > On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
> >> Why would anybody want to hide it at all? Why even the libc hiding?
> >>
> >> Nobody is going to use this except for special apps. Let them see what
> >> they can do, in all its glory.
> >
> > 	I expect everyone will use this through cp(1), so that cp(1) can
> > try to get server-side copy on the network filesystms.
> 
> For reference, cp(1) has a --reflink option as of
> coreutils-7.5 which currently just does:
> 
>   ioctl (dest_fd, BTRFS_IOC_CLONE, src_fd);

	Note that the btrfs ioctl is not a reflink(), so this probably
wants changing (OCFS2_IOC_REFLINK is the ocfs2 ioctl, sys_reflink() was
going to be the syscall).

> There is a specific option in cp to do this because
> a "reflink copy" was seen to have these disadvantages:
> 
>   1. one copy of data blocks so more chances of data loss
>   2. disk head seeking deferred to modification process
>   3. possible fragmentation on write
>   4. possible ENOSPC on write
> 
> Now 2. will go away with time, and 3 & 4 may be alleviated
> by the use of fallocate(), but 1. was deemed important
> enough to not enable by default.

	1, 2, and 3 are definitely in the category of "it would be nice
to choose the behavior".  4 is the big one, because it breaks default
cp(1) assumptions.  The good news is that the current copyfile
idea of copyfile(src, dst, 0) would satisfy 1-4 and be efficient or
return -ENOTSUPP/-ENOSYS if it couldn't be.  Then cp(1) falls back to
the read-write loop.
	cp --reflink would become copyfile(src, dst, COPYFILE_SNAPSHOT)

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
