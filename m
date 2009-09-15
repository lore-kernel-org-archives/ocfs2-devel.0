From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Sep 2009 17:31:27 -0700 (PDT)
Subject: [Ocfs2-devel] [GIT PULL] ocfs2 changes for 2.6.32
In-Reply-To: <20090915000417.GC4507@mail.oracle.com>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
Message-ID: <alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com



On Mon, 14 Sep 2009, Joel Becker wrote:
> 
> 	It's creating a new entry in the name space based on an old one.

That's just a cumbersome way of saying "copyfile".

Here's a challenge for you: go outside, take the first five people you 
meet at random, and ask them what a 'copyfile()' system call would do.

Then, do the same thing with 'reflink()'.

Feel free to stack the deck, so that the people you ask about 'reflink()' 
actually know computers.

Then report back which group guessed better what the system call does.

> 	reflink doesn't merely guarantee atomicity, it guarantees the
> shared data extents.

Why?

That just limits its usefulness. What's the reason for that sophistry, 
except to try to argue for a name that makes no sense?

> 	Well, obviously I started from the fact that we don't have
> flink().  But it doesn't really fit anyway.  reflink is a namespace
> operation - give me a new item in the namespace that shares the data
> extents of the old item.

That's not a namespace op, EXCEPT FOR THE NEW NAME.

The data you share from has no namespace component to it, except as a 
lookup. But a 'fd' is equally descriptive of the shared data.

		Linus
