From: Dave Chinner <david@fromorbit.com>
Date: Mon, 8 Feb 2016 17:15:18 +1100
Subject: [Ocfs2-devel] [PATCH 1/3] quota: Add support for
 ->get_nextdqblk() for VFS quota
In-Reply-To: <20160205010519.GJ459@dastard>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<20160205010519.GJ459@dastard>
Message-ID: <20160208061518.GB27429@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com

On Fri, Feb 05, 2016 at 12:05:19PM +1100, Dave Chinner wrote:
> On Thu, Feb 04, 2016 at 03:28:05PM +0100, Jan Kara wrote:
> > Add infrastructure for supporting get_nextdqblk() callback for VFS
> > quotas. Translate the operation into a callback to appropriate
> > filesystem and consequently to quota format callback.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I'm a little confused here. What patchset is this dependent on? i.e.
> what introduces the ->get_nextdqblk method?
> 
> The patches I currently have in my XFS working tree introduce this
> (quota: add new quotactl Q_XGETNEXTQUOTA) and everythign else is
> dependent on this. I looked a coupl eof days ago and I wasnt' able
> to find this in your tree.
> 
> I'd much prefer that one of us publish a stable branch with just the
> quotactl() infrastructure (i.e. commands and bits up to the
> ->get_nextdqblk() callback) that we can then both base the different
> subsystem implementations off, rather than one of us having to pull
> in a whole tree of changes just to get the one commit we need...

Jan, I've posted a stable branch with the quotactl() changes and
the XFS implementation here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-get-next-dquot-4.6

It's currently in the xfs for-next branch for wider testing - I've
done this because I want to get all the pending XFS code out into
for-next land early in this cycle so I can move on and concentrate
on rmap/reflink for the rest of the cycle.

If you want to do this through your tree instead of the XFS tree
then let me know when you publish a branch with quotactl changes in
it so I can rebuild the XFS for-next branch to use that.
Alternatively, i can pull the rest of the generic changes in this
patch set into the branch I already have, so it's all in one place
for ease of testing....

Cheeers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
