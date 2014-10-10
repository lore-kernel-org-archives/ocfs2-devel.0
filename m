From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Oct 2014 16:23:05 +0200
Subject: [Ocfs2-devel] [PATCH 0/2 v2] Fix data corruption when blocksize <
	pagesize for mmapped data
Message-ID: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>

  Hello,

  this is a second version of the patches to fix data corruption in mmapped
data when blocksize < pagesize as tested by xfstests generic/030 test.
The patchset fixes XFS and ext4. I've checked and btrfs doesn't need fixing
because it doesn't support blocksize < pagesize. If that's ever going
to change btrfs will likely need a similar treatment. ocfs2, ext2, ext3 are
OK since they happily allocate blocks during writeback. For other filesystems
like gfs2, ubifs, nilfs, ceph,... I'm not sure whether they support blocksize <
pagesize@all. Interesting is also NFS which may care but I don't understand
its ->page_mkwrite() handler good enough to judge.

Changes since v1:
- changed helper function name and moved it to mm/truncate.c - I originally
  thought we can make the helper function update i_size to simplify the
  interface but it's actually impossible due to generic_write_end() lock
  ordering constraints.
- used round_up() instead of ALIGN()
- taught truncate_setsize() to use the helper function

								Honza
