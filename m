From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Sep 2009 09:30:54 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090915040601.GE4507@mail.oracle.com>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
	<20090915040601.GE4507@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909150923180.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Mon, 14 Sep 2009, Joel Becker wrote:
> > 
> > If you're talking about falling back to manually just copying the data, 
> > then nobody is interested in that. User space can do that better with a 
> > simple read-write loop or with splice, or whatever. There's no reaason 
> > what-so-ever to do that.
> 
> 	I'm talking about any facility for copying that isn't just a
> userspace loop.  Like your discussion of network filesystems.

HOW?

We need to have a per-filesystem interface to that. 

Having a '->copyfile()' function would be great.

But don't you see how _idiotic_ it is to then also having a '->reflink()' 
function that does _conceptually_ the exact same thing, except it does it 
by incrementing a usage count instead?

Do you see why I'm so unhappy to add a ->reflink() function? 

> 	Hence I brought this to the filesystem summit and then fsdevel
> rather than just implementing it in ocfs2.  I know NFS folks were in the
> room in April, and they said the call definition was workable.  Can't
> remember if CIFS folks were there, but I think so.

It's not workable if you define the 'reflink()' function to not use any 
disk space on the filesystem. Because SMB _will_ do a copy (and I presume 
the NFS thing will too). So it would not in general be what you call 
reflink, it will not be a "snapshot".

So if you _define_ the semantics of "reflink" to be that it's atomic and 
doesn't use any new diskspace (apart from the new inode/directory entry, 
of course), then it will be almost totally useless to other filesystems.

In fact, it's entirely possible to have filesystems that can avoid copying 
the _data_ blocks, but would need to copy the indirect blocks - maybe the 
data blocks are ref-counted, but the metadata needs to be per-file (I can 
see many reasons to do it that way, even if it's organized as a tree - 
it's how we do page table COW, for example, and it makes some things much 
simpler).

Would that be a 'reflink()' or not? I have no way of knowing, because you 
have decided on reflink on a purely ocfs2-specific implementation basis. 
But I do know that such a filesystem would be perfectly happy to have a 
'copyfile' function.

This is why I want the VFS pointers to be about _semantics_, not about 
some random implementation detail.

			Linus
