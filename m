From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Dec  5 14:20:32 2006
Subject: [Ocfs2-devel] Re: Relative atime (was Re: What's in ocfs2.git)
In-Reply-To: <20061205003619.GC8482@goober>
References: <20061203203149.GC19617@ca-server1.us.oracle.com>
	<1165229693.3752.629.camel@quoit.chygwyn.com>
	<20061205001007.GF19617@ca-server1.us.oracle.com>
	<20061205003619.GC8482@goober>
Message-ID: <20061205222027.GA4497@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Steven Whitehouse <steve@chygwyn.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>

On Mon, Dec 04, 2006 at 04:36:20PM -0800, Valerie Henson wrote:
> > Last time I looked at them, things seemed to be in pretty good shape - it
> > wasn't a very large patch series.
> 
> Yep, the relative atime patch is tiny and pretty much done - just
> needs some soak time in -mm and a little more review (cc'd Viro and
> fsdevel).  Kernel patch against 2.6.18-rc4 appended, patch to mount
> following. (Note that my web server suffered a RAID failure and my
> patches page is unavailable till the restore finishes.)

Well, here's what the ocfs2 patch would look like. If we care to push this
forward, some time in -mm would be nice...
	--Mark

From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 5 Dec 2006 14:13:41 -0800
Subject: [PATCH] ocfs2: relative atime support

Update ocfs2_should_update_atime() to understand the MNT_RELATIME flag and
to test against mtime / ctime accordingly.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/file.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8786b3c..16a9b5e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -154,6 +154,15 @@ int ocfs2_should_update_atime(struct ino
 		return 0;
 
 	now = CURRENT_TIME;
+
+	if (vfsmnt->mnt_flags & MNT_RELATIME) {
+		if ((timespec_compare(&inode->i_atime, &inode->i_mtime) < 0) ||
+		    (timespec_compare(&inode->i_atime, &inode->i_ctime) < 0))
+			return 1;
+
+		return 0;
+	}
+
 	if ((now.tv_sec - inode->i_atime.tv_sec <= osb->s_atime_quantum))
 		return 0;
 	else
-- 
1.4.2.4
