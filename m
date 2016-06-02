From: Gechangwei <ge.changwei@h3c.com>
Date: Thu, 2 Jun 2016 07:40:50 +0000
Subject: [Ocfs2-devel] remove a useless assignment before fence
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CB76F3@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi OCFS2 experts,

I found a strange segment of code during FENCE procedure in function o2hb_stop_all_regions, cited as below:

void o2hb_stop_all_regions(void)
{
        struct o2hb_region *reg;

        mlog(ML_ERROR, "stopping heartbeat on all active regions.\n");

        spin_lock(&o2hb_live_lock);

        list_for_each_entry(reg, &o2hb_all_regions, hr_all_item)
                reg->hr_unclean_stop = 1;

        spin_unlock(&o2hb_live_lock);
}

In this preceding code segment, all o2hb regions' hr_unclean_stop is set to 1, just before an emergency reboot. So it's hard to figure out if other threads have a chance to work according to the value of it.

Can we just remove the assignment?


BR.


Chauncey Ge

H3C Technologies Co., Limited



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
