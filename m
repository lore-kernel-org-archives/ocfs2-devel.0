From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 18 Apr 2014 05:21:41 +0000
Subject: [Ocfs2-devel] It is maybe a bug, requiring anyone to review it,
	Thanks.
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3FE24@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

void o2net_fill_node_map(unsigned long *map, unsigned bytes)
{
struct o2net_sock_container *sc = NULL;
int node, ret;

BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));

memset(map, 0, bytes);
for (node = 0; node < O2NM_MAX_NODES; ++node) {
o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret);
if (!ret) {
set_bit(node, map);

             if (sc) {
     sc_put(sc);
             }
}
+ sc = NULL;
}
}




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
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140418/0f544b9d/attachment-0001.html 
