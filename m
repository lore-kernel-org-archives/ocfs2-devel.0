From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 24 Jan 2011 15:28:31 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_page_mkwrite path
In-Reply-To: <20110124231835.GJ9240@wotan.suse.de>
References: <201101131103.p0D7C5Cx002897@acsinet15.oracle.com>
	<20110124231835.GJ9240@wotan.suse.de>
Message-ID: <20110124232830.GB24732@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 24, 2011 at 03:18:35PM -0800, Mark Fasheh wrote:
> >  			if (mmap_page->mapping != mapping) {
> > +				WARN_ON(mmap_page->mapping);
> >  				unlock_page(mmap_page);
> > -				/*
> > -				 * Sanity check - the locking in
> > -				 * ocfs2_pagemkwrite() should ensure
> > -				 * that this code doesn't trigger.
> > -				 */
> > -				ret = -EINVAL;
> > -				mlog_errno(ret);
> > +				ret = 0;
> 
> We're returning zero here (success) when we haven't really met success. I
> see that in the next hunk, you test for this particular condition by looking
> at wc->w_target_page. There's no bug but this approach makes understanding
> the return code of ocfs2_grab_pages_for_write() harder.

	I told him to return 0.  I couldn't come up with a good signal.
We want the caller (__ocfs2_page_mkwrite()) to not error; this is a
valid case of retry.  The check for the locked_page is good for that.
	If we do come up with a logical !0 ret for
ocfs2_write_begin_nolock(), we have to make sure that the error paths do
all of their processing correctly but otherwise treat it as a good
state.  Obviously then __ocfs2_page_mkwrite() can trigger on that error
code (and BUG_ON(locked_page)).

Joel


-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

			http://www.jlbec.org/
			jlbec at evilplan.org
