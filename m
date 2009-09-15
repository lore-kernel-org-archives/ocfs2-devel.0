From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 14 Sep 2009 21:06:01 -0700
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
Message-ID: <20090915040601.GE4507@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Mon, Sep 14, 2009 at 07:01:06PM -0700, Linus Torvalds wrote:
> On Mon, 14 Sep 2009, Joel Becker wrote:
> >
> > 	In the reflink discussion before, I proposed that a separate
> > copyfile() syscall could be written that uses the same ->reflink() inode
> > operation but allows degradation in the storage handling.
> 
> .. exactly how?
> 
> If you're talking about falling back to manually just copying the data, 
> then nobody is interested in that. User space can do that better with a 
> simple read-write loop or with splice, or whatever. There's no reaason 
> what-so-ever to do that.

	I'm talking about any facility for copying that isn't just a
userspace loop.  Like your discussion of network filesystems.

> But the thing is, network filesystems may be able to do server-side 
> copies, and the point being that they can do so _without_ transferring the 
> data to the client (and back). And if we do 'copyfile' (under whatever 
> name) for one filesystem, then I think we should strive to make sure that 
> it's useful for other filesystems too.

	Hence I brought this to the filesystem summit and then fsdevel
rather than just implementing it in ocfs2.  I know NFS folks were in the
room in April, and they said the call definition was workable.  Can't
remember if CIFS folks were there, but I think so.

> [ Btw, it's quite possible that CIFS/NFS people would want more than a 
>   single entrypoint. I think they might want partial copies and status 
>   updates etc, which would likely mean that a single ->copyfile() thing 
>   isn't sufficient.
> 
>   Maybe it's not worth it, and the complexity of something like that gets 
>   to be too annoying. But I don't get the feeling that you've even _tried_ 
>   to see if this can be generalized to something that would be much more 
>   widely useful ]

	I brought it up in a forum with everyone there precisely so that
I wouldn't miss their concerns via myopia.  reflink() is a generic
application of the specific "let's snapshot inodes" idea.  It doesn't do
"atomic copy of data into duplicate storage", nor does it do "send byte
ranges".  The goal was something straightforward, not a kitchen sink.

> Now, I can see that you might want to say "fail rather than use double 
> the diskspace for data". But why not just do that as a flag? You already 
> have flags for 'copy extended attributes or not'. Why not have a flag that 
> says 'copy only if you can do it without any extra space'?

	We could.  Like I said, I really wanted something simple and
clean.  I tried hard to avoid that other flag, but I had to give up due
to (correct) concerns from the security folks.
	I'm looking at both the ease of calling the call and how we
define userspace programs to use it.  reflink(1), the program, is
essentially a synonym for 'ln -r' right now.  That's pretty nice to use
from a script.  Other ideas have been 'cp --reflink' or 'cp --clone',
but every proposal for a cp argument has felt awful and clunky.
	If I were doing a straight copyfile(), ignoring the reflink
symantics, I'd want something that could be done by cp(1) at all times
(rc = copyfile(); if ENOSYS do_normal_copy()).  I mean, if we do it
right, why not take advantage at all times.  Using reflink here violates
peoples expectations, because a reflink, with its shared data extents,
can ENOSPC when you do CoW.  Whereas a copyfile() that expects to
duplicate the storage can fit within defualt cp.

Joel

-- 

"Heav'n hath no rage like love to hatred turn'd, nor Hell a fury,
 like a woman scorn'd."
        - William Congreve

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
