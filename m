From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 25 Mar 2016 08:22:53 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Error code comments and amendments.
 The comment of ocfs2_extended_slot should be 0x08.
Message-ID: <71604351584F6A4EBAE558C676F37CA4829467DA@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Error code comments and amendments. The comment of ocfs2_extended_slot should be 0x08.

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>

--- ocfs2.org/ocfs2_fs.h        2016-03-25 15:29:22.187343770 +0800
+++ ocfs2/ocfs2_fs.h    2016-03-25 15:30:08.823345004 +0800
@@ -580,7 +580,7 @@ struct ocfs2_extended_slot {
 /*00*/ __u8    es_valid;
        __u8    es_reserved1[3];
        __le32  es_node_num;
-/*10*/
+/*08*/
 };

 /*
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
