From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2009 19:01:06 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090915005417.GD4507@mail.oracle.com>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Mon, 14 Sep 2009, Joel Becker wrote:
>
> 	In the reflink discussion before, I proposed that a separate
> copyfile() syscall could be written that uses the same ->reflink() inode
> operation but allows degradation in the storage handling.

.. exactly how?

If you're talking about falling back to manually just copying the data, 
then nobody is interested in that. User space can do that better with a 
simple read-write loop or with splice, or whatever. There's no reaason 
what-so-ever to do that.

But the thing is, network filesystems may be able to do server-side 
copies, and the point being that they can do so _without_ transferring the 
data to the client (and back). And if we do 'copyfile' (under whatever 
name) for one filesystem, then I think we should strive to make sure that 
it's useful for other filesystems too.

Just google for "NFS Server-side Copy". And SMB has had a COPY command 
from the very beginning, I think.

And as far as I can tell, neither NFS nor CIFS could use your definition 
of 'reflink()'. They aren't reflinks. Or rather, _could_ be, on the 
server, of course, but what some people want to do is to avoid moving data 
over the network. So it's not about "don't use more diskspace" for that 
kind of application.

Do we really want to introduce a new filesystem operation that is likely 
to be broken for something like that?

Now, it's possible that nobody will ever care, and that NFS server-side 
copy goes the way of a lot of other failed trials. But I really hope you 
have at least _talked_ to some CIFS/NFS people about this.

[ Btw, it's quite possible that CIFS/NFS people would want more than a 
  single entrypoint. I think they might want partial copies and status 
  updates etc, which would likely mean that a single ->copyfile() thing 
  isn't sufficient.

  Maybe it's not worth it, and the complexity of something like that gets 
  to be too annoying. But I don't get the feeling that you've even _tried_ 
  to see if this can be generalized to something that would be much more 
  widely useful ]

Now, I can see that you might want to say "fail rather than use double 
the diskspace for data". But why not just do that as a flag? You already 
have flags for 'copy extended attributes or not'. Why not have a flag that 
says 'copy only if you can do it without any extra space'?

			Linus
