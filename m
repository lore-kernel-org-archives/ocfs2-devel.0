From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 25 16:55:54 2004
Subject: [Ocfs2-devel] [BUG] strange behavior with mknod on ocfs2
In-Reply-To: <200403250405.i2P45gYf017979@penguin.co.intel.com>
References: <200403250405.i2P45gYf017979@penguin.co.intel.com>
Message-ID: <20040325225541.GQ10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 24, 2004 at 08:05:42PM -0800, Rusty Lynch wrote:
> I just created a new bug in bugzilla for some wacky bahavior around mknod.
> 
> The following is cut out of the bug report at ==>
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=52
> 
> On a 2.4 build, creating devices with mknod will result in the in-memory major
> and minor numbers not matching the on-disk major and minor numbers (untill the
> filesystem is remounted.)
hmmm, i think we're forgetting to stuff the device in inode->i_rdev. Does
this patch help? It seems to on my build.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com

Index: namei.c
===================================================================
--- namei.c	(revision 806)
+++ namei.c	(working copy)
@@ -300,6 +300,7 @@ int ocfs_mknod (struct inode *dir, struc
 		BUG();
 	oin->inode = inode;
 
+	inode->i_rdev = dev;
 	ocfs_populate_inode (inode, fe, mode, oin, true);
 	insert_inode_hash (inode);
 	ocfs_inode_hash_bind(osb, GET_INODE_VOTEOFF(inode), inode);
