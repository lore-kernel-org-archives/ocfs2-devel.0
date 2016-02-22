From: Jan Kara <jack@suse.cz>
Date: Mon, 22 Feb 2016 09:01:24 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] quota: Add support for
 ->get_nextdqblk() for VFS quota
In-Reply-To: <56C76241.9020203@sandeen.net>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<56C7518E.4020204@sandeen.net>
	<20160219183342.GH30068@quack.suse.cz>
	<56C76241.9020203@sandeen.net>
Message-ID: <20160222080124.GC7791@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com

On Fri 19-02-16 12:43:13, Eric Sandeen wrote:
> 
> 
> On 2/19/16 12:33 PM, Jan Kara wrote:
> > On Fri 19-02-16 11:31:58, Eric Sandeen wrote:
> >>
> >>
> >> On 2/4/16 8:28 AM, Jan Kara wrote:
> >>> Add infrastructure for supporting get_nextdqblk() callback for VFS
> >>> quotas. Translate the operation into a callback to appropriate
> >>> filesystem and consequently to quota format callback.
> >>>
> >>> Signed-off-by: Jan Kara <jack@suse.cz>
> >>> ---
> >>>  fs/ext4/super.c          |  1 +
> >>>  fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
> >>>  fs/reiserfs/super.c      |  1 +
> >>>  include/linux/quota.h    |  3 +++
> >>>  include/linux/quotaops.h |  3 +++
> >>>  5 files changed, 47 insertions(+)
> >>>
> >>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >>> index f1b56ff01208..51649f442bf6 100644
> >>> --- a/fs/ext4/super.c
> >>> +++ b/fs/ext4/super.c
> >>> @@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
> >>>  	.write_info	= ext4_write_info,
> >>>  	.alloc_dquot	= dquot_alloc,
> >>>  	.destroy_dquot	= dquot_destroy,
> >>> +	.get_next_id	= dquot_get_next_id,
> >>>  };
> >>
> >> Hi Jan, doesn't this also need to set:
> >>
> >>
> >> +       .get_nextdqblk  = dquot_get_next_dqblk,
> >>
> >> in ext4_qctl_sysfile_operations?
> > 
> > Indeed, thanks for catching this. Patch added (with your authorship and
> > sign-off) into my tree and this time I've properly tested Q_GETNEXTQUOTA
> > for ext4 with quota in hidden inodes indeed works (previously I've tested
> > only visible quota files).
> 
> Thanks Jan, I wasn't quite sure what it should be doing, but this seemed
> right.  ;)  Sorry for not sending a proper patch.
> 
> So, when you tested visible quota files, I assume it was just falling
> back to the non-next variants of the quotactl, right?  We should not
> be hooking up the call for the visible quota files, right?

We are hooking up the call for visible quota files since it works without
issues. It is upto userspace to decide whether it wants to read the quota
file directly or use Q_GETNEXTQUOTA call to iterate over all dquots.

> FWIW, there is a test in [x]fstests now for the [X]GETNEXT calls, it's
> generic/244

Great, thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
