From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Sun Mar 14 16:34:53 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
In-Reply-To: <20040313000913.GB20057@ca-server1.us.oracle.com>
References: <200403110449.i2B4ncDw032388@penguin.co.intel.com>
	<20040311215300.GA7623@penguin.co.intel.com>
	<20040312204747.GA20057@ca-server1.us.oracle.com>
	<20040312210701.GA12754@penguin.co.intel.com>
	<20040313000913.GB20057@ca-server1.us.oracle.com>
Message-ID: <20040314223440.GA1408@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 12, 2004 at 04:09:13PM -0800, Mark Fasheh wrote:
> On Fri, Mar 12, 2004 at 01:07:01PM -0800, Rusty Lynch wrote:
> > This is what I wanted to do, but I was attempting to leave no trail on the
> > 2.4 code.  I am also running my changes on a 2.4 kernel, but not doing much 
> > testing other then mounting a volume, unpackaging a bunch stuff, moving it
> > around, ... and what ever else strikes me as significant.
> That should work for a basic test, I'll put it through the rest of it's
> paces :)
>  
> > I'll make another pass that makes the 2.4 and 2.6 code store the inode private
> > data in the way suggested in 2.6.
> Is it even possible to handle this in the way suggested in 2.6? It's a
> slightly different mechanism for 2.4, right? For 2.4, what I was thinking
> was along the lines of:
> 
> <near the top of ocfs_populate_inode, prolly after the fe sanity check>
> 
> if (!inode->u.generic_ip)
> 	inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, 
> 					       GFP_NOFS);
> 
> Of course, with proper error checking and whatnot.
> Then in ocfs_clear_inode, we could just do:
> 
> ocfs_destroy_inode(inode);
> inode->u.generic_ip = NULL;
> 
> Again, cleaned up and bugchecked and whatnot.
> What do you think?
> 
> > As to the use of upper case for MACROS... I agree.  I was just trying to sneak
> > in some macro genocide without having to touch all the code that calls the
> > macros.
> Well, it's a good cause :)
> 
> > So just curious, when do you feel a macro is better then an inline function?
> Umm, I have no strong opinions really. I think mostly my rule is if it's
> only a line or two that doesn't necessarily require any typechecking, then a
> macro is fine. Otherwise, an inline's the better choice.
>  
> > Either way I'll generate a patch that just does the minimal about to move the
> > inode private data, and seperate the macro question to another patch (or series
> > of patches.)

Here is a patch that stores the inode private data as you talked about above.
There is a little more complexity because you have to handle the cases where:
* new inodes are created via ocfs_mknod and ocfs_symlink, and we need to
  start setting private data before ocfs_populate_inode
* reading the root inode in ocfs_read_inode2 (2.4 kernel) or
  ocfs_read_locked_inode (2.6 kernel) where we just directly populate the
  inode and do not call ocfs_populate_inode()

There is really no difference between a 2.4 and 2.6 build (other then where
to put the code for reading the root inode.)

    --rusty


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 776)
+++ src/inode.c	(working copy)
@@ -251,6 +251,15 @@
 		BUG();
 	}
 
+	if (!inode->u.generic_ip)
+		inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache,
+						       GFP_NOFS);
+	if (!inode->u.generic_ip) {
+		/* How can we recover gracefully? */
+		LOG_ERROR_STR("unable to allocate private data for inode");
+		goto bail;
+	}
+	
 	OCFS_SET_INODE_DEV(sb, inode);
 	inode->i_mode = mode;
 	inode->i_uid = fe->uid;
@@ -306,6 +315,7 @@
 		    break;
 	}
 
+ bail:
 	LOG_EXIT ();
 	return;
 }				/* ocfs_populate_inode */
@@ -337,6 +347,13 @@
 	LOG_TRACE_ARGS("osb = %x\n", osb);
 	if (inode->i_ino == OCFS_ROOT_INODE_NUMBER) {
 		LOG_TRACE_ARGS("Populating root inode (i_ino = %lu)\n", inode->i_ino);
+		inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, GFP_NOFS);
+		if (!inode->u.generic_ip) {
+			/* How can we recover gracefully? */
+			LOG_ERROR_STR("unable to allocate private data for inode");
+			goto bail;
+		}
+
 		inode->i_mode = S_IFDIR | osb->vol_layout.prot_bits;
 		inode->i_blksize = 512;	/* TODO: fix */
 		inode->i_blkbits = 9;
@@ -434,6 +451,13 @@
 	sb = inode->i_sb;
 	osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
 	if (inode->i_ino == OCFS_ROOT_INODE_NUMBER) {
+		inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, GFP_NOFS);
+		if (!inode->u.generic_ip) {
+			/* How can we recover gracefully? */
+			LOG_ERROR_STR("unable to allocate private data for inode");
+			goto bail;
+		}
+
 		inode->i_mode = S_IFDIR | osb->vol_layout.prot_bits;
 		inode->i_blksize = (__u32) osb->vol_layout.cluster_size;
 		inode->i_size = OCFS_DEFAULT_DIR_NODE_SIZE;
@@ -745,24 +769,14 @@
 		LOG_TRACE_STR ("inode with oin : clear inode");
 
 		oin = GET_INODE_OIN(inode);
-		if (oin == osb->oin_root_dir) {
-			LOG_TRACE_STR("this is the root inode, doing "
-				      "cleanup now!");
-			ocfs_sync_blockdev(inode->i_sb);
-			LOG_TRACE_STR ("syncing past root inode");
-			LOG_TRACE_STR ("calling dismount");
-			ocfs_dismount_volume (inode->i_sb);
-			goto bail;
-		} else 
+		if (oin != osb->oin_root_dir)
 			BUG();
