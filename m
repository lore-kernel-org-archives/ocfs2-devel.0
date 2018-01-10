From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 10 Jan 2018 11:57:53 +0000
Subject: [Ocfs2-devel] kernel bug
References: <CAN+OZjTsnQr8ybyA6kFz8eK=zQf6EOpDm4AHa7NvyCLCcOPGzQ@mail.gmail.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F290E98C@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi BASSAGET,

We ocfs2 developers are solving a DIO crash issue which may share the same root cause with yours.

You can refer to my patch set of 2 and backport them into your kernel to see if the issue can be kicked away.

  ocfs2: make metadata estimation accurate and clear
  ocfs2: try to reuse extent block in dealloc without meta_alloc

On 2018/1/10 19:48, BASSAGET C?dric wrote:
> Hello
> Today I reported a bug related to ocfs2 1.8.on proxmox forum, maybe somebody here will be able to help me...
> The bog on proxmox forum : https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_threads_ocfs2-2Dkernel-2Dbug.39163_&d=DwIFAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=OVDUAiMu4SZHRAFT7cQxchj6wuCXXbzwGVkzVqvuiig&s=g4t9hVOMcDuDuZ95E4OwnmlKjt_LAIAoI2YKYpkYyi0&e= <https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_threads_ocfs2-2Dkernel-2Dbug.39163_&d=DwMFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=93_F2INiG6ig-q6s8P3sPY09iW1NMx6_H9zZx13OxhM&s=j8Ae2cUQUVQJOimaDZOI0C-HbAhHPvEV-l6BS23AaSw&e=>
> 
> to resume :?kernel BUG at fs/ocfs2/suballoc.c:2017!
> 
> is this related to proxmox kernel or ocfs2 ? or both ?
> does it have something to do with https://oss.oracle.com/pipermail/ocfs2-devel/2017-January/012701.html ?
> 
> Thanks for your help.
> Regards,
> C?dric
