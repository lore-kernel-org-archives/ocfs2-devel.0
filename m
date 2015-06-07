From: Joseph Qi <joseph.qi@huawei.com>
Date: Sun, 7 Jun 2015 08:27:12 +0800
Subject: [Ocfs2-devel] o2net_tx_can_proceed reviews, thanks
In-Reply-To: <2015060621065807886420@h3c.com>
References: <2015060621065807886420@h3c.com>
Message-ID: <55738FE0.8080609@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi?
Please read the rules located at Documentation/SubmittingPatches before
submitting patch. This will help maintainer review your patch.

On 2015/6/6 21:06, Zhangguanghui wrote:
> Hi
> 
> 1. in the callback o2net_fill_node_map -> o2net_tx_can_proceed()
> 2. if the function o2net_tx_can_proceed returns false,  then "ret" and sc are uninialized,
> and re-using the value from the previous iteration.  I think this is not reasonable. 
> I do not know whether to hide a bug. 
> checking the return value is harmless and robustness.
> 
> Finally, any feedback about this process (positive or negative) would be  greatly appreciated.
> 
> /* Get a map of all nodes to which this node is currently connected to */
> 
> void o2net_fill_node_map(unsigned long *map, unsigned bytes)
> 
> {
> 	struct o2net_sock_container *sc = NULL;
> 	int node, ret = 0;
> 	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
> 	memset(map, 0, bytes);
> 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
> 		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
> 			continue;
> 		if (!ret) {
> 			set_bit(node, map);
> 			sc_put(sc)
> 
>                 }
> 
>               +   sc = NULL;  
> 
>               +  ret=0;
> 
> 	} 
> }
> 
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------!
---
> zhangguanghui 10102
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
