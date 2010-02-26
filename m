From: jeff.liu <jeff.liu@oracle.com>
Date: Fri, 26 Feb 2010 23:17:20 +0800
Subject: [Ocfs2-devel] du_enhancement: add the shared extents and footprint
 statitics support v2
Message-ID: <4B87E600.9070400@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,

Changes from v1:

1. Add more comments for split_extent() and fix a few bugs in this function based on Tao's comments.
2. Call openat(2) instead of open(2) first to get the file handler in process_extent(), call open(2)
against the full path name will fail when its length is longer than PATH_MAX. for unreadable file we
have to call open(2) instead.

I have done some simple tests, it works well. Any comments or tests help are appreciated!


Regards,
-Jeff
