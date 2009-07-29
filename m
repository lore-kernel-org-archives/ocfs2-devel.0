From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 29 Jul 2009 11:19:00 -0700
Subject: [Ocfs2-devel] [PATCH 1/8] Update ocfs2_fs.h to contain all
 necessary quota	structures and constants
In-Reply-To: <20090729094256.GA17748@duck.suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-2-git-send-email-jack@suse.cz>
	<20090728214507.GD8420@mail.oracle.com>
	<20090729094256.GA17748@duck.suse.cz>
Message-ID: <20090729181900.GA5849@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 29, 2009 at 11:42:56AM +0200, Jan Kara wrote:
> > >  #define OCFS2_GLOBAL_INFO_OFF (sizeof(struct ocfs2_disk_dqheader))
> > > +#define OCFS2_GLOBAL_TREE_BLK 1
> > 
> > 	I don't see GLOBAL_TREE_BLK in the kernel.
>   They are in the generic quota header fs/quota/quota_tree.h defining quota
> file format. For global quota files we use generic quota code which also
> defines some parts of the disk format...
 
<snip>

>   These are the same cases. I can split them into a separate header file if
> you like it better. But from the tools point of view, I felt that keeping
> all disk-format related things in one header makes sence.

	ocfs2_fs.h is a shared header, though.  It needs to have the
same contents in the tools and in the kernel (at any point where the
feature set is identical, of course).  Why can't you just put the
quota_tree.h and quotaio_v2.h headers in include/ocfs2-kernel?  This not
only signifies that they aren't ocfs2-specific structures, it allows
them to follow the kernel headers in an easier fashion.  We do the same
thing with ocfs1_fs_compat.h, which defines the ocfs header we
deliberately break in ocfs2.

Joel

-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
