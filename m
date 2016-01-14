From: Guozhonghua <guozhonghua@h3c.com>
Date: Thu, 14 Jan 2016 09:58:37 +0000
Subject: [Ocfs2-devel] Patch's talk
Message-ID: <71604351584F6A4EBAE558C676F37CA4829207B9@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Jiufei,

Yes, it is right as the node down to set the .

But in the function of __dlm_lockres_unused, the state of DLM_LOCK_RES_MIGRATING is not used to determine whether the res has some usage. The DLM_LOCK_RES_RECOVERING stat is used.
Is anything wrong?

Thanks
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