-
-		ocfs_extent_map_destroy (&oin->map);
-		ocfs_extent_map_init (&oin->map);
-
-		ocfs_release_cached_oin (osb, oin);
-		ocfs_release_oin (oin, true);
-		oin = NULL;
-		LOG_TRACE_STR ("yeah! done with deallocs!");
+		
+		LOG_TRACE_STR("this is the root inode, doing cleanup now!");
+		ocfs_sync_blockdev(inode->i_sb);
+		LOG_TRACE_STR ("syncing past root inode");
+		LOG_TRACE_STR ("calling dismount");
+		ocfs_dismount_volume (inode->i_sb);
 	} else {
 		if (!ocfs_lookup_sector_node (osb, offset, &lockres)) {
 			if (lockres) {
@@ -780,6 +794,9 @@
 		}
 	}
 
+	if (inode->u.generic_ip)
+		kmem_cache_free(OcfsGlobalCtxt.inode_cache, 
+				inode->u.generic_ip);
 bail:
 	LOG_EXIT ();
 	return;
Index: src/super.c
===================================================================
--- src/super.c	(revision 776)
+++ src/super.c	(working copy)
@@ -782,12 +782,30 @@
 }
 #endif
 
+static void ocfs_inode_init_once(void *p, kmem_cache_t *cachep, 
+				 unsigned long flags)
+{
+        ocfs_inode_private *i = (ocfs_inode_private *) p;
+
+	if ((flags & (SLAB_CTOR_VERIFY|SLAB_CTOR_CONSTRUCTOR)) ==
+	    SLAB_CTOR_CONSTRUCTOR) {
+		i->generic_ip = NULL;
+		i->voteoff = 0;
+		i->feoff = 0;
+		atomic_set(&i->i_clean_buffer_seq, 0);
+         }	
+}
+
 /*
  * ocfs_initialize_mem_lists()
  *
  */
 static int ocfs_initialize_mem_lists (void)
 {
+	OcfsGlobalCtxt.inode_cache = kmem_cache_create("ocfs2_inode",
+		 sizeof(ocfs_inode_private), 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
+		 ocfs_inode_init_once, NULL);
+
 	OcfsGlobalCtxt.oin_cache = kmem_cache_create ("ocfs2_oin",
 		sizeof (ocfs_inode) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
@@ -826,6 +844,7 @@
  */
 static void ocfs_free_mem_lists (void)
 {
+	kmem_cache_destroy (OcfsGlobalCtxt.inode_cache);
 	kmem_cache_destroy (OcfsGlobalCtxt.oin_cache);
 	kmem_cache_destroy (OcfsGlobalCtxt.ofile_cache);
 	kmem_cache_destroy (OcfsGlobalCtxt.fe_cache);
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 776)
+++ src/inc/ocfs.h	(working copy)
@@ -239,11 +239,9 @@
 	__u8             deleted; /* this can be a generic flags field later */
 } ocfs_inode_private;
 
-#define CLEAN_SEQ_OFF    	((unsigned long)(&((ocfs_inode_private *)0)->i_clean_buffer_seq))
-#define INODE_PRIVATE_OFF    	((unsigned long)(&((struct inode *)0)->u.generic_ip))
-#define GET_INODE_CLEAN_SEQ(i)  (atomic_t *)(((unsigned long)i) + INODE_PRIVATE_OFF + CLEAN_SEQ_OFF)
+#define GET_INODE_CLEAN_SEQ(i)  (atomic_t *)(&(OCFS_GENERIC_IP(i)->i_clean_buffer_seq))
 
-#define OCFS_GENERIC_IP(i)        ((ocfs_inode_private *)(&(i->u.generic_ip)))
+#define OCFS_GENERIC_IP(i)        ((ocfs_inode_private *)(i->u.generic_ip))
 
 #define inode_data_is_oin(i)      (OCFS_GENERIC_IP(i)->generic_ip != NULL)
 
@@ -2081,6 +2079,7 @@
 	ocfs_obj_id obj_id;
 	ocfs_sem res;
 	struct list_head osb_next;	/* List of all volumes */
+	kmem_cache_t *inode_cache;
 	kmem_cache_t *oin_cache;
 	kmem_cache_t *ofile_cache;
 	kmem_cache_t *fe_cache;
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 776)
+++ src/namei.c	(working copy)
@@ -195,7 +195,13 @@
 		LOG_ERROR_STR("new_inode failed!");
 		goto leave;
 	}
-	
+
+	inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, GFP_NOFS);
+	if (!inode->u.generic_ip) {
+		LOG_ERROR_STATUS(status = -ENOMEM);
+		goto leave;
+	}
+
 	/* need the offset of our parent directory to lock it */
 	if (!ocfs_linux_get_inode_offset (dir, &parent_off, NULL)) {
 		LOG_ERROR_STATUS (status = -ENOENT);
@@ -1342,6 +1348,13 @@
 		LOG_ERROR_STR("new_inode failed!");
 		goto bail;
 	}
+
+	inode->u.generic_ip = kmem_cache_alloc(OcfsGlobalCtxt.inode_cache, GFP_NOFS);
+	if (!inode->u.generic_ip) {
+		LOG_ERROR_STATUS(status = -ENOMEM);
+		goto bail;
+	}
+
 	//atomic_set(GET_INODE_CLEAN_SEQ(inode), atomic_read(&osb->clean_buffer_seq));
 
 	parentInode = dentry->d_parent->d_inode;
