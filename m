From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 15:37:06 -0700
Subject: [Ocfs2-devel] Quota support for ocfs2-tools
In-Reply-To: <20090715161856.GF25458@duck.suse.cz>
References: <20090715161856.GF25458@duck.suse.cz>
Message-ID: <20090721223705.GH19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 15, 2009 at 06:18:56PM +0200, Jan Kara wrote:
>   attached is a patch which implements full quota support for ocfs2 tools.
> It's based against ocfs2-tools git's master branch. Would you please
> consider inclusion of the patch? Thanks.

Jan,
	Can you split this into a series?  The first patch updates
ocfs2_fs.h except for OCFS2_FEATURE_RO_COMPAT_SUPP.  The next patch is
libocfs2 and ocfs2.h  Then a patch for each tool, and finally a patch
that adds the feature to OCFS2_FEATURE_RO_COMPAT_SUPP?  This will make
it easier to review and nice to read in the history.
	Also, please copy ocfs2-tools-devel at oss.oracle.com on tools
discussion.

Joel


-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
