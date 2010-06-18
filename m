From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Jun 2010 11:00:17 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: make xattr work with new local
	alloc reservation.
Message-ID: <4C1AE141.60707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	The old xattr codes deem that we can allocate enough contiguous 
clusters from the allocator, it works with the old local alloc 
allocator. But as Mark has added reservation code to ocfs2, now it isn't 
the good hypothesis any more. So these 2 patches try to let xattr work 
with it.

Regards,
Tao
