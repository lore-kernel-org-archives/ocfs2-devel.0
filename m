From: Christoph Hellwig <hch@lst.de>
Date: Mon Aug 30 08:41:49 2004
Subject: [Ocfs2-devel] [PATCH] remove vote_obj_lock
Message-ID: <20040830134143.GA17497@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs_vote_obj.refcount is an atomic_t already so we don't need an
additional spinlock to protect it.


Index: src/vote.c
===================================================================
--- src/vote.c	(revision 1398)
+++ src/vote.c	(working copy)
@@ -64,26 +64,18 @@
 static int ocfs_send_bcast (ocfs_super * osb, ocfs_node_map *votemap, ocfs_dlm_msg * dlm_msg);
 static int ocfs_node_map_stringify(ocfs_node_map *map, char **str);
 
-static spinlock_t vote_obj_lock = SPIN_LOCK_UNLOCKED;
-
-
-static void ocfs_put_vote_obj (ocfs_vote_obj *obj)
+static void ocfs_put_vote_obj(ocfs_vote_obj *obj)
 {
-	spin_lock(&vote_obj_lock);
 	if (atomic_dec_and_test(&obj->refcount))
 		kfree(obj);
-	spin_unlock(&vote_obj_lock);
 }
 
-static void ocfs_get_vote_obj (ocfs_vote_obj *obj)
+static void ocfs_get_vote_obj(ocfs_vote_obj *obj)
 {
-	spin_lock(&vote_obj_lock);
 	atomic_inc(&obj->refcount);
-	spin_unlock(&vote_obj_lock);
 }
 
 
-
 /*
  * ocfs_recv_udp_msg()
  *
