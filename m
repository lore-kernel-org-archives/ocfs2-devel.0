From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed, 13 Jul 2011 10:52:27 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make direntry invalid when
 deleting it
In-Reply-To: <4E1CFD39.4090800@tao.ma>
References: <201107120843.p6C8hYl5007623@acsmt357.oracle.com>
	<4E1CFD39.4090800@tao.ma>
Message-ID: <20110713025227.GA3350@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-07-13 10:04, Tao Ma wrote:
> Hi wengang,
> On 07/12/2011 04:43 PM, Wengang Wang wrote:
> > When we deleting a direntry from a directory, if it's the first in a block we
> > invalid it by setting inode to 0; otherwise, we merge the deleted one to the
> > prior and contiguous direntry. And we don't truncate directories.
> > 
> > There is a problem for the later case since inode is not set to 0.
> > This problem happens when the caller passes a file position as parameter to
> > ocfs2_dir_foreach_blk(). If the position happens to point to a stale(not
> > the first, deleted in betweens of ocfs2_dir_foreach_blk()s) direntry, we are
> > not able to recognize its staleness. So that we treat it as a live one wrongly.
> looks fine to me.
> But do you have any test cases that expose this bug or is it just
> inspired by code review?

Hi Tao,
Actually I hit the problem while making patch for orphan scan(thougth not proved
to be this one exactly). It is the result of our(Srini and me) analysis.
I am going to make some test on this today.
For readdir path, I think it's not hard to reproduce :)

thanks,
wengang.

> 
> Thnaks
> Tao
> > 
> > The fix is to set inode to 0 in both cases indicating the direntry is stale.
> > This won't introduce additional IOs.
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> >  fs/ocfs2/dir.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index 8582e3f..3302088 100644
> > --- a/fs/ocfs2/dir.c
> > +++ b/fs/ocfs2/dir.c
> > @@ -1184,8 +1184,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
> >  			if (pde)
> >  				le16_add_cpu(&pde->rec_len,
> >  						le16_to_cpu(de->rec_len));
> > -			else
> > -				de->inode = 0;
> > +			de->inode = 0;
> >  			dir->i_version++;
> >  			ocfs2_journal_dirty(handle, bh);
> >  			goto bail;
> 
