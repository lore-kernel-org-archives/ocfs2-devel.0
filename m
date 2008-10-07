From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Oct 2008 13:22:39 -0700
Subject: [Ocfs2-devel] [PATCH 13/39] ocfs2: Add extended attribute
	support
In-Reply-To: <20081001231209.44417bc1.akpm@linux-foundation.org>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
	<20081001231209.44417bc1.akpm@linux-foundation.org>
Message-ID: <20081007202239.GE26373@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tiger.yang@oracle.com

On Wed, Oct 01, 2008 at 11:12:09PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:54 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +		case Opt_user_xattr:
> > +			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
> > +			break;
> > +		case Opt_nouser_xattr:
> > +			mopt->mount_opt |= OCFS2_MOUNT_NOUSERXATTR;
> > +			break;
> 
> Is there a documentation update for these?

There is now  :) I'm actually usually a bit of a stickler for those too, but
obviously I missed this one.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: Documentation update for user_xattr / nouser_xattr mount options

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 6acf1b4..4340cc8 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -80,3 +80,5 @@ inode64			Indicates that Ocfs2 is allowed to create inodes at
 			any location in the filesystem, including those which
 			will result in inode numbers occupying more than 32
 			bits of significance.
+user_xattr	(*)	Enables Extended User Attributes.
+nouser_xattr		Disables Extended User Attributes.
-- 
1.5.4.1
