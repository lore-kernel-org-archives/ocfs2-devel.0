From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 18 May 2010 14:44:26 -0700
Subject: [Ocfs2-devel] [PATCH 00/17 V2] ocfs2: Support for discontiguous
	block group.
In-Reply-To: <20100517192147.GB22775@mail.oracle.com>
References: <4BCFEF22.7080607@oracle.com>
	<20100517192147.GB22775@mail.oracle.com>
Message-ID: <20100518214425.GL20644@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 17, 2010 at 12:21:47PM -0700, Joel Becker wrote:
> On Thu, Apr 22, 2010 at 02:39:30PM +0800, Tao Ma wrote:
> > [View]
> > http://oss.oracle.com/git/?p=tma/linux-2.6.git;a=shortlog;h=discontig-bg
> > [Pull]
> > git://oss.oracle.com/git/tma/linux-2.6.git discontig-bg
> 
> Hey everyone,
> 	The merge window is open.  I want to take this and push it to
> Linus in the next few days.  I want to clarify the state.
> 
> Tao,
> 	Let me know if/when your discontig-bg branch has the code you
> want to go upstream.  It may already; I'm just confirming before I pull.
> 
> Tristan,
> 	When we spoke last week, all tests had passed.  I'm going to
> assume that is still the case unless you tell me otherwise.
> 
> Mark,
> 	Any chance you can give this a once over in the next two or so
> days?  I'm going to pull from Tao as soon as he confirms the latest code
> is there, but then I'm going to give it a couple days in linux-next.

Tristan's patches got my ack in mail. Tao's look good too (you can put my
ack on those too). Thanks,
	--Mark

--
Mark Fasheh
