From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 28 Jul 2011 02:08:02 -0700
Subject: [Ocfs2-devel] ocfs2: serialize unaligned aio
In-Reply-To: <20110622212338.GA20816@wotan.suse.de>
References: <20110622212338.GA20816@wotan.suse.de>
Message-ID: <20110728090801.GB9495@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 22, 2011 at 02:23:38PM -0700, Mark Fasheh wrote:
> Fix a corruption that can happen when we have (two or more) outstanding
> aio's to an overlapping unaligned region.  Ext4
> (e9e3bcecf44c04b9e6b505fd8e2eb9cea58fb94d) and xfs recently had to fix
> similar issues.
> 
> In our case what happens is that we can have an outstanding aio on a region
> and if a write comes in with some bytes overlapping the original aio we may
> decide to read that region into a page before continuing (typically because
> of buffered-io fallback).  Since we have no ordering guarantees with the
> aio, we can read stale or bad data into the page and then write it back out.
> 
> If the i/o is page and block aligned, then we avoid this issue as there
> won't be any need to read data from disk.
> 
> I took the same approach as Eric in the ext4 patch and introduced some
> serialization of unaligned async direct i/o.  I don't expect this to have an
> effect on the most common cases of AIO.  Unaligned aio will be slower
> though, but that's far more acceptable than data corruption.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

This patch is now in the fixes branch of ocfs2.git.

Joel


-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

			http://www.jlbec.org/
			jlbec at evilplan.org
