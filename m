From: Jan Kara <jack@suse.cz>
Date: Thu, 15 Oct 2009 14:54:02 +0200
Subject: [Ocfs2-devel] [PATCH 0/3] POSIX ACL config and mount option changes
Message-ID: <1255611245-27340-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  we've discussed with Joel and Mark how to improve user experience
with ACL mount options. In the end we'va agreed on the following:

 1) Rip out CONFIG_OCFS2_POSIX_ACL.  The code is always built in.
 2) Always enable acls if a filesystem has xattrs.  This is a noop if no
    one ever calls setacl.
 3) If a user explicitly puts -oacl on the mount command line, but the
    filesystem doesn't have xattrs, fail the mount.  This is a safe place
    to catch people changing kernels, as a too-old kernel driver likely
    doesn't have xattrs anyway.
 4) If a user explicitly puts -onoacl on the mount command line, they get

  This patch series implements the changes. The last patch also fixes
a bug when acls are enabled only on remount.

								Honza
