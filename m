From: Guozhonghua <guozhonghua@h3c.com>
Date: Sat, 27 Jul 2013 09:27:07 +0000
Subject: [Ocfs2-devel] =?gb2312?b?tPC4tDogIElzIGl0IGFuIGlzc3VlIGFuZCB3aGV0?=
 =?gb2312?b?aGVyIHRoZSBjb2RlIGNoYW5nZWQgY29ycmVjdD8gVGhhbmtzIGEgbG90?=
In-Reply-To: <51E64E08.3090003@oracle.com>
References: <71604351584F6A4EBAE558C676F37CA417BD8D31@H3CMLB02-EX.srv.huawei-3com.com>
	<51E64E08.3090003@oracle.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA417BDD08C@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Liu,
Sorry for delay response, and I am very glad to receive your email.

We are using OCFS2 as to full use IP-SAN or FC-SAN storage and provide conveniences of the iSCSI/FC storage management.

The test scenario is that there are several nodes in the ocfs2 cluster.
All the nodes have two network interface, one is used to be management network, such as 192.168.0.12, the other is network connected with iSCSI storage, such as 192.168.10.12.
And the management IP 192.168.0.12 is used as by OCFS2 to setup tcp connection, configured in the /etc/ocfs2/cluster.conf file.
This scenario may be same as that used as FC SAN, management network is used by OCFS2 to setup TCP connections to communicates information.
As we setup bond of the management network of the host node on the switch directly connected with node, the node's network interface will down and up, so OCFS2 kernel detect it, the TCP may be disconnected without reconnection. But the storage network is still OK, connected with iSCSI or FC SAN, the heart beat of OCFS2 writing disk on the iSCSI/FC SAN is OK still.
There are messages cannot be communicated between nodes, such as dlm messages, so the OCFS2 cluster may be blocked sometime.

I review the code and have setup one cluster to test, trying to find out the reason why all the cluster or several node of the cluster blocked on the storage disk.

There are code to process reconnect between node. The connection shutdown node whose cluster number is little, should be reconnected from the node whose cluster node number is larger does not triggered as my email described before.

And there is another issues, which blocks the use of the cluster, the cluster is blocked and several nodes could not access the OCFS storage.
The node host does not have response with packets, such as ping, this issue may be DLM.

Thanks a lot

Guozhonghua

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
