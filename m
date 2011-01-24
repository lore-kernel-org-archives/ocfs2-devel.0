From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 24 Jan 2011 15:54:25 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_page_mkwrite path
In-Reply-To: <20110124232830.GB24732@noexit>
References: <201101131103.p0D7C5Cx002897@acsinet15.oracle.com>
	<20110124231835.GJ9240@wotan.suse.de>
	<20110124232830.GB24732@noexit>
Message-ID: <20110124235425.GK9240@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 24, 2011 at 03:28:31PM -0800, Joel Becker wrote:
> On Mon, Jan 24, 2011 at 03:18:35PM -0800, Mark Fasheh wrote:
> > >  			if (mmap_page->mapping != mapping) {
> > > +				WARN_ON(mmap_page->mapping);
> > >  				unlock_page(mmap_page);
> > > -				/*
> > > -				 * Sanity check - the locking in
> > > -				 * ocfs2_pagemkwrite() should ensure
> > > -				 * that this code doesn't trigger.
> > > -				 */
> > > -				ret = -EINVAL;
> > > -				mlog_errno(ret);
> > > +				ret = 0;
> > 
> > We're returning zero here (success) when we haven't really met success. I
> > see that in the next hunk, you test for this particular condition by looking
> > at wc->w_target_page. There's no bug but this approach makes understanding
> > the return code of ocfs2_grab_pages_for_write() harder.
> 
> 	I told him to return 0.  I couldn't come up with a good signal.
> We want the caller (__ocfs2_page_mkwrite()) to not error; this is a
> valid case of retry.  The check for the locked_page is good for that.

This is the return 0 bit in ocfs2_grab_page_for_write, which is only called
from ocfs2_write_begin_nolock(). I think we're talking about two different
paths. Specifically, I don't like seeing this:

	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
					 cluster_of_pages, mmap_page);
	if (ret) {
		mlog_errno(ret);
		goto out_quota;
	}

	/* Did the pagecache lose the page?  Retry. */                                                                                                                                                                                                       
	if (!wc->w_target_page)                                                                                                                                                                                                                              
		goto out_quota;                                                                                                                                                                                                                              

And instead I'd rather see:

        ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
                                         cluster_of_pages, mmap_page);
        if (ret) {
		if (ret == -EWHATEVER) {
			/*
			 * Here is a comment explaining why we're turning
			 * this into zero for ocfs2_page_mkwrite().
			 */
			ret = 0;
		}
		goto out_quota;
	}

Which doesn't wind up changing any API between page_mkwrite and write_begin
but results in a more readable and natural calling convention internally.
	--Mark

--
Mark Fasheh
