From: Shichangkuo <shi.changkuo@h3c.com>
Date: Wed, 13 Jan 2016 06:07:41 +0000
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSNOiAgZGxuIGRvbWFpbl9tYXAgaXMgbm90?=
 =?utf-8?q?_consistent_after_a_node_was_fencing?=
In-Reply-To: <5695BD42.30403@huawei.com>
References: <D1E4D02760513D4B90DC3B40FF32AF355EE0C84C@H3CMLB12-EX.srv.huawei-3com.com>
	<5695BD42.30403@huawei.com>
Message-ID: <D1E4D02760513D4B90DC3B40FF32AF355EE0CB4B@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Joseph, Junxiao and Jiufei,
	Thanks for your reply.
	I am sorry for my mistake after checking syslog on Node2 again. The disk is indeed unavailable on Node2 and Node3 when Node1 was mounting.
    The slotmap also changed, as Node1 will do "recovery" on Node2 and Node3
root at cvknode1:~# debugfs.ocfs2 -R slotmap /dev/sdd
	Slot#   Node#
	    1       2

When the storage link recovered , and mounted another LUN on Node1, the tcp connections to Node2 and Node3 established, but the dlm map of LUN1 still inconsistent.
Then the cluster enters split-brain state, dose this issue can automatically fix when heartbeat changed to be active?

-----------------
???: xuejiufei [mailto:xuejiufei at huawei.com] 
????: 2016?1?13? 10:58
???: shichangkuo 09727 (CCPL); ocfs2-devel at oss.oracle.com
??: Re: [Ocfs2-devel] dln domain_map is not consistent after a node was fencing

Hi Changkuo,

On 2016/1/11 19:52, Shichangkuo wrote:
> Hi,
> 
> I have three nodes in one cluster. Node1 disconnect TCP with Node2 and Node3, and then fencing by restarting.
> When re-mounted LUNA on Node1, I found strange issue: Node1 this it was the only node mounted on LUNA, the kernel log as follows:
> Jan  4 16:46:14 cvk12 kernel: [   99.223321] o2dlm: Joining domain 0400EAB0791F4B4C85F3FCB5AAC76A1D ( 5 ) 1 nodes
> 
> I don't think Node1 had a mistake by reading heartbeat on other slots.
Maybe Node2 and Node3 is busy writing user data and can not write heartbeat to disk when Node1 remount.
So Node1 think Node2 and Node3 is dead. So the dlm domain_map on Node1 only contain itself.

> The most possible reason maybe other nodes responded JOIN_OK_NO_MAP after receiving dlm_query_join messages by Node1.
> Threr are two ways to respond JOIN_OK_NO_MAP in dlm_query_join_handler:
>     1) dlm->dlm_state == DLM_CTXT_LEAVING
>     2) dlm->dlm_state == DLM_CTXT_NEW &&
>                     dlm->joining_node == DLM_LOCK_RES_OWNER_UNKNOWN 
> But neither of them is suitable as node already mounted.
> I have no idea about it, If any other encount or familiar with this issue, please let me know.
> 
> Thanks,
> Changkuo.
> 
> ----------------------------------------------------------------------
> ---------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from 
> H3C, which is intended only for the person or entity whose address is 
> listed above. Any use of the information contained herein in any way 
> (including, but not limited to, total or partial disclosure, 
> reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, 
> please notify the sender by phone or email immediately and delete it!
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
