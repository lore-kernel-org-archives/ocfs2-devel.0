From: John Villalovos <John.L.Villalovos@intel.com>
Date: Tue Feb 10 19:16:31 2004
Subject: [Ocfs2-devel] Patch to add some error checking to super.c
Message-ID: <40298266.6040503@intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am starting to explore the code and I started at super.c.

Here is a patch to add some error checking.  It also removes a redundant 
INIT_LIST_HEAD call.

John

Index: src/super.c
===================================================================
--- src/super.c	(revision 30)
+++ src/super.c	(working copy)
@@ -434,7 +434,6 @@
          INIT_LIST_HEAD (&(OcfsGlobalCtxt.item_list));
  #endif
  	INIT_LIST_HEAD (&(OcfsGlobalCtxt.osb_next));
-	INIT_LIST_HEAD (&(OcfsGlobalCtxt.osb_next));

  	/* Read remaining insmod params */
  	if ((status = ocfs_read_params ()) < 0)
@@ -767,29 +766,36 @@
  	OcfsGlobalCtxt.oin_cache = kmem_cache_create ("ocfs2_oin",
  		sizeof (ocfs_inode) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | 
SLAB_HWCACHE_ALIGN,
  		NULL, NULL);
+	if ( !OcfsGlobalCtxt.oin_cache ) return -ENOMEM;

  	OcfsGlobalCtxt.ofile_cache = kmem_cache_create ("ocfs2_ofile",
  		sizeof (ocfs_file) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | 
SLAB_HWCACHE_ALIGN,
  		NULL, NULL);
+	if ( !OcfsGlobalCtxt.ofile_cache ) return -ENOMEM;

  	OcfsGlobalCtxt.lockres_cache = kmem_cache_create ("ocfs2_lockres",
  		sizeof (ocfs_lock_res) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | 
SLAB_HWCACHE_ALIGN,
  		NULL, NULL);
+	if ( !OcfsGlobalCtxt.lockres_cache ) return -ENOMEM;

  	OcfsGlobalCtxt.fe_cache = kmem_cache_create ("ocfs2_fileentry",
  		OCFS_SECTOR_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if ( !OcfsGlobalCtxt.fe_cache ) return -ENOMEM;

  	OcfsGlobalCtxt.extent_cache = kmem_cache_create ("ocfs2_extent",
  		sizeof(ocfs_extent) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | 
SLAB_HWCACHE_ALIGN,
  		NULL, NULL);
-	
+	if ( !OcfsGlobalCtxt.extent_cache ) return -ENOMEM;
+
  	OcfsGlobalCtxt.bh_sem_cache = kmem_cache_create ("ocfs2_bh_sem",
  		sizeof(ocfs_bh_sem), 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
  		NULL, NULL);
+	if ( !OcfsGlobalCtxt.bh_sem_cache ) return -ENOMEM;

  	OcfsGlobalCtxt.inum_cache = kmem_cache_create("ocfs2_inum",
  		sizeof(ocfs_inode_num), 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
  		NULL, NULL);
+	if ( !OcfsGlobalCtxt.inum_cache ) return -ENOMEM;

  	OCFS_SET_FLAG (OcfsGlobalCtxt.flags, OCFS_FLAG_MEM_LISTS_INITIALIZED);




-------------- next part --------------
Index: src/super.c
===================================================================
--- src/super.c	(revision 30)
+++ src/super.c	(working copy)
@@ -434,7 +434,6 @@
         INIT_LIST_HEAD (&(OcfsGlobalCtxt.item_list));
 #endif
 	INIT_LIST_HEAD (&(OcfsGlobalCtxt.osb_next));
-	INIT_LIST_HEAD (&(OcfsGlobalCtxt.osb_next));
 
 	/* Read remaining insmod params */
 	if ((status = ocfs_read_params ()) < 0)
@@ -767,29 +766,36 @@
 	OcfsGlobalCtxt.oin_cache = kmem_cache_create ("ocfs2_oin",
 		sizeof (ocfs_inode) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
+	if ( !OcfsGlobalCtxt.oin_cache ) return -ENOMEM;
 
 	OcfsGlobalCtxt.ofile_cache = kmem_cache_create ("ocfs2_ofile",
 		sizeof (ocfs_file) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
+	if ( !OcfsGlobalCtxt.ofile_cache ) return -ENOMEM;
 
 	OcfsGlobalCtxt.lockres_cache = kmem_cache_create ("ocfs2_lockres",
 		sizeof (ocfs_lock_res) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
+	if ( !OcfsGlobalCtxt.lockres_cache ) return -ENOMEM;
 
 	OcfsGlobalCtxt.fe_cache = kmem_cache_create ("ocfs2_fileentry",
 		OCFS_SECTOR_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if ( !OcfsGlobalCtxt.fe_cache ) return -ENOMEM;
 
 	OcfsGlobalCtxt.extent_cache = kmem_cache_create ("ocfs2_extent",
 		sizeof(ocfs_extent) + OCFS_POINTER_SIZE, 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
-	
+	if ( !OcfsGlobalCtxt.extent_cache ) return -ENOMEM;
+
 	OcfsGlobalCtxt.bh_sem_cache = kmem_cache_create ("ocfs2_bh_sem",
 		sizeof(ocfs_bh_sem), 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN,
 		NULL, NULL);
+	if ( !OcfsGlobalCtxt.bh_sem_cache ) return -ENOMEM;
 
 	OcfsGlobalCtxt.inum_cache = kmem_cache_create("ocfs2_inum", 
 		sizeof(ocfs_inode_num), 0, SLAB_NO_REAP | SLAB_HWCACHE_ALIGN, 
 		NULL, NULL);
+	if ( !OcfsGlobalCtxt.inum_cache ) return -ENOMEM;
 
 	OCFS_SET_FLAG (OcfsGlobalCtxt.flags, OCFS_FLAG_MEM_LISTS_INITIALIZED);
 
