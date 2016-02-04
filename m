From: Jan Kara <jack@suse.cz>
Date: Thu,  4 Feb 2016 15:28:04 +0100
Subject: [Ocfs2-devel] [PATCH 0/3 v2] Q_GETNEXTQUOTA support
Message-ID: <1454596087-6814-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>

Hello,

the patch set below adds support for VFS quotas for Q_GETNEXTQUOTA quotactl
and thus repquota(8) doesn't have to iterate over /etc/passwd or LDAP database
to report all quota limits. ext2, ext4, reiserfs, jfs, and ocfs2 support this
quotactl (and Q_XGETNEXTQUOTA as well) after applying this patch set. XFS
bits will likely get merged independently through XFS tree. If nobody objects,
I'll push these patches to my tree in a few days.

Changes since v2:
* Added get_next_id() operation to dquot_operations to allow for cleaner
  support in OCFS2
* Added OCFS2 support

								Honza
