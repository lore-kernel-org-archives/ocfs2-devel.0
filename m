From: Jan Kara <jack@suse.cz>
Date: Tue, 4 Aug 2009 23:03:20 +0200
Subject: [Ocfs2-devel] [PATCH 4/9] Write out quota info changes
	on	ocfs2_close()
In-Reply-To: <1249363102.6600.5.camel@tristan-laptop.cn.oracle.com>
References: <1249305819-7658-1-git-send-email-jack@suse.cz>
	<1249305819-7658-5-git-send-email-jack@suse.cz>
	<1249363102.6600.5.camel@tristan-laptop.cn.oracle.com>
Message-ID: <20090804210320.GA11097@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 04-08-09 13:18:22, tristan.ye wrote:
> On Mon, 2009-08-03 at 15:23 +0200, Jan Kara wrote:
> > We don't write out change of information in quota file header on each change,
> > we rather cache it in ocfs2_filesys structure. So write out all the
> > information when ocfs2_close() is called.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  libocfs2/closefs.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/libocfs2/closefs.c b/libocfs2/closefs.c
> > index 54411da..290bfd1 100644
> > --- a/libocfs2/closefs.c
> > +++ b/libocfs2/closefs.c
> > @@ -39,6 +39,7 @@ errcode_t ocfs2_flush(ocfs2_filesys *fs)
> >  errcode_t ocfs2_close(ocfs2_filesys *fs)
> >  {
> >  	errcode_t ret;
> > +	int type;
> >  
> >  	if (fs->fs_flags & OCFS2_FLAG_DIRTY) {
> >  		ret = ocfs2_flush(fs);
> > @@ -46,6 +47,17 @@ errcode_t ocfs2_close(ocfs2_filesys *fs)
> >  			return ret;
> >  	}
> >  
> > +	for (type = 0; type < MAXQUOTAS; type++)
> > +		if (fs->qinfo[type].flags & OCFS2_QF_INFO_DIRTY) {
> > +			ret = ocfs2_write_global_quota_info(fs, type);
> 
> Sometimes, some fields of 'fs' may get freed somehow(e.g, such as
> tunefs.ocfs2 case) before we call ocfs2_close(), then your
> ocfs2_write_global_quota_info() may suffer a segfault disaster somehow
> when it refers to 'fs_io' or some other fields.
  I see, it is Joel's commit 21277dec029c5453847ebd77315a663eb317e80c for
tunefs to use one IO cache. It was not present in 1.4.2 ocfs2-tools with
which I was testing my patches.
  Joel, how is ocfs2_closefs() supposed to flush dirty data when fs_io is
cleared? Your patch seems to assume that ocfs2_filesys keeps no cached
information about the filesystem and sharing fs_io is enough for a
consistent view. That might be true, although I see some ocfs2_cached_inode
pointers in ocfs2_filesys structure, but it seems like an unlucky decision
since firstly caching some data in ocfs2_filesys seems beneficial to me and
secondly it breaks my quota code ;-). I admit I don't know the details
about the tunefs.ocfs2 internals but I don't quite get why it just does not
have one ocfs2_filesys structure and doesn't do all the IO through it. That
would seem like the most natural thing to me and you'd save some hassle
with sharing fs_io...
 
									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
