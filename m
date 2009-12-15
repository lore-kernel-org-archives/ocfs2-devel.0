From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 15 Dec 2009 16:04:53 +0800
Subject: [Ocfs2-devel] ocfs2: add extent block stealing for ocfs2 v1
In-Reply-To: <4B2617D0.7060504@oracle.com>
References: <4B2617D0.7060504@oracle.com>
Message-ID: <4B274325.1050505@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tiger,

@@ -731,36 +715,39 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	(*ac)->ac_bits_wanted = 1;
-	(*ac)->ac_which = OCFS2_AC_USE_INODE;
-
+	(*ac)->ac_bits_wanted = blocks;
 	(*ac)->ac_group_search = ocfs2_block_group_search;
+	if (type == INODE_ALLOC_SYSTEM_INODE)
+		(*ac)->ac_which = OCFS2_AC_USE_INODE;
+	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
+		(*ac)->ac_which = OCFS2_AC_USE_META;
 
 	/*
 	 * stat(2) can't handle i_ino > 32bits, so we tell the
 	 * lower levels not to allocate us a block group past that
 	 * limit.  The 'inode64' mount option avoids this behavior.
 	 */
-	if (!(osb->s_mount_opt & OCFS2_MOUNT_INODE64))
+	if (type == INODE_ALLOC_SYSTEM_INODE &&
+	    !(osb->s_mount_opt & OCFS2_MOUNT_INODE64))
 		(*ac)->ac_max_block = (u32)~0U;
 
 	/*
-	 * slot is set when we successfully steal inode from other nodes.
-	 * It is reset in 3 places:
+	 * slot is set when we successfully steal inode/extent
+	 * from other nodes. It is reset in 3 places:
 	 * 1. when we flush the truncate log
 	 * 2. when we complete local alloc recovery.
 	 * 3. when we successfully allocate from our own slot.
-	 * After it is set, we will go on stealing inodes until we find the
+	 * After it is set, we will go on stealing resource until we find the
 	 * need to check our slots to see whether there is some space for us.
 	 */
 	if (slot != OCFS2_INVALID_SLOT &&
-	    atomic_read(&osb->s_num_inodes_stolen) < OCFS2_MAX_INODES_TO_STEAL)
-		goto inode_steal;
+	    ocfs2_could_steal_resource(osb, type))
+		goto resource_steal;
 
-	atomic_set(&osb->s_num_inodes_stolen, 0);
+	ATOMIC_ZERO_RESOURCE_NUMBER(type);
 	alloc_group = osb->osb_inode_alloc_group;
here, you use the alloc_group which is only used in inode alloc and reset it
after the reservation succeed. I am afraid extent alloc shouldn't use and
change it?

 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
-					     INODE_ALLOC_SYSTEM_INODE,
+					     type,
 					     osb->slot_num,
 					     &alloc_group,
 					     ALLOC_NEW_GROUP |


    I am also curious about one thing. Have you written the test script 
for it to see whether it works?
You can take ocfs2-tests/programs/inode_stealing/inode_stealing.sh for 
reference.

Regards,
Tao

Jun Yang wrote:
> Hi, Joel,
>
> The attached patch is the first version about extent stealing. Please 
> feel free to correct me about the codes or function name or comments.
>
> thanks,
> tiger
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
