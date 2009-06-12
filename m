From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 12 Jun 2009 23:03:02 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: Adjust rightmost path in
	ocfs2_add_branch.v2
Message-ID: <4A326E26.4080002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark/Joel,
	This is the v2 of bug fix for ocfs2_add_branch.

Modification from V1 to V2:
1. Create a patch which return EROFS instead of BUG in ocfs2_insert_at_leaf.
2. Use ocfs2_adjust_rightmost_records to change the root and extent 
blocks in the rightmost path.

Regards,
Tao
