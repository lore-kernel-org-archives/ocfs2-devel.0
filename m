From: =?UTF-8?Q?BASSAGET_C=C3=A9dric?= <cedric.bassaget.ml@gmail.com>
Date: Thu, 11 Jan 2018 12:51:34 +0100
Subject: [Ocfs2-devel] kernel bug
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F290F0D9@H3CMLB12-EX.srv.huawei-3com.com>
References: <CAN+OZjTsnQr8ybyA6kFz8eK=zQf6EOpDm4AHa7NvyCLCcOPGzQ@mail.gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F290E98C@H3CMLB12-EX.srv.huawei-3com.com>
	<CAN+OZjTq8KpGG75duYHDDRMhrWZde0t_aQe2D35Q8ktxhqNbkQ@mail.gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F290ECCB@H3CMLB12-EX.srv.huawei-3com.com>
	<CAN+OZjSKDjNBJ1vYqnB5vzwzUu70OK+wd_13iGMbsD5S1bvtvw@mail.gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373F290F0D9@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <CAN+OZjQZyUrn18vgaixES6uC+K1ZatRHO0d_u9+_UZ3JocMh1g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

short question : Will the stable release of kernel 4.15 fix this bug ?
Regards

2018-01-11 8:06 GMT+01:00 Changwei Ge <ge.changwei@h3c.com>:

