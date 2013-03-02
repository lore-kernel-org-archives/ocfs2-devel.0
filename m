From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 2 Mar 2013 02:05:41 -0800
Subject: [Ocfs2-devel] OCFS2 mainline state?
In-Reply-To: <20130225211617.GF4503@ZenIV.linux.org.uk>
References: <512BCA9E.4090702@nod.at> <20130225211103.GA13510@wotan.suse.de>
	<20130225211617.GF4503@ZenIV.linux.org.uk>
Message-ID: <20130302100540.GB22177@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.de>, Richard Weinberger <richard@nod.at>, ocfs2-devel@oss.oracle.com, ocfs2-user@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, david@sigma-star.at

On Mon, Feb 25, 2013 at 09:16:18PM +0000, Al Viro wrote:
> On Mon, Feb 25, 2013 at 01:11:03PM -0800, Mark Fasheh wrote:
> 
> > I've seen that patch actually and yes it should have been in mainline
> > already. I didn't see whether it's in -mm (Andrew is pickup up some of the
> > patches for us right now).
> > 
> > I'll check and if it's not I'll try to send him a version of it today.
> 
> Normally filesystem trees are fed to Linus...  Or I can pick that patch via
> VFS tree (and send it to Linus tomorrow).  There also had been Jan's ocfs2
> patch a while ago; I picked only the VFS part of that series, ext* and
> IIRC xfs ones went to corresponding filesystem trees.  Should I just pick
> the ocfs2 stuff from now on?

Andrew's been picking it up.  I'm doing the Acked-by thing, until I have
a test environment back.  Thank you for offering, and if Andrew gets
tired of it before I'm fully operational, we'll happily take you up on
this.

Joel


-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

			http://www.jlbec.org/
			jlbec at evilplan.org
