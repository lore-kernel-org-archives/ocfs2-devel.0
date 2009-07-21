From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 00:55:32 +0200
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Remove syncjiff field from
	quota info
In-Reply-To: <20090721222454.GG19170@mail.oracle.com>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
	<1247673304-31080-7-git-send-email-jack@suse.cz>
	<20090721222454.GG19170@mail.oracle.com>
Message-ID: <20090721225532.GD19591@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-07-09 15:24:54, Joel Becker wrote:
> On Wed, Jul 15, 2009 at 05:55:04PM +0200, Jan Kara wrote:
> > syncjiff is just a converted value of syncms. Some places which
> > are updating syncms forgot to update syncjiff as well. Since the
> > conversion is just a simple division / multiplication and it does
> > not happen frequently, just remove the syncjiff field to avoid
> > forgotten conversions.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/aops.c         |    4 +++-
> >  fs/ocfs2/quota.h        |    1 -
> >  fs/ocfs2/quota_global.c |    5 ++---
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index b2c52b3..eaa268f 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -138,9 +138,11 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
> >  	mlog_entry("(0x%p, %llu, 0x%p, %d)\n", inode,
> >  		   (unsigned long long)iblock, bh_result, create);
> >  
> > -	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
> > +	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE) {
> >  		mlog(ML_NOTICE, "get_block on system inode 0x%p (%lu)\n",
> >  		     inode, inode->i_ino);
> > +		dump_stack();
> > +	}
> 
> 	What's this doing here?
  Oops, that's a remainder of my debugging (I was at one point seeing this
message and it wasn't clear to me how we got there so I've added
dump_stack() there and forgot about it). I'll remove it. Thanks for
spotting this.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
