From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 21 Aug 2008 16:52:42 -0700
Subject: [Ocfs2-devel] [PATCH 09/10] ocfs2: Add an insertion check to
	ocfs2_extent_tree_operations.
In-Reply-To: <20080821232540.GK14096@mail.oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-10-git-send-email-joel.becker@oracle.com>
	<20080821225238.GS4563@wotan.suse.de>
	<20080821232540.GK14096@mail.oracle.com>
Message-ID: <20080821235242.GV4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 04:25:40PM -0700, Joel Becker wrote:
> > Is there a reason why you changed the way we initialize "rec" for this
> > patch? I guess the end result is the same - specifically, I want to be 100%
> > certain that rec.e_reserved1 gets zero'd. Still though, I think the flow we
> > had before was better.
> 
> 	Well, the naked memset() is ugly (IMHO) when the initializer
> works (an initializer ensures that all non-initialized fields are zero).
> However, it didn't work quite like I expected, since gcc couldn't handle
> the anonymous union in the initializer.  I'll revert it back to the old
> way.

Thanks. Too bad about gcc though :(
	--Mark

--
Mark Fasheh
