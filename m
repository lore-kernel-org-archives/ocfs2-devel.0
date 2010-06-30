From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 29 Jun 2010 18:30:53 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100629081611.GB4150@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
	<20100629015822.GD24343@mail.oracle.com>
	<AANLkTil5y7F9w-18mVi0G1S5pSv9MiKq6XL5MWAMFBQM@mail.gmail.com>
	<20100629081611.GB4150@mail.oracle.com>
Message-ID: <20100630013053.GK4150@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Tue, Jun 29, 2010 at 01:16:11AM -0700, Joel Becker wrote:
> On Mon, Jun 28, 2010 at 07:20:33PM -0700, Linus Torvalds wrote:
> > Your call, I guess.  If any ocfs2 fix looks scary, and you'd prefer to
> > have an -rc4 (in a few days - not today) with just the revert, I'm ok
> > with that. Even if it's only a "at least no worse than 2.6.34"
> > situation rather than a real fix.
> 
> 	If -rc4 isn't coming for a couple of days, can we hold off on
> the decision until we get a chance to think about a paper-over solution
> for it?  Then we can avoid the revert.

Linus,
	I'm going to withdraw the revert request for now.  Our proposed
paper-over solution is too big, and we're just going to focus on the
actual fix.  This will be for .35.  Yes, .35-rc will have a BUG_ON with
refcount trees until we get the fix in, but I'd rather avoid the churn
when the final .35 should have Dave's patch and our fix.

Joel

-- 

"The first thing we do, let's kill all the lawyers."
                                        -Henry VI, IV:ii

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
