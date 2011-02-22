From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 00:36:49 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
	<20110220070953.GC17784@noexit>
	<AANLkTinuhh9nF=6NQbe81NbE0K95huVtdDdC9Gb2pU=5@mail.gmail.com>
	<20110221020856.GL17784@noexit>
	<AANLkTimXr0rA5FV_ep-y9uetUVcD3w+9MuTZeBnLXDvG@mail.gmail.com>
Message-ID: <20110222083648.GC30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Feb 20, 2011 at 11:44:05PM -0600, Goldwyn Rodrigues wrote:
> >> > ? ? ? ?Secondly, ocfs2_should_read_blk() already checks for blocks past
> >> > i_size and skips reading them. ?So if you are trying to avoid reading
> >> > them, it is already handled.
> >>
 
> Sorry, I was wrong in my previous explanation on why
> ocfs2_should_read_blk returns 1. ocfs2_should_read_blk returns 1
> because of ocfs2_sparse_alloc() and hence forces the garbage read.

	You're right, that's why ocfs2_should_read_block() returns 1.
But why would it ever want to read blocks that are outside i_size?
We've guaranteed that they won't be initialized...
	I wonder if that's the bug?  We originally used to zero to EOC.
For sparse files, that could never be any clusters past i_size.  With
the fix I put in for writepage, we no longer zero the blocks past
i_size.  I think the sparse check there is no longer accurate.
	Please try the attached patch and see if it fixes the problem.
It should work on its own, without your changes.  If I have it wrong,
we'll continue to evaluate the problem.  I'd test it myself, but my VM
setup is currently broken.

> On a different note, what I have not been able to explain as yet is,
> when the file is created on a nosparse filesystem, the holes have junk
> (not 0xbaadfeed, ie what was written previously but junk). Could you
> think of a reason why? In any case, this patch resolves this issue.

	Do they have junk without your patch, or just with your patch?

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

			http://www.jlbec.org/
			jlbec at evilplan.org
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Don-t-read-blocks-past-i_size-they-re-not-init.patch
Type: text/x-diff
Size: 1609 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20110222/be785faf/attachment.bin 
