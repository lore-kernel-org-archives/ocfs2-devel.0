From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 29 Jun 2010 00:18:18 -0700
Subject: [Ocfs2-devel] [PATCH] Revert "writeback: limit
 write_cache_pages integrity scanning to current EOF"
In-Reply-To: <20100629022757.GA6590@dastard>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<20100629015615.GZ6590@dastard>
	<20100629020420.GE24343@mail.oracle.com>
	<20100629022757.GA6590@dastard>
Message-ID: <20100629071817.GA4150@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>

On Tue, Jun 29, 2010 at 12:27:57PM +1000, Dave Chinner wrote:
> Just to clarify any possible misunderstanding here, xfs_zero_eof()
> also does it's IO through the page cache for similar reasons.  It's
> just the mappings are found via the internal interfaces before the
> zeroing is done via the anonymous pagecache_write_begin()/
> pagecache_write_end() functions (in xfs_iozero()) rather than using
> the generic block functions.

	Mark and I discussed this some earlier this evening.  I think we
might be able to get away cheaper than does.  In
ocfs2_write_begin_nolock(), we call ocfs2_expand_nonsparse_inode() in
the case of older filesystems that don't allow sparse files.  That's
where we handle the zeroing from old_i_size to pos for those files.
	I the exact same place, we could probably just detect we're
about to cover the unzeroed allocation and get it there.  This needs
some more code eval until we're sure, and then the serious testing
happens.

Joel

-- 

"Nothing is wrong with California that a rise in the ocean level
 wouldn't cure."
        - Ross MacDonald

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
