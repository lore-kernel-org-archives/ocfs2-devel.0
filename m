From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 14:41:42 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix check of return value
	of	ocfs2_start_trans()
In-Reply-To: <20081021202618.GC2871@mail.oracle.com>
References: <12245234424005-git-send-email-jack@suse.cz>
	<20081021202618.GC2871@mail.oracle.com>
Message-ID: <20081024214142.GC9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 21, 2008 at 01:26:18PM -0700, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:51PM +0200, Jan Kara wrote:
> > On failure, ocfs2_start_trans() returns values like ERR_PTR(-ENOMEM).
> > Thus checks for !handle are wrong. Fix them to use IS_ERR().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> 
> This should go upstream.  There are two more in xattr.c (not in the
> sources Jan had).

	This is now in my xattr-28 branch, along with Tao's version for
xattr.c

Joel

-- 

	Pitchers and catchers report.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
