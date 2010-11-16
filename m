From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 16 Nov 2010 18:13:39 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] Ocfs2: Adding new codes
	'OCFS2_INFO_FREEINODE' and 'OCFS2_INFO_FREEFRAG' for o2info
	ioctl V2.
Message-ID: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This set of patch series includes three patches:

1. Using marco to simplize duplicated codes.

2. Adding new code 'OCFS2_INODE_FREEINODE'

3. Adding new code 'OCFS2_INFO_FREEFRAG'

Changes since v1:

1. Incorporate Joel's comments to take cluster coherency into account when
   lookuping the inode/inode_blkno.

2. Using helpers somewhere to improve the readability of codes.



Tristan.
