From: Arjan van de Ven <arjan@infradead.org>
Date: Tue, 15 Sep 2009 06:05:59 +0200
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
Message-ID: <20090915060559.5b0a2574@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Mon, 14 Sep 2009 19:01:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 14 Sep 2009, Joel Becker wrote:
> >
> > 	In the reflink discussion before, I proposed that a separate
> > copyfile() syscall could be written that uses the same ->reflink()
> > inode operation but allows degradation in the storage handling.
> 
> .. exactly how?
> 
> If you're talking about falling back to manually just copying the
> data, then nobody is interested in that. User space can do that
> better with a simple read-write loop or with splice, or whatever.
> There's no reaason what-so-ever to do that.
> 
> But the thing is, network filesystems may be able to do server-side 
> copies, and the point being that they can do so _without_
> transferring the data to the client (and back). And if we do
> 'copyfile' (under whatever name) for one filesystem, then I think we
> should strive to make sure that it's useful for other filesystems too.

COW filesystems like btrfs may also be able to do interesting things
with copyfile() btw by just sharing all data blocks COW.

That would make copyfile() useful for me, much more so than the network
filesystem side...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
