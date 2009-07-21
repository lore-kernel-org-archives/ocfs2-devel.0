From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Jul 2009 00:41:46 +0200
Subject: [Ocfs2-devel] Quota support for ocfs2-tools
In-Reply-To: <20090721223705.GH19170@mail.oracle.com>
References: <20090715161856.GF25458@duck.suse.cz>
	<20090721223705.GH19170@mail.oracle.com>
Message-ID: <20090721224146.GB19591@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-07-09 15:37:06, Joel Becker wrote:
> On Wed, Jul 15, 2009 at 06:18:56PM +0200, Jan Kara wrote:
> >   attached is a patch which implements full quota support for ocfs2 tools.
> > It's based against ocfs2-tools git's master branch. Would you please
> > consider inclusion of the patch? Thanks.
> 
> Jan,
> 	Can you split this into a series?  The first patch updates
> ocfs2_fs.h except for OCFS2_FEATURE_RO_COMPAT_SUPP.  The next patch is
> libocfs2 and ocfs2.h  Then a patch for each tool, and finally a patch
> that adds the feature to OCFS2_FEATURE_RO_COMPAT_SUPP?  This will make
> it easier to review and nice to read in the history.
  Definitely, will do. I also felt the patch is too big but wasn't sure how
to split it.

> 	Also, please copy ocfs2-tools-devel at oss.oracle.com on tools
> discussion.
  OK.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
