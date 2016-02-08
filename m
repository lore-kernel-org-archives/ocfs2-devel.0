From: Jan Kara <jack@suse.cz>
Date: Mon, 8 Feb 2016 15:34:33 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] quota: Add support for
 ->get_nextdqblk() for VFS quota
In-Reply-To: <20160208142749.GD9451@quack.suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<20160205010519.GJ459@dastard>
	<20160208142749.GD9451@quack.suse.cz>
Message-ID: <20160208143433.GA4468@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com

On Mon 08-02-16 15:27:49, Jan Kara wrote:
> On Fri 05-02-16 12:05:19, Dave Chinner wrote:
> > On Thu, Feb 04, 2016 at 03:28:05PM +0100, Jan Kara wrote:
> > > Add infrastructure for supporting get_nextdqblk() callback for VFS
> > > quotas. Translate the operation into a callback to appropriate
> > > filesystem and consequently to quota format callback.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > I'm a little confused here. What patchset is this dependent on? i.e.
> > what introduces the ->get_nextdqblk method?
> 
> It depends on the patches Eric sent which introduce ->get_nextdqblk.
> 
> > The patches I currently have in my XFS working tree introduce this
> > (quota: add new quotactl Q_XGETNEXTQUOTA) and everythign else is
> > dependent on this. I looked a coupl eof days ago and I wasnt' able
> > to find this in your tree.
> 
> Yeah, I have this patch as well, I just didn't push out.
> 
> > I'd much prefer that one of us publish a stable branch with just the
> > quotactl() infrastructure (i.e. commands and bits up to the
> > ->get_nextdqblk() callback) that we can then both base the different
> > subsystem implementations off, rather than one of us having to pull
> > in a whole tree of changes just to get the one commit we need...
> 
> Sure, I have pushed out:
> 
> 'getnextquota' branch into my tree
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git 
> 
> which contains the patches from Eric I carry (including fixups in comments
> other minor stuff I have found during final review). Can you please base
> XFS patches on top of this branch? Thanks!

Ah, now I saw your next email and you already created the stable branch.
OK, since I didn't push out anything yet, I will base my branches on top of
yours. I have made some small fixups in the comments but I can push these
as a separate patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
