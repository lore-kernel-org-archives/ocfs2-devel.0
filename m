From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 20 Apr 2016 08:24:35 +0000
Subject: [Ocfs2-devel] ocfs2: disk timeout,
	autoumount the volume to avoid host reboot
Message-ID: <71604351584F6A4EBAE558C676F37CA48294CD74@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Guanghui,

That will be an good new feature to OCFS2.

There is one scenarios that one host have several LUNs connected with different storage servers, may be iSCSI, and FC SAN.
One of the volumes(LUNs) disconnected from server, the host will be fence and restart itself for heartbeat timeout.
Same time, the services running depend on the other good volumes(LUNs) will be interrupted and cannot be accessed continuously for the host, which is been restarted.

If OCFS2 had this feature, the services depending on other good status volumes(LUNs) will be running continue, and the host will not be fence, and not restart itself.
Only this services which depend on the abnormal volume(LUN) run timeout.

I think it is a good idea and feature for OCFS2.

Thank you.
Guozhonghua



Message: 2
Date: Wed, 20 Apr 2016 07:27:48 +0000
From: Zhangguanghui <zhang.guanghui@h3c.com>
Subject: [Ocfs2-devel] ocfs2: disk timeout, autoumount the volume to
        avoid calling emergency_restart
To: "ocfs2-devel-bounces at oss.oracle.com"
        <ocfs2-devel-bounces@oss.oracle.com>,   "ocfs2-devel at oss.oracle.com"
        <ocfs2-devel@oss.oracle.com>
Message-ID:
        <E3535A62B291B54FBD1D003696CCB5375E19CDC7@H3CMLB14-EX.srv.huawei-3com.com>

Content-Type: text/plain; charset="utf-8"
Hi everyone


In ocfs2, when one storage volume can't access, all nodes which have mounted the volume will fence self

due to write timeout or io error. So I make a useful attempt to add autoumount option.

in the case, I know that for some reason umount may be hung.Based on the analysis process of ocfs2 umount,

it's possible to complete all locks and wake up block events before umounting the volume.

the way is to work well by forever experimenting and devising tests.the patch may be release in the recent times.

Is the patch risky and reasonable? what do you think ? Thanks

Best regards
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
