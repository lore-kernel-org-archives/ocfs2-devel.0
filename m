From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 6 Jul 2010 12:06:50 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100629015822.GD24343@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<AANLkTil1R9I94pVXLE50JAMPIwpiaZuroJAg4wcwyBUb@mail.gmail.com>
	<20100629015822.GD24343@mail.oracle.com>
Message-ID: <20100706190650.GE17961@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Mon, Jun 28, 2010 at 06:58:23PM -0700, Joel Becker wrote:
> 	Oh, no, that's not it at all.  This is a disaster.  I can't see
> for the life of me why we haven't had 100,000 bug reports.  You're going

	Btw, we've figured out why we don't have 100,000 bug reports.
Most normal usage will never encounter this.  But it is still a serious
problem, and the fix is just as high a priority.

Joel

P.S.: Thanks, LWN, for making me look good on the QotW ;-)

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
