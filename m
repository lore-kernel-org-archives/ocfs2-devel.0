From: piaojun <piaojun@huawei.com>
Date: Wed, 10 Jan 2018 20:03:43 +0800
Subject: [Ocfs2-devel] kernel bug
In-Reply-To: <CAN+OZjTsnQr8ybyA6kFz8eK=zQf6EOpDm4AHa7NvyCLCcOPGzQ@mail.gmail.com>
References: <CAN+OZjTsnQr8ybyA6kFz8eK=zQf6EOpDm4AHa7NvyCLCcOPGzQ@mail.gmail.com>
Message-ID: <5A56011F.8000906@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi C?dric,

You'd better paste the core dump stack and the method of reproducing
this BUG.

thanks,
Jun

On 2018/1/10 19:48, BASSAGET C?dric wrote:
> Hello
> Today I reported a bug related to ocfs2 1.8.on proxmox forum, maybe somebody here will be able to help me...
> The bog on proxmox forum : https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_threads_ocfs2-2Dkernel-2Dbug.39163_&d=DwID-g&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Cjs_sZYvlRtRCpsPU_lWPoen_rJyr14Cw3AxxedrGac&s=1IlEt5_VsnceBwz_3AYQq8zKNy6viF9oxQGtp8odqn4&e= <https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_threads_ocfs2-2Dkernel-2Dbug.39163_&d=DwMFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=93_F2INiG6ig-q6s8P3sPY09iW1NMx6_H9zZx13OxhM&s=j8Ae2cUQUVQJOimaDZOI0C-HbAhHPvEV-l6BS23AaSw&e=>
> 
> to resume : kernel BUG at fs/ocfs2/suballoc.c:2017!
> 
> is this related to proxmox kernel or ocfs2 ? or both ?
> does it have something to do with https://oss.oracle.com/pipermail/ocfs2-devel/2017-January/012701.html ?
> 
> Thanks for your help.
> Regards,
> C?dric
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
