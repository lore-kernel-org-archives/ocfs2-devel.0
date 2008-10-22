From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2008 14:02:40 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Assign feature bits and
	system	inodes to quota feature and quota files
In-Reply-To: <20081021204318.GG2871@mail.oracle.com>
References: <1224523443220-git-send-email-jack@suse.cz>
	<20081021204318.GG2871@mail.oracle.com>
Message-ID: <20081022120240.GG13868@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 13:43:18, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:55PM +0200, Jan Kara wrote:
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This patch actually looks fine except for one thing:
> 
> > diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> > index 4f61985..bb41c6a 100644
> > --- a/fs/ocfs2/ocfs2_fs.h
> > +++ b/fs/ocfs2/ocfs2_fs.h
> > @@ -91,7 +91,9 @@
> >  					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
> >  					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
> >  					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK)
> > -#define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
> > +#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
> > +					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
> > +					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
> 
> 	The hunk turning on support should be the very last patch in the
> series.  It doesn't matter right now as you are working on it, but when
> we go to upstream we'll want all the support in place before we turn it
> on.
  Yes, I understand. But the only thing this patch will actually *do* is
that quota system files will be loaded and S_NOQUOTA bit set on system
files. No quota support is enabled by this patch. That happens in patch
ocfs2-Enable-quota-accounting-on-mount-disable-on when everything necessary
is in place (I even tested that the kernel compiles with only part of the
patch sequence applied :). Arguably that patch should go even after the
syncing thread patch and recovery patch which I now locally have, that is
right and I'll probably do that.

> 	The rest of the patch - defining the bits and the system files,
> etc, is just fine.
  Thanks for review.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
