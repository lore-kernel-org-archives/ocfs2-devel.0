From: Christoph Hellwig <hch@lst.de>
Date: Mon Aug 30 09:00:06 2004
Subject: [Ocfs2-devel] [PATCH] dead code in extmap.c
Message-ID: <20040830140001.GA17838@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/extmap.c
===================================================================
--- src/extmap.c	(revision 1398)
+++ src/extmap.c	(working copy)
@@ -43,7 +43,6 @@
 /* works ok in userland debugocfs stuff too */
 
 static int ocfs_extent_map_add (ocfs_extent_map * map, __s64 virtual, __s64 physical, __s64 sectors);
-static void ocfs_extent_map_remove (ocfs_extent_map * map, __s64 virtual, __s64 sectors);
 static int ocfs_extent_map_lookup (ocfs_extent_map *map, __s64 virtual, __s64 *physical, __s64 *sectors, __u32 *index);
 static int ocfs_extent_map_next_entry (ocfs_extent_map *map, __u32 index, __s64 *virtual, __s64 *physical, __s64 *sectors);
 
@@ -321,47 +320,6 @@
 	return ret;
 }				/* ocfs_extent_map_add */
 
-/* ocfs_extent_map_remove()
- *
- */
-static void ocfs_extent_map_remove (ocfs_extent_map * map, __s64 virtual, __s64 sectors)
-{
-	struct list_head *iter, *tmpiter;
-	ocfs_extent *tmp;
-	int voverlap;
-	__s64 lo, sec;
-
-	LOG_ENTRY ();
-
-	OCFS_ASSERT (map != NULL);
-
-	if (!map->initialized)
-		goto bail;
-
-	spin_lock(&(map->lock));
-	list_for_each_safe(iter, tmpiter, &map->head) {
-		tmp = list_entry (iter, ocfs_extent, list);
-		lo = tmp->virtual;
-		sec = tmp->sectors;
-		voverlap = get_overlap_type (virtual, virtual+sectors, lo, lo+sec);
-		/* for now, don't allow splitting of entries */
-		if (voverlap!=FULLY_CONTAINED)
-			continue;
-		if (virtual == lo && sectors == sec) {
-			list_del(&tmp->list);
-			kmem_cache_free(OcfsGlobalCtxt.extent_cache,
-					tmp);
-			map->count--;
-			break;
-		}
-	}
-	spin_unlock(&(map->lock));
-bail:
-
-	LOG_EXIT ();
-	return;
-}				/* ocfs_extent_map_remove */
-
 /*
  * ocfs_extent_map_lookup()
  *
@@ -448,32 +406,7 @@
 	return ret;
 }				/* ocfs_extent_map_next_entry */
 
-
 /*
- * ocfs_remove_extent_map_entry()
- *
- * Remove an entry from the extent map
- */
-static void ocfs_remove_extent_map_entry (ocfs_super * osb, ocfs_extent_map * Map, __s64 Vbo, __u32 ByteCount)
-{
-	LOG_ENTRY ();
-
-	if ((ByteCount) && (ByteCount != 0xFFFFFFFF)) {
-		ByteCount--;
-		ByteCount >>= osb->sb->s_blocksize_bits;
-		ByteCount++;
-	}
-
-	Vbo >>= osb->sb->s_blocksize_bits;
-
-	ocfs_extent_map_remove (Map, Vbo, (__s64) ByteCount);
-
-	LOG_EXIT ();
-	return;
-}				/* ocfs_remove_extent_map_entry */
-
-
-/*
  * ocfs_get_next_extent_map_entry()
  *
  * This routine looks up the existing mapping of VBO to LBO for a  file.
