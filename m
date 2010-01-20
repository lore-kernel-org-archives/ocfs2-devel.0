From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Jan 2010 15:16:22 -0800
Subject: [Ocfs2-devel] [RFC 0/4] Ocfs2 allocation reservations
In-Reply-To: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
References: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
Message-ID: <20100120231622.GE4333@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 15, 2009 at 02:48:39PM -0800, Mark Fasheh wrote:
> Hi, the following patches implement allocation reservations for Ocfs2. Right
> now I'd consider them to be beta quality - simple operations work but the
> code likely won't survive a kernel build. As it is implemented, the code
> only takes reservations on the local alloc bitmap. I've divorced the
> structures from any bitmap type however, so we can extend this to the chain
> allocators with only a small amount of code. Also, there's nothing in
> reservations.c which depends on a struct inode.

	It looks nice and simple.  As I read it, when you get some space
from the localalloc, you try to reserve the next space.  Simple chaining
of requests.  It's efficacy obviously depends on how much you reserve
for the next cycle.

> This version of the reservations code shows the following improvements:
> 
> Inode: 66007    % fragmented: 50.00     clusters: 32    extents: 16
> Inode: 66009    % fragmented: 68.75     clusters: 32    extents: 22
> Inode: 66008    % fragmented: 43.75     clusters: 32    extents: 14

	This is probably plenty good.  Here's hoping the knob allows us
to tune it.  We can probably run with different tunings to see where we
come out best.
	Have you seen any deleterious effects from very aggressive
reservations?

Joel

-- 

"Time is an illusion, lunchtime doubly so."
        -Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
