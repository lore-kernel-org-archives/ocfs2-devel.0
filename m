From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:39:30 +0800
Subject: [Ocfs2-devel] [PATCH 00/17 V2] ocfs2: Support for discontiguous
	block group.
Message-ID: <4BCFEF22.7080607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	This is the v2 of discontiguous block group support in ocfs2.
01-11, 15, 17 are't changed.

Changelog v1->v2:
patch 12 now disables the possibility of not-full block group.
patch 13 change ocfs2_group_bitmap_size's prototype.
patch 14 add a new function named ocfs2_gd_is_discontig.
patch 16 fixes a bug found by Tristan.

Joel,
	Please consider include it in merge-window.

[View]
http://oss.oracle.com/git/?p=tma/linux-2.6.git;a=shortlog;h=discontig-bg
[Pull]
git://oss.oracle.com/git/tma/linux-2.6.git discontig-bg

For the design doc, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/DiscontiguousBlockGroups



Regards,
Tao
