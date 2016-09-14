From: Guozhonghua <guozhonghua@h3c.com>
Date: Wed, 14 Sep 2016 03:41:05 +0000
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSNOiAgW1BBVENIXSBvY2ZzMjogb2xkbWxl?=
 =?utf-8?q?_should_be_put_while_-EEXIST_returned=2C_and_the_new_mle_should?=
 =?utf-8?q?_not_be_get_once_at_that_time=2E?=
In-Reply-To: <57D8BBD5.6000408@huawei.com>
References: <71604351584F6A4EBAE558C676F37CA4A3D35566@H3CMLB12-EX.srv.huawei-3com.com>
	<57D8BBD5.6000408@huawei.com>
Message-ID: <71604351584F6A4EBAE558C676F37CA4A3D355CC@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Joseph

I reviewed the patch of 32e493265b2b.
If the ret is --EEXIST, the oldmle will not be put.

As the fucntion dlm_add_migration_mle called, the return value is -EEXIST.
The oldmle had been gotten once and goto fail.

The fail code, ret is -EEXIST, so there is not anyway for the oldmle to be put.
fail:
        if (ret != -EEXIST && oldmle) {
                /* master is known, detach if not already detached */
                dlm_mle_detach_hb_events(dlm, oldmle);
                dlm_put_mle(oldmle);
        }

Same thing, the new mle is allocated
It will not initialized with the ret --EEXIST while call dlm_add_migration_mle.
So it is wrong to call dlm_get_mle_inuse(mle) for the new mle before goto fail.

I review these code and find that is not well.
Please have a check, and your comments will be good for me.
Thank You.

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
