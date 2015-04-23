From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 23 Apr 2015 16:19:23 -0700
Subject: [Ocfs2-devel] [PATCH next] ocfs2: Reduce object size of mlog
	uses
In-Reply-To: <20150423230418.GR17170@wotan.suse.de>
References: <1429255070.2850.84.camel@perches.com>
	<20150422154604.3cb62467b66b1e313a30132c@linux-foundation.org>
	<20150423230418.GR17170@wotan.suse.de>
Message-ID: <20150423161923.be61ea8cd9e64a9e30a23eca@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.de>
Cc: Joe Perches <joe@perches.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Thu, 23 Apr 2015 16:04:18 -0700 Mark Fasheh <mfasheh@suse.de> wrote:

> > This code needs some pretty serious rework and rethink, perhaps
> > involving a change to the emitted info.  I was hoping one of the ocfs2
> > developers would take the bait, but they're all in hiding.
> 
> If it functions the same and doesn't have a major performance change, I'm
> pretty sure it'll be fine. We sometimes ask customers to enable some of the
> debugging if they are having an issue. I would ask that it be tested
> on a live system - a local fs, no cluster or cluster config required.

Is there a simpleton's guide to testing ocfs2 on a local disk?  One
which assumes a starting point of "knows how to type".

A few paragraphs in Documentation/filesystems/ocfs2.txt would be great
- then we can point non-ocfs2 people at it when they muck with stuff.
