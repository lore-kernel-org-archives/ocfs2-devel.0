From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 19 Nov 2008 16:48:41 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Fix a bug in xattr allocation
	guess.
In-Reply-To: <4923D3E5.1090209@oracle.com>
References: <4923D3E5.1090209@oracle.com>
Message-ID: <1227084522-5012-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we extend one xattr's value to a large size, in case
the old value size is smaller than the size of value root,
we still need to guess the metadata allocation.

Reported-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8195450..1504c6b 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2270,6 +2270,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 								 value_size);
 			xv = (struct ocfs2_xattr_value_root *)
 			     (base + name_offset + name_len);
+			value_size = OCFS2_XATTR_ROOT_SIZE;
 		} else
 			xv = &def_xv.xv;
 
@@ -2283,7 +2284,8 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 							     &xv->xr_list,
 							     new_clusters -
 							     old_clusters);
-			goto out;
+			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
+				goto out;
 		}
 	} else {
 		/*
-- 
1.5.5
