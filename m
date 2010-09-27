From: Poyo VL <poyo_vl@yahoo.com>
Date: Mon, 27 Sep 2010 20:28:40 -0000
Subject: [Ocfs2-devel] [PATCH] /fs/ocfs2/slot_map.c (2.6.35.6):
	Uninitialized variable
Message-ID: <28389.94142.qm@web45810.mail.sp1.yahoo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When I tried to compile I got the following warning:
fs/ocfs2/slot_map.c: In function ?ocfs2_init_slot_info?:
fs/ocfs2/slot_map.c:360: warning: ?bytes? may be used uninitialized in this 
function
fs/ocfs2/slot_map.c:360: note: ?bytes? was declared here 
Compiler: gcc version 4.4.3 (GCC) on Mandriva
I'm not sure why this warning occurs, I think compiler don't know that variable 
"bytes" is initialized when it is sent by reference to 
ocfs2_slot_map_physical_size and it throws that ugly warning.
However, a simple initialization of "bytes" variable with 0 will fix it.
Patch is downer, I also attached it because there are problems with Yahoo! Mail.

Signed-off-by: Ionut Gabriel Popescu <poyo_vl@yahoo.com>
---

--- a/fs/ocfs2/slot_map.c    2010-09-27 22:27:07.605568537 +0300
+++ b/fs/ocfs2/slot_map.c    2010-09-27 22:27:29.342567489 +0300
@@ -357,7 +357,7 @@ static int ocfs2_map_slot_buffers(struct
 {
     int status = 0;
     u64 blkno;
-    unsigned long long blocks, bytes;
+    unsigned long long blocks, bytes = 0;
     unsigned int i;
     struct buffer_head *bh;


      
-------------- next part --------------
A non-text attachment was scrubbed...
Name: patch.diff
Type: application/octet-stream
Size: 341 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100927/b34b17b6/attachment.obj 
