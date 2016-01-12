From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 12 Jan 2016 10:21:15 +0800
Subject: [Ocfs2-devel] dln domain_map is not consistent after a node was
 fencing
In-Reply-To: <D1E4D02760513D4B90DC3B40FF32AF355EE0C84C@H3CMLB12-EX.srv.huawei-3com.com>
References: <D1E4D02760513D4B90DC3B40FF32AF355EE0C84C@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <5694631B.50807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 01/11/2016 07:52 PM, Shichangkuo wrote:
> Hi,
> 
> I have three nodes in one cluster. Node1 disconnect TCP with Node2 and Node3, and then fencing by restarting.
> When re-mounted LUNA on Node1, I found strange issue: Node1 this it was the only node mounted on LUNA, the kernel log as follows:
> Jan  4 16:46:14 cvk12 kernel: [   99.223321] o2dlm: Joining domain 0400EAB0791F4B4C85F3FCB5AAC76A1D ( 5 ) 1 nodes
> 
> I don't think Node1 had a mistake by reading heartbeat on other slots.
So tcp connections from node 1 to node2/3 were established?

> The most possible reason maybe other nodes responded JOIN_OK_NO_MAP after receiving dlm_query_join messages by Node1.
> Threr are two ways to respond JOIN_OK_NO_MAP in dlm_query_join_handler:
>     1) dlm->dlm_state == DLM_CTXT_LEAVING
>     2) dlm->dlm_state == DLM_CTXT_NEW &&
>                     dlm->joining_node == DLM_LOCK_RES_OWNER_UNKNOWN
> But neither of them is suitable as node already mounted.
Can this happen every time? If so and no connection issue, you can use
tcpdump to capture packets to see what happened.

Thanks,
Junxiao.

> I have no idea about it, If any other encount or familiar with this issue, please let me know.
> 
> Thanks,
> Changkuo.
> 
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
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
