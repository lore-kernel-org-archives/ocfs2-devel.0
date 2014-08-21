From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 21 Aug 2014 02:31:09 +0000
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSNOiAgQ2x1c3RlciBibG9ja2VkLCBzbyBh?=
 =?utf-8?q?s_to_reboot_all_nodes_to_avoid_it=2E_Is_there_any_patchs_for_it?=
 =?utf-8?b?PyBUaGFua3Mu?=
In-Reply-To: <53F5528E.2030608@huawei.com>
References: <71604351584F6A4EBAE558C676F37CA42EC6360C@H3CMLB14-EX.srv.huawei-3com.com>
	<53F5528E.2030608@huawei.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA42EC636F4@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks Joseph

But as I try it, there is some error:
debugfs: fs_locks -B
Debug string proto 3 found, but 2 is the highest I understand.

Ocfs2-tools 1.6.4.  Is the tools version older?


We have the blocked scenario several times for different code stack, and is there any way changing codes to avoid it?
I means return error code for blocked lock without wait the completion.

Thanks

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
