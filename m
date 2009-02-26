From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 26 Feb 2009 14:28:47 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2-1.4: Backport inode alloc from
	mainline.
Message-ID: <49A6369F.5030208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	this patch set are the backport of inode alloc improvement from 
mainline to ocfs2-1.4.

the patches are almost the same excpet one thing:
Joel has added JBD2 support to ocfs2, so he has added "max_blocks" to 
alloc_context and add a new function 
"ocfs2_reserve_clusters_with_limit". We don't have that in ocfs2-1.4. So 
there are some great difference in patch 2.

Regards,
Tao
