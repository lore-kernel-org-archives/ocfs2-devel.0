From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 16 Jul 2008 10:39:42 -0700
Subject: [Ocfs2-devel] [PATCH 15/15] ocfs2: Add incompatible flag
	for	extended attribute v2
In-Reply-To: <487D65C1.2090803@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-3-git-send-email-tiger.yang@oracle.com>
	<20080710230002.GA32459@wotan.suse.de>
	<20080710232228.GE11809@mail.oracle.com>
	<487D65C1.2090803@oracle.com>
Message-ID: <20080716173942.GB18105@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 16, 2008 at 11:06:41AM +0800, Tiger Yang wrote:
> Why we want RO_COMPAT feature with xattr support?
> If we make it RO_COMPAT, this means we could only support set xattr in a 
> read only ocfs2. But sys_setxattr() need mount writable, so we couldn't 
> set xattr at all.

	RO_COMPAT doesn't mean "only used when read-only".  RO_COMPAT
means that a filesystem that doesn't understand the feature can still
mount it safely in read-only mode.
	The compat flags have simple rules:

1) If a filesystem module understands all the flags (COMPAT, INCOMPAT,
   RO_COMPAT), it MAY safely mount read-write.
2) If a filesystem module does not understand an INCOMPAT flag, it MUST
   NOT mount the filesystem at all.  It's code will error or crash
   because of the new INCOMPAT feature.  An example is sparse files - a
   filesystem module that doesn't understand sparse files will see a
   hole and crash.
3) If a filesystem does not understand an RO_COMPAT flag, it MUST NOT
   mount read-write, but it MAY mount read-only.  It's code will safely
   ignore the new feature in a read-only mode, but cannot safely write
   to the filesystem.  The only example in ocfs2 is unwritten extents.
   A read-only filesystem can handle them, but to write them it has to
   know the feature (to clear the flag).
4) If a filesystem does not understand a COMPAT flag, it MAY still mount
   read-write.  It's code will not trip over the feature it does not
   understand.  The example is backup superblocks.  A filesystem that
   does not understand backup superblocks will just ignore them -
   they're marked as used in the global bitmap.

	A filesystem that doesn't understand xattrs (eg, 1.2) will see
the xattr fields as padding.  It uses all the other fields to navigate
the inode (i_list or i_data).  So it won't accidentally trip over the
xattr stuff.  Thus, it would be safe to access the inode read-only.  It
cannot access the inode read-write, as operations like unlink(2) will
leak the xattr blocks.  Thus, it would be an RO_COMPAT feature.
	However, as Mark pointed out, older filesystems clean up orphans
in read-only mode.  That would leak xattrs - so xattrs cannot be
RO_COMPAT, because it isn't safe for older modules to mount read-only..

Joel

-- 

"The opposite of a correct statement is a false statement. The
 opposite of a profound truth may well be another profound truth."
         - Niels Bohr 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
