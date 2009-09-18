From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Date: Fri, 18 Sep 2009 14:34:18 +0100
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090918014333.GD15620@mail.oracle.com>
References: <20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<20090918014333.GD15620@mail.oracle.com>
Message-ID: <4AB38C5A.4070506@draigBrady.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Sep 17, 2009 at 09:29:14AM -0700, Linus Torvalds wrote:
>> Why would anybody want to hide it at all? Why even the libc hiding?
>>
>> Nobody is going to use this except for special apps. Let them see what 
>> they can do, in all its glory. 
> 
> 	I expect everyone will use this through cp(1), so that cp(1) can
> try to get server-side copy on the network filesystms.

For reference, cp(1) has a --reflink option as of
coreutils-7.5 which currently just does:

  ioctl (dest_fd, BTRFS_IOC_CLONE, src_fd);

There is a specific option in cp to do this because
a "reflink copy" was seen to have these disadvantages:

  1. one copy of data blocks so more chances of data loss
  2. disk head seeking deferred to modification process
  3. possible fragmentation on write
  4. possible ENOSPC on write

Now 2. will go away with time, and 3 & 4 may be alleviated
by the use of fallocate(), but 1. was deemed important
enough to not enable by default.

cheers,
P?draig.
