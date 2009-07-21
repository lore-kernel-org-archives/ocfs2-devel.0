From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 00:52:39 +0200
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2: Initialize blocks allocated to
	local quota	file
In-Reply-To: <20090721222037.GF19170@mail.oracle.com>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
	<1247673304-31080-4-git-send-email-jack@suse.cz>
	<20090721222037.GF19170@mail.oracle.com>
Message-ID: <20090721225239.GC19591@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-07-09 15:20:37, Joel Becker wrote:
> On Wed, Jul 15, 2009 at 05:55:01PM +0200, Jan Kara wrote:
> > +	handle = ocfs2_start_trans(OCFS2_SB(sb), 3);
> > +	if (IS_ERR(handle)) {
> > +		status = PTR_ERR(handle);
> > +		mlog_errno(status);
> > +		goto out;
> > +	}
> 
> 	Can we define the quota credit counts in fs/ocfs2/journal.h like
> all of our other transaction constants?  I just realized how many raw
> numbers there are in the quota c files.  Please define the _CREDITS
> values appropriately and put them in journal.h with descriptions.  You
> can do this as a separate patch at the end of the series.
  OK, I'll clean up what I find :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
