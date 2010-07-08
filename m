From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 8 Jul 2010 02:51:56 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: When zero extending,
	do it by page.
In-Reply-To: <4C3549BB.2000906@oracle.com>
References: <20100703213219.GB21262@mail.oracle.com>
	<1278501367-7710-2-git-send-email-joel.becker@oracle.com>
	<4C3549BB.2000906@oracle.com>
Message-ID: <20100708095156.GB23392@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Thu, Jul 08, 2010 at 11:44:59AM +0800, Tao Ma wrote:
> On 07/07/2010 07:16 PM, Joel Becker wrote:
> >+	BUG_ON(abs_to>  ((index + 1)<<  PAGE_CACHE_SHIFT));
> Sorry for not noticing this yesterday night. This can't work and
> will overflow and bug out. I met with a similar bug in reflink test.
> See commit d622b89.

	Good catch.  It's obvious, now that you mention it.

> >+	/* We know that zero_from is block aligned */
> >+	for (block_start = zero_from;
> >+	     (block_start<  PAGE_CACHE_SIZE)&&  (block_start<  zero_to);
> >+	     block_start = block_end) {
> Do we really need to check block_start < PAGE_CACHE_SIZE? I think
> just check block_start < zero_to is enough since you have limit
> zero_to with PAGE_CACHE_SIZE. What's more, it looks more natural(see
> below), does it?
> 
> 	for (block_start = zero_form; block_start < zero_to; block_start =
> block_end) {

	Yup.  The code looked different halfway through, so I didn't
realize I was checking the same thing twice.

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
