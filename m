From: Christoph Hellwig <hch@lst.de>
Date: Wed, 22 Oct 2014 18:29:15 +0200
Subject: [Ocfs2-devel] [PATCH 02/12] quota: Allow each filesystem to
	specify which	quota types it supports
In-Reply-To: <1413902316-17997-3-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
	<1413902316-17997-3-git-send-email-jack@suse.cz>
Message-ID: <20141022162915.GB18443@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, viro@zeniv.linux.org.uk, hch@lst.de

On Tue, Oct 21, 2014 at 04:38:26PM +0200, Jan Kara wrote:
> Currently all filesystems supporting VFS quota support user and group
> quotas. With introduction of project quotas this is going to change so
> make sure filesystem isn't called for quota type it doesn't support by
> introduction of a bitmask determining which quota types each filesystem
> supports.

Why don't you keep this bitmask in the dquot.c instead of pushing it
to the caller?  So far usage of s_dquot is mostly confined to dquot.c
(with a few leaks to the filesystems using it), so keeping it that
way seems like a good idea.
