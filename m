From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 12 Nov 2008 16:20:51 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] ocfs2/xattr: transaction merge patch set.
	v3
Message-ID: <491A91E3.7010408@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
	In current ocfs2/xattr, the whole xattr set is divided into many steps 
are many transaction are used, this make the xattr set process isn't 
like a real transaction, so this patch try to merge all the transaction 
into one. Another benefit is that acl can use it easily now.

Modification from v2 to v3:
patch 2: set c_global_allocator to NULL after we free the cluster.

patch 4:
   1) initialize ocfs2_xattr_set_ctxt in a more efficient way.
   2) add one inline function ocfs2_dealloc_has_cluster so that we only 
flush truncate log when dealloc has clusters to free(Mark, you are free 
to change the name if it looks ugly. ;) ).

Mark,
	Since Joel and you have already reviewed this patch set, I'd like you 
to push these patches to merge_window now. So I can ask tristan to pull 
from your branch and do some test on this ASAP(actually I have already 
done some, but I'd like to hear the voice of the really testers :)). 
Another side effect is that Joel may need this for his bucket work on 
the new _set() path. And what's more, tiger's acl can base on your 
merge_window directly now.

Regards,
Tao
