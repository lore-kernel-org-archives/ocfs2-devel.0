From: Jan Kara <jack@suse.cz>
Date: Sat, 22 Dec 2012 02:41:43 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Simplify ocfs2_invalidatepage()
 and ocfs2_releasepage()
In-Reply-To: <20121222013320.GA27186@localhost>
References: <1356132395-7081-1-git-send-email-jack@suse.cz>
	<20121222013320.GA27186@localhost>
Message-ID: <20121222014143.GB8629@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 21-12-12 17:33:21, Joel Becker wrote:
> On Sat, Dec 22, 2012 at 12:26:35AM +0100, Jan Kara wrote:
> > Ocfs2 doesn't do data journalling. Thus its ->invalidatepage and ->releasepage
> > functions never get called on buffers that have journal heads attached. So
> > just use standard variants of functions from buffer.c.
> 
> Indeed, we do not.  I suppose if we ever use readpage, etc for our
> dirblocks we'll have to revisit this.
  Depends on how exactly you do that but probably yes. OTOH there will be
separate a_ops for directories anyway I assume...

> Do you want me to send this along?
  Yes, please. Sign-off from a maintainer is good ;)

								Honza

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/aops.c |   18 ++----------------
> >  1 files changed, 2 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 6577432..6166cdd 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -598,25 +598,11 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
> >  	inode_dio_done(inode);
> >  }
> >  
> > -/*
> > - * ocfs2_invalidatepage() and ocfs2_releasepage() are shamelessly stolen
> > - * from ext3.  PageChecked() bits have been removed as OCFS2 does not
> > - * do journalled data.
> > - */
> > -static void ocfs2_invalidatepage(struct page *page, unsigned long offset)
> > -{
> > -	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
> > -
> > -	jbd2_journal_invalidatepage(journal, page, offset);
> > -}
> > -
> >  static int ocfs2_releasepage(struct page *page, gfp_t wait)
> >  {
> > -	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
> > -
> >  	if (!page_has_buffers(page))
> >  		return 0;
> > -	return jbd2_journal_try_to_free_buffers(journal, page, wait);
> > +	return try_to_free_buffers(page);
> >  }
> >  
> >  static ssize_t ocfs2_direct_IO(int rw,
> > @@ -2091,7 +2077,7 @@ const struct address_space_operations ocfs2_aops = {
> >  	.write_end		= ocfs2_write_end,
> >  	.bmap			= ocfs2_bmap,
> >  	.direct_IO		= ocfs2_direct_IO,
> > -	.invalidatepage		= ocfs2_invalidatepage,
> > +	.invalidatepage		= block_invalidatepage,
> >  	.releasepage		= ocfs2_releasepage,
> >  	.migratepage		= buffer_migrate_page,
> >  	.is_partially_uptodate	= block_is_partially_uptodate,
> > -- 
> > 1.7.1
> > 
> 
> -- 
> 
> "But then she looks me in the eye
>  And says, 'We're going to last forever,'
>  And man you know I can't begin to doubt it.
>  Cause it just feels so good and so free and so right,
>  I know we ain't never going to change our minds about it, Hey!
>  Here comes my girl."
> 
> 			http://www.jlbec.org/
> 			jlbec at evilplan.org
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
