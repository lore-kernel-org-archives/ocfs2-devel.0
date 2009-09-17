From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Sep 2009 13:55:44 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <adapr9pb8wa.fsf@cisco.com>
References: <20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<adabpl9ct3y.fsf@cisco.com>
	<alpine.LFD.2.01.0909171316230.4950@localhost.localdomain>
	<adapr9pb8wa.fsf@cisco.com>
Message-ID: <alpine.LFD.2.01.0909171351090.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roland Dreier <rdreier@cisco.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Thu, 17 Sep 2009, Roland Dreier wrote:
>  > > I guess one bit of semantics to figure out is what happens if copyfile()
>  > > does the async case but then copyfile_ctrl() returns an error halfway
>  > > through... is the state of the dest file just undefined?
> 
>  > I think that's the one that most filesystems would prefer. Maybe the file 
>  > is there, it's just that it's only half copied because the filesystem 
>  > filled up. 
> 
> Makes sense... and even having the state of having the file half-copied
> is not really well-defined since a filesystem may want to optimize
> things by copying out of order etc.

Yeah. 

The thing to remember is that where you'd use a non-atomic 'copyfile()' 
system call is as a replacement for just doing the same thing by hand in 
user space, so any users of this system call would basically have to 
handle the "oops, it failed with ENOSPC in the middle" _anyway_.

So there is no downside to saying "ok, it failed in the middle, you clean 
up the result", because the user needs to support that anyway.

The ones that use copyfile for filesystem-specific snapshots and use the 
ATOMIC bit to say so obviously don't have this issue. But they aren't 
looking for a "faster 'cp'" thing - they're looking for very specific 
semantics, and for the ATOMIC case we can provide those kinds of nice 
atomic "everything or nothing" semantics.

So the fact that some random server-side copy over CIFS/NFS may need 
cleanup by the user after failing at half-point is not actually a 
downside. It doesn't affect Joel's kind of fancy use.

			Linus
