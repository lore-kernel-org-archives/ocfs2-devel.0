From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 10 May 2016 12:52:34 -0500
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2: sysfs and cleanup
Message-ID: <1462902759-27084-1-git-send-email-rgoldwyn@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This adds /sys/fs/ocfs2/<s_id> to the sys filesystem. All other
files are added in this directory. This is done by:
1. Adding kobject in the ocfs2_super structure
2. Using ocfs2_sb_attr which encompass all the show() and store() functions

This also reduce code and does away with unnecessary data structure,
but adds some in the ocfs2_super for house keeping.

Hopefully, this would be used to further add configurable parameters
for the super block.

Suggestions/Criticism welcome.

-- 
Goldwyn
