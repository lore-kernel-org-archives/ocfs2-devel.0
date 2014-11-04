From: Jan Kara <jack@suse.cz>
Date: Tue,  4 Nov 2014 12:19:41 +0100
Subject: [Ocfs2-devel] [PATCH 0/12 v4] Moving i_dquot out of struct inode
Message-ID: <1415099993-18034-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

  Hello,

  here is a new version of my patch series which moves i_dquot array from
struct inode into filesystem private part of the inode. Thus filesystems which
don't need it save 2 pointers in their inodes (would be 3 after we add project
quota support into generic quota).

The patch series also contains a change to quotactl so that each filesystem
can set quota types it supports. This is in the end unrelated change
(originally it was necessary for i_dquot moving but in the end I changed
things so that it's not anymore). I can move that into a separate series
but I was somewhat reluctant to do that since that would mean another 6
one-line patches to the same files we are changing here...

If people like the patches, I will queue this series into my tree for
the next merge window. For that I'd prefer to get acks from affected fs
maintainers (the changes are pretty trivial and I don't feel it's a must but
still I'd prefer fs maintainers to ack they are aware of the changes).

								Honza

Changes since v1:
* Inode field names are now named enum
* Quota type masks now have names like QTYPE_MASK_{USR|GRP|PRJ} instead of
  opencoding shifts.

Changes since v2:
* Use ->get_dquots callback instead of inode fields framework
* rebased on Linus' tree as of 3.18-rc1 + something.

Changes since v3:
* Moved bitmask of allowed quota types out of s_dquot into sb itself
* Removed pointless #ifdef CONFIG_QUOTA from OCFS2
