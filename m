From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 21 Aug 2008 16:27:43 -0700
Subject: [Ocfs2-devel] [PATCH 03/10] ocfs2: Make
	ocfs2_extent_tree	get/put instead of alloc.
In-Reply-To: <20080821231100.GT4563@wotan.suse.de>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-4-git-send-email-joel.becker@oracle.com>
	<20080821221059.GQ4563@wotan.suse.de>
	<20080821230533.GJ14096@mail.oracle.com>
	<20080821231100.GT4563@wotan.suse.de>
Message-ID: <20080821232743.GL14096@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 04:11:00PM -0700, Mark Fasheh wrote:
> On Thu, Aug 21, 2008 at 04:05:33PM -0700, Joel Becker wrote:
> > > Can you add a check, down here probably, that we got an 'et_type' value
> > > passed in which is valid? If not, then we might continue with on-the-stack
> > > versions of et_root_el, etc. This won't fail as nice as the kzalloc would
> > > have before.
> > 
> > 	The final patch removes the et_type completely.  If you want, I
> > can have the intermediate patches do stricter et_type checking (I think
> > a later one BUG()s).
> 
> Yep, just caught that one. We don't have to be super strict in the early
> patches so long as it gets caught by the end of the series.

	You know, if we move eo_remove_check() back to
eo_sanity_check(), we could do those at the end of __get_extent_tree().
Add in IS_XATTR_VALUE_ROOT() etc, and it's a clean place to check.  It
probably doesn't catch disk corruption (Most of these bhs are already
pre-checked), but it will catch people passing the wrong kind of bh.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
