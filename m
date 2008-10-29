From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Oct 2008 03:32:58 +0100
Subject: [Ocfs2-devel] [PATCH 23/29] ocfs2: Assign feature bits
	and	system inodes to quota feature and quota files
In-Reply-To: <20081028221606.GL17578@mail.oracle.com>
References: <122488610212-git-send-email-jack@suse.cz>
	<12248861042935-git-send-email-jack@suse.cz>
	<20081028221606.GL17578@mail.oracle.com>
Message-ID: <20081029023258.GG24732@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 28-10-08 15:16:06, Joel Becker wrote:
> On Sat, Oct 25, 2008 at 12:08:16AM +0200, Jan Kara wrote:
> > diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> > index f24ce3d..dd17137 100644
> > --- a/fs/ocfs2/ocfs2_fs.h
> > +++ b/fs/ocfs2/ocfs2_fs.h
> > @@ -93,7 +93,9 @@
> >  					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
> >  					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
> >  					 | OCFS2_FEATURE_INCOMPAT_XATTR)
> > -#define OCFS2_FEATURE_RO_COMPAT_SUPP	OCFS2_FEATURE_RO_COMPAT_UNWRITTEN
> > +#define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
> > +					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
> > +					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
> 
> 	I know you're just in the progress of working, so this isn't an
> immediate thing, but I wanted to put this down in the discussion.
> 	When we land the quota work, the feature bits have to be
> absolutely last.  It's not about whether quota works (eg, the mounting
> code later in the series).  It's about the cluster's handling of quotas.
> After this patch, a node will happily mount the filesystem while
> ignoring quotas.  Another node, one with the full series, will actually
> use and write out quotas.  This leads to inconsistency.  By having the
> very last patch add quotas to the supported features, we ensure this
> doesn't happen.
  Ah, OK. I didn't realize this. Thanks for pointing this out. I'll move
this patch to the end and merge it with the "Enable quotas on mount" patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