> Hi C?dric,
>
> On kernel mainline:)
>
> On 2018/1/11 14:50, BASSAGET C?dric wrote:
> > Hi Changwei.
> > My question may be stupid, but... can you tell me where I can find the
> source of latest ocfs2 ?
> > Every google search points to oracle website which refers to 1.6
> versions....
> >
> > 2018-01-11 2:03 GMT+01:00 Changwei Ge <ge.changwei@h3c.com <mailto:
> ge.changwei at h3c.com>>:
> >
> >     Hi C?dric,
> >
> >     These two patches are already picked by Andrew being merged into -mm
> tree for now.
> >     So you can refer to below links for them:
> >
> >     https://urldefense.proofpoint.com/v2/url?u=http-3A__ozlabs.org_-7Eakpm_mmots_broken-2Dout_ocfs2-2Dmake-2D&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=20g3Lf_wsqYVloou3gAzKuSQgPFvVZW-i9_euhbOpjc&e=
> metadata-estimation-accurate-and-clear.patch <https://urldefense.proofpoint.com/v2/url?u=http-3A__ozlabs.org_-7Eakpm_&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=6ukzDv8DEwNABn7sbvjtKsDF7TPyvCsEnAZDXedQm6M&e=
> mmots/broken-out/ocfs2-make-metadata-estimation-accurate-and-clear.patch>
> >     https://urldefense.proofpoint.com/v2/url?u=http-3A__ozlabs.org_-7Eakpm_mmots_broken-2Dout_ocfs2-2Dtry-2Dto-2Dreuse-2D&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=FmxMvjLFsrF0f4EfIdmJQXsGDR6rscnOBZnrroNF9Kw&e=
> extent-block-in-dealloc-without-meta_alloc.patch <https://urldefense.proofpoint.com/v2/url?u=http-3A__ozlabs.org_-7Eakpm_&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=6ukzDv8DEwNABn7sbvjtKsDF7TPyvCsEnAZDXedQm6M&e=
> mmots/broken-out/ocfs2-try-to-reuse-extent-block-in-dealloc-
> without-meta_alloc.patch>
> >
> >     Thanks,
> >     Changwei
> >
> >     On 2018/1/10 22:34, BASSAGET C?dric wrote:
> >     > Hi Changwei,
> >     > Can you give me a ref or a link pointing to your patch ?
> >     > Thanks
> >     >
> >      > 2018-01-10 12:57 GMT+01:00 Changwei Ge <ge.changwei@h3c.com
> <mailto:ge.changwei@h3c.com> <mailto:ge.changwei@h3c.com <mailto:
> ge.changwei at h3c.com>>>:
> >     >
> >     >     Hi BASSAGET,
> >     >
> >     >     We ocfs2 developers are solving a DIO crash issue which may
> share the same root cause with yours.
> >     >
> >     >     You can refer to my patch set of 2 and backport them into your
> kernel to see if the issue can be kicked away.
> >     >
> >     >        ocfs2: make metadata estimation accurate and clear
> >     >        ocfs2: try to reuse extent block in dealloc without
> meta_alloc
> >     >
> >     >     On 2018/1/10 19:48, BASSAGET C?dric wrote:
> >     >     > Hello
> >     >     > Today I reported a bug related to ocfs2 1.8.on proxmox
> forum, maybe somebody here will be able to help me...
> >      >      > The bog on proxmox forum : https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=mTbG-drRMa_sMPv2_LYgY4KUtqHgPpgV-5LyUTd49YM&e=
> threads/ocfs2-kernel-bug.39163/ <https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=mTbG-drRMa_sMPv2_LYgY4KUtqHgPpgV-5LyUTd49YM&e=
> threads/ocfs2-kernel-bug.39163/> <https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=mTbG-drRMa_sMPv2_LYgY4KUtqHgPpgV-5LyUTd49YM&e=
> threads/ocfs2-kernel-bug.39163/ <https://urldefense.proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=mTbG-drRMa_sMPv2_LYgY4KUtqHgPpgV-5LyUTd49YM&e=
> threads/ocfs2-kernel-bug.39163/>> <https://urldefense.proofpoint.com/v2/url?u=https-3A__urldefense&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=SWvBmib8lZnZOJmG9RFBJmKJ7UdwXje2gAIfNgwaqvw&e=.
> proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_threads_
> ocfs2-2Dkernel-2Dbug.39163_&d=DwMFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIr
> MUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iD
> Y8-HD0qT6Fo7Y&m=93_F2INiG6ig-q6s8P3sPY09iW1NMx6_H9zZx13OxhM&s=
> j8Ae2cUQUVQJOimaDZOI0C-HbAhHPvEV-l6BS23AaSw&e= <https://urldefense.proofpoint.com/v2/url?u=https-3A__urldefense&d=DwIFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=8A4YNFzuh7DrMaRvGKKpYUICBcnBukXcKUvtzrl7wDk&s=SWvBmib8lZnZOJmG9RFBJmKJ7UdwXje2gAIfNgwaqvw&e=.
> proofpoint.com/v2/url?u=https-3A__forum.proxmox.com_threads_
> ocfs2-2Dkernel-2Dbug.39163_&d=DwMFaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIr
> MUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iD
> Y8-HD0qT6Fo7Y&m=93_F2INiG6ig-q6s8P3sPY09iW1NMx6_H9zZx13OxhM&s=
> j8Ae2cUQUVQJOimaDZOI0C-HbAhHPvEV-l6BS23AaSw&e=>
> >     <https://urldefense.proofpoint.com/v2/url?u=https-
> 3A__forum.proxmox.com_threads_ocfs2-2Dkernel-2Dbug.39163_&d=DwMFaQ&c=
> RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=
> C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=93_F2INiG6ig-
> q6s8P3sPY09iW1NMx6_H9zZx13OxhM&s=j8Ae2cUQUVQJOimaDZOI0C-
> HbAhHPvEV-l6BS23AaSw&e= <https://urldefense.proofpoint.com/v2/url?u=https-
> 3A__forum.proxmox.com_threads_ocfs2-2Dkernel-2Dbug.39163_&d=DwMFaQ&c=
> RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=
> C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=93_F2INiG6ig-
> q6s8P3sPY09iW1NMx6_H9zZx13OxhM&s=j8Ae2cUQUVQJOimaDZOI0C-
> HbAhHPvEV-l6BS23AaSw&e=>>>
> >     >      >
> >     >      > to resume : kernel BUG at fs/ocfs2/suballoc.c:2017!
> >     >      >
> >     >      > is this related to proxmox kernel or ocfs2 ? or both ?
> >      >      > does it have something to do with https://oss.oracle.com/
> pipermail/ocfs2-devel/2017-January/012701.html <https://oss.oracle.com/
> pipermail/ocfs2-devel/2017-January/012701.html> <https://oss.oracle.com/
> pipermail/ocfs2-devel/2017-January/012701.html <https://oss.oracle.com/
> pipermail/ocfs2-devel/2017-January/012701.html>> ?
> >      >      >
> >      >      > Thanks for your help.
> >      >      > Regards,
> >      >      > C?dric
> >      >
> >      >
> >
> >
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20180111/c8a4c487/attachment-0001.html 
