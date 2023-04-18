Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C099AC77B71
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Apr 2023 09:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5KwhyB2ti05Guo8nK0/ZKM+6OOu9RRGJLvWwyNdzVfk=;
 b=nBy97eYO/NAc0GFSKuFFVHmbbvQjorJiZDb2NDWKDXHXTGl/DUFUl/Lxi//kEQOygz2JEBVxVvT4
   14KL6wEfbklBYHl1VWgr35iOjAA/ZKbj41GgSl/WaglznwxK6XK0NBTJm5lMrXaZozWnIcCT8YCO
   j2WULUaFaIjnKLtM9fu3oWMHirSu/PdlaftrqKSKyXlx86h4NFtu8C3FRIWyvMJRZng7XxomCLYr
   rYRIw+aIw1JTaoy41ZPwTes2kmm3ZyxEevi/WurzSEzXioSeiSFdeI3tEXKn5L76YDoPTfIjIRnf
   8wb2w5F8ykPu0qv4WirBfzBSLEKNMluI4Obnrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5KwhyB2ti05Guo8nK0/ZKM+6OOu9RRGJLvWwyNdzVfk=;
 b=MwkY1/gyPeuEGxFZ/XrDT0m1aa1xnK5vxACwxP19ApBqmkqj8mREQpqa5xMVpnZx5tLjlri4um5t
   lTL+HSvMIHMZidjGIHp+1rgwjYlxDzN7dhDuh9d9wW7/sVRpOTbZAxcDPrmbyGd6RAvbFZR8JpD7
   ZphEq3F9V/T93MZNmKloMM7D1mVLTDFZy+8UnOXUZuOtOnFPc7Yipx6xQU0w+t8jL7p16KH9csxD
   UXYQiZM2TdwT7E7d4y7l11EozCzw/T5tfMBZApk92zC/aZU2d6i3yHDp5wglh+ENH9alnKwKK+WN
   0EYuSylB2bFqouus573oKK5xinpCJPC2LFZN9g==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTB006M71EGBK90@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Apr 2023 09:37:28 +0000 (GMT)
Message-id: <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
Date: Tue, 18 Apr 2023 17:37:06 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-language: en-US
To: Christian Brauner <brauner@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Arnd Bergmann <arnd@kernel.org>,
 akpm <akpm@linux-foundation.org>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
In-reply-to: <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
X-Source-IP: 115.124.30.110
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10683
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 priorityscore=188 suspectscore=0 clxscore=60 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180083 domainage_hfrom=8769
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R961e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
 TI=SMTPD_---0VgPSzNt_1681810626;
X-ServerName: out30-110.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: iPJXkTYmTpIvO_1z5xteCpYmSGl84uHp
X-Proofpoint-ORIG-GUID: iPJXkTYmTpIvO_1z5xteCpYmSGl84uHp
Reporting-Meta:
 AAHh92B/Knefjx7Ln8UFstxbSEQsbMdscL7gGJGRC+7JdkF3JtSCvAi7fFsRUQHN
 9gdH6OJG/KpLVqbNQAqQOsFCPQzDadAEYA1b9lwOy62A9YziJ2QtuJp8xaM64DzN
 58ZxaYwW3fzCns9hEX93QLPaKRrXE+9I9cKc0bZkvV97gfK3JFkXaDZJXp3PNK7T
 dBznN8WnWavmEYX91NOvQNGdF1i+cIX4jpAv50G60JFhZCz4kxNhAJp4iSyWr3/V
 xdN+XSZ9jgriLfDQLSFW4f0Ts4ZZXS6QCk19xXz3ZfXcQCw6Zl/GmXaDoCUmP23d
 QlXgf7mZBoontShQ5k1HWPB8P3snW4nk6CDuLKqpRLMSmiYc2lGi0DHUZNctxVbh
 3gwKPvGiL0Jpzzj0aL6EGGreqH0vyzvMpMHObMEqe7K6vWii7+ud0IJ+N+ipzftY
 lQ0kNy+kAt3raesrbhIow96D4FqPiUZHpjI0owCfudoOYXwyEb5zT2cPSOuvG32K
 FX5s5jFUvmega46YeheoHHZH6AvXM1auaVshD7iaYHEr2Q==

Andrew picked ocfs2 patches into -mm tree before.

Thanks,
Joseph

On 4/18/23 5:17 PM, Christian Brauner wrote:
> 
> On Mon, 17 Apr 2023 22:56:24 +0200, Arnd Bergmann wrote:
>> On 32-bit architectures with KASAN_STACK enabled, the total stack usage
>> of the ocfs2_ioctl function grows beyond the warning limit:
>>
>> fs/ocfs2/ioctl.c: In function 'ocfs2_ioctl':
>> fs/ocfs2/ioctl.c:934:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]
>>
>> Move each of the variables into a basic block, and mark ocfs2_info_handle()
>> as noinline_for_stack, in order to have the variable share stack slots.
>>
>> [...]
> 
> Going by git log, ocfs2 patches don't go through a separate tree.
> So unless there are objections I'm taking this through fs.misc,
> 
> tree: git://git.kernel.org/pub/scm/linux/kernel/git/vfs/idmapping.git
> branch: fs.misc
> [1/1] ocfs2: reduce ioctl stack usage
>       commit: 85ef56bc2d65215f43ceb7377ca14a779468928d
> 
> Christian

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
