From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Sep 2009 17:29:39 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090917203453.GA15620@mail.oracle.com>
References: <20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
	<alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
	<20090915214530.GA11060@mail.oracle.com>
	<alpine.LFD.2.01.0909152116180.4950@localhost.localdomain>
	<20090916044047.GA30453@mail.oracle.com>
	<alpine.LFD.2.01.0909170856050.4950@localhost.localdomain>
	<adabpl9ct3y.fsf@cisco.com>
	<alpine.LFD.2.01.0909171316230.4950@localhost.localdomain>
	<20090917203453.GA15620@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909171723440.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Thu, 17 Sep 2009, Joel Becker wrote:
>
> 	I have to say, adding 'undefined behavior' things isn't fun in a
> call that is already potentially confusing.  We have a bunch of flags
> and behaviors we're covering.

I don't think it's "undefined". It's just not complete.

From a user standpoint, there is no difference between such a system call 
and doing the thing as a library routine (which has to be the fallback 
anyway for something like 'cp').

> 	Note that "cleaning up after an error" and "atomic" are not the
> same.  Atomicity implies that not only do you see all or none, but that
> the contents are a point-in-time of the source file.  A non-atomic
> implementation may be affected by writes that happen during the copy
> (like any read-write-loop copy would be).

Sure. There are middle grounds that may not need the cleanup. I was more 
looking at the two extreme ends.

> > Of course, if the filesystem can do the copy entirely atomically (ie by 
> > just incrementing a refcount), then it can give atomicity guarantees, but 
> > then you'd never see the async case either.
> 
> 	Even the atomic copy might take a little time (say, to bump up
> and write out the metadata structures).  Do you want to define that as
> not being async?  I was figuring COPYFILE_ATOMIC and COPYFILE_WAIT to be
> separate flags.

I don't think that's wrong, and yeah, you could decide that you actually 
want to be able to support the "ten outstanding 'copy' commands from user 
space" model too. So yeah, separate COPYFILE_ATOMIC (only succeed if you 
can do it as an atomic op in the filesystem) and COPYFILE_WAIT (only 
return when fully done) bits sounds conceptually fine to me.

Whether it's worth it for a filesystem that effectively only needs a 
couple of writes (that can be buffered too), I dunno. But it's certainly 
not something I'd object to on an interface level.

		Linus
