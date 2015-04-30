From: Joe Perches <joe@perches.com>
Date: Wed, 29 Apr 2015 22:05:46 -0700
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog
 uses
In-Reply-To: <20150428183007.GT17170@wotan.suse.de>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
	<20150423230418.GR17170@wotan.suse.de>
	<1429832121.32612.43.camel@perches.com>
	<20150428183007.GT17170@wotan.suse.de>
Message-ID: <1430370346.2575.12.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Tue, 2015-04-28 at 11:30 -0700, Mark Fasheh wrote:
> On Thu, Apr 23, 2015 at 04:35:21PM -0700, Joe Perches wrote:
> > On Thu, 2015-04-23 at 16:04 -0700, Mark Fasheh wrote:
> > > On Wed, Apr 22, 2015 at 03:46:04PM -0700, Andrew Morton wrote:
> > > > If you feel like undertaking such a rotorooting then go wild - that should
> > > > wake 'em up ;)
> > > Ok, I've taken the bait  :)
> > "Here fishy, fishy...", erm, "Here Fasheh, Fasheh..."
> > With that out of the way:
> :)

Yeah.  Sorry 'bout that.

My own name is vaguely aquatic too so I thought I
could get away with it.  Bad Joe...

> > A couple of possibilities:
> > 
> > o I wonder whether or not file/func/line matter at all.
> >   I think they don't.
> >   Removing them would reduce code size ~90K
> 
> They do to those that are debugging live Ocfs2 modules. I would like at
> least one pair kept please.

Your code, your choice.

> > o There's a small logging improvement possible in tcp.c.
> This part looks good to me though, thanks for it.

Please submit something like it whenever you deem
appropriate.

cheers, Joe
