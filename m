From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 10 Jul 2008 16:22:28 -0700
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Add incompatible flag
	for	extended attribute v2
In-Reply-To: <20080710230002.GA32459@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-3-git-send-email-tiger.yang@oracle.com>
	<20080710230002.GA32459@wotan.suse.de>
Message-ID: <20080710232228.GE11809@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 10, 2008 at 04:00:03PM -0700, Mark Fasheh wrote:
> On Fri, Jun 27, 2008 at 03:27:36PM +0800, Tiger Yang wrote:
> > diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
> > index a4ebee3..51ce87e 100644
> > --- a/fs/ocfs2/ocfs2_fs.h
> > +++ b/fs/ocfs2/ocfs2_fs.h
> > @@ -91,7 +91,8 @@
> >  					 | OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC \
> >  					 | OCFS2_FEATURE_INCOMPAT_INLINE_DATA \
> >  					 | OCFS2_FEATURE_INCOMPAT_EXTENDED_SLOT_MAP \
> > -					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK)
> > +					 | OCFS2_FEATURE_INCOMPAT_USERSPACE_STACK \
> > +					 | OCFS2_FEATURE_INCOMPAT_XATTR)
> 
> Why can't we make XATTR an RO_COMPAT feature?

	I agree, it really wants RO_COMPAT.

> Hmm, I guess if an ro mount has to recover orphans, we could lose space
> devoted to external attributes...

	Actually, why does ro recover orphans?  That strikes me as
beyond the bounds of RO.  Replaying the journal is different, because it
is required for functional consistency.  A RO mount doesn't need to
allocate, so it wouldn't worry about unrecovered orphans.
	Of course, we already have versions in the wild that recover
orphans in RO mode, so perhaps the question is moot.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
