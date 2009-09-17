From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Sep 2009 13:17:55 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <adabpl9ct3y.fsf@cisco.com>
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
Message-ID: <alpine.LFD.2.01.0909171316230.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roland Dreier <rdreier@cisco.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com



On Thu, 17 Sep 2009, Roland Dreier wrote:
> 
> I guess one bit of semantics to figure out is what happens if copyfile()
> does the async case but then copyfile_ctrl() returns an error halfway
> through... is the state of the dest file just undefined?

I think that's the one that most filesystems would prefer. Maybe the file 
is there, it's just that it's only half copied because the filesystem 
filled up. 

Making filesystems give atomicity guarantees would be hard for the async 
case. 

Of course, if the filesystem can do the copy entirely atomically (ie by 
just incrementing a refcount), then it can give atomicity guarantees, but 
then you'd never see the async case either.

		Linus
