From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 21 Feb 2014 03:59:32 +0000
Subject: [Ocfs2-devel] =?gb2312?b?tPC4tDogW09jZnMyLXVzZXJzXSBIaSBldmVyeW9u?=
 =?gb2312?b?ZSwgaXMgaXQgYW4gaXNzdWU/IFRoZSBob3N0IGlzIGJsb2NrZWQgYXMgdGhl?=
 =?gb2312?b?IGlzc3VlIGNyZWF0ZWQuIFRoYW5rcyBhIGxvdC4=?=
In-Reply-To: <CALoaWF79xp2KpAWNCozjURL7uY1DqkPEsB2LkYGG7s+QmCZTyg@mail.gmail.com>
References: <71604351584F6A4EBAE558C676F37CA42EC3AD7B@H3CMLB02-EX.srv.huawei-3com.com>
	<CALoaWF79xp2KpAWNCozjURL7uY1DqkPEsB2LkYGG7s+QmCZTyg@mail.gmail.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC3AD9C@H3CMLB02-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Marty,

It is that the latest one host which run fio tools, and the host is frequently receive the stack trace and fenced, other hosts' IO lock up which is in the OCFS2 cluster at the same time.

We will try the new kernel.

Thanks a lot.

Guozhonghua

-----????-----
???: Marty Sweet [mailto:msweet.dev at gmail.com]
????: 2014?2?21? 11:47
???: guozhonghua 02084
??: ocfs2-devel at oss.oracle.com; ocfs2-users at oss.oracle.com
??: Re: [Ocfs2-users] Hi everyone, is it an issue? The host is blocked as the issue created. Thanks a lot.

Hi,

By the looks of the call-trace this looks like an issue with communicating with the iSCSI target.
I run 6 nodes with OCFS2 over Fibre Channel on Ubuntu 12.04 Linux 3.5 and Linux 3.13 (VM Cluster and Samba Cluster).

Before investigating this any further I would advise upgrading your kernel to at least 3.8 (which is officially support by Ubuntu). There have been many improvements to OCFS2 in recent kernels which have increased the stability in (at least our environment) substantially.

$ apt-get install linux-image-3.8.0-35-generic

If the problem still persists, does you iSCSI target have monitoring statistics which you could look into? If the network link is becoming saturated this could be the issue (especially if heartbeat is running over the same interface).
Could you also let us know which node is fencing and if all subsequent nodes receive this stack trace? Does the IO lock up? ( $ ls /vms/vStore )

Marty

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
