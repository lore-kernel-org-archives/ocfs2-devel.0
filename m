From: Jan Kara <jack@suse.com>
Date: Wed, 15 Jul 2015 14:42:26 +0200
Subject: [Ocfs2-devel] [PATCH 0/6] quota: Propagate errors when creating
	quota entry
Message-ID: <1436964152-11203-1-git-send-email-jack@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.com>

  Hello,

  this patch set makes quota code report errors when quota entry creation fails (upto
now such errors were silently ignored). Filesystems can then properly handle the errors
and report them to userspace. Patch set also includes patches to all filesystems to
properly handle the errors. Review by respective fs maintainers is welcome.

If noone objects, I will queue these patches in my tree for the next merge window.

									Honza
