From: Christoph Hellwig <hch@lst.de>
Date: Fri Sep  3 04:11:43 2004
Subject: [Ocfs2-devel] [PATCH] remove dead code from vote.c
Message-ID: <20040903091138.GA32029@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Index: src/vote.c
===================================================================
--- src/vote.c	(revision 1418)
+++ src/vote.c	(working copy)
@@ -991,19 +991,6 @@
 	}
 }
 
-// set all the bits in "target" which are set in "mask"
-void ocfs_node_map_set_bits(ocfs_node_map *target, ocfs_node_map *mask)
-{
-	int bit, prev=0;
-	while (1) {
-		bit = find_next_bit (mask->map, mask->num_nodes, prev);
-		if (bit > mask->num_nodes)
-			break;
-		ocfs_node_map_set_bit(target, bit);
-		prev = bit+1;
-	}
-}
-
 int ocfs_node_map_test_bit(ocfs_node_map *map, int bit)
 {
 	if (bit >= map->num_nodes) {
@@ -1098,38 +1085,6 @@
 	ocfs_node_map_set(target, from);
 }
 
-// expects that "target" is already inited with correct 
-// num_nodes, and that "from" is of course wide enough
-/* Force le32 as the endian format for on-disk node maps */
-#define OCFS_NODE_MAP_DISK_BITS_PER_LONG 32
-#define OCFS_NODE_MAP_DISK_BITS_TO_LONGS(bits) \
-	(((bits)+OCFS_NODE_MAP_DISK_BITS_PER_LONG-1)/OCFS_NODE_MAP_DISK_BITS_PER_LONG)
-void ocfs_node_map_set_from_disk(ocfs_node_map *target, void *from)
-{
-	int i, num_u32; 
-	u32 *t = (u32 *)target->map;
-	u32 *f = from;
-
-	OCFS_ASSERT(target->num_nodes > 0);
-
-	num_u32 = OCFS_NODE_MAP_DISK_BITS_TO_LONGS(target->num_nodes);
-	for (i = 0; i < num_u32; i++)
-		t[i] = le32_to_cpu(f[i]);
-}
-
-void ocfs_node_map_set_to_disk(void *target, ocfs_node_map *from)
-{
-	int i, num_u32; 
-	u32 *t = target;
-	u32 *f = (u32 *)from->map;
-
-	OCFS_ASSERT(from->num_nodes > 0);
-
-	num_u32 = OCFS_NODE_MAP_DISK_BITS_TO_LONGS(from->num_nodes);
-	for (i=0; i<num_u32; i++)
-		t[i] = cpu_to_le32(f[i]);
-}
-
 /* returns 1 if bit is the only bit set in target, 0 otherwise */
 int ocfs_node_map_is_only(ocfs_super *osb, ocfs_node_map *target, int bit)
 {
Index: src/vote.h
===================================================================
--- src/vote.h	(revision 1418)
+++ src/vote.h	(working copy)
@@ -57,18 +57,12 @@
 void ocfs_node_map_clear_bit(ocfs_node_map *map, int bit);
 // clear all the bits in "target" which are set in "mask"
 void ocfs_node_map_clear_bits(ocfs_node_map *target, ocfs_node_map *mask);
-// set all the bits in "target" which are set in "mask"
-void ocfs_node_map_set_bits(ocfs_node_map *target, ocfs_node_map *mask);
 int ocfs_node_map_test_bit(ocfs_node_map *map, int bit);
 int ocfs_node_map_is_empty(ocfs_node_map *map);
 int ocfs_node_map_is_equal(ocfs_node_map *map1, ocfs_node_map *map2);
 void ocfs_node_map_and(ocfs_node_map *target, ocfs_node_map *mask);
 void ocfs_node_map_set(ocfs_node_map *target, ocfs_node_map *from);
 void ocfs_node_map_dup(ocfs_super *osb, ocfs_node_map *target, ocfs_node_map *from);
-// expects that "target" is already inited with correct 
-// num_nodes, and that "from" is of course wide enough
-void ocfs_node_map_set_from_disk(ocfs_node_map *target, void *from);
-void ocfs_node_map_set_to_disk(void *target, ocfs_node_map *from);
 /* returns 1 if bit is the only bit set in target, 0 otherwise */
 int ocfs_node_map_is_only(ocfs_super *osb, ocfs_node_map *target, int bit);
 
