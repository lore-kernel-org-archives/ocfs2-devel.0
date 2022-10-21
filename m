Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FDBC4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 07:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mepjgK+fj8A0eMWt9ZvdJaca+eJXaICjOQ31aLop9sM=;
 b=NafTQzn6xekCSD7aOS/p5pil1TsJRubtnE9n72xiXh3sZo5VPJW2SJHJVo5p0Dc9tHV10OoLc4Lg
   3ZDqJulDMQWTTpot+O7zMJLEf3dNN0W7/WkAAFYnC+8DIMpIY48z5yOaSzWrEyjl1BT00fSHNtUW
   1p8pK0x9G3j6jK6AC0rPDwAvMIBY+dgF5rJJrhSkEcqh9TvubQFUjFNY5+0kEzbKvjRv9ofhbodp
   Gc+2YyNu1cn/opvU8yOyB1QLzWr2k+1Jgh08ewe6p1cs3GvTDrqhaDmutWXxd+90Mmlp22hfUuzc
   tLh9RY34wM88TW2ad4MqiDVmxhoTWQi4mIlrmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mepjgK+fj8A0eMWt9ZvdJaca+eJXaICjOQ31aLop9sM=;
 b=HS3kDlFfmVHx5G5ct6Q2OdYfFA+JCfGAd35oR5sIqarxU8wusl2kzfF5UsYms/XTX0DKNn4ykaVP
   WvgV9Od87kEOFIvz2QyjdVTP+ci4gx9hsrR1/hwVQ8a3ig1/N+6fc/vRqvVe8jALQAUbzO3jqf7/
   P/O0tTk3yL2XTdax1bTi/uKz9prQ4LVDGG5UKLDCz/gOmfDFVp2kHLeEBWFycnwdrgltlINVWCOb
   Kj+gblm23RG4IZ3hGeAvsfWLeeHNw6ldCOKRvFnwRRBPfa0LXB6uQcY1rHATKjpQNmtl5FTqdNV5
   6GQWzsek0dWt+CW8Kp/ZI6x6IT17cABfu6TKyA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK300MFJDZXJGE0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 07:26:21 +0000 (GMT)
To: Luben Tuikov <luben.tuikov@amd.com>, <linux-kernel@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <linux-f2fs-devel@lists.sourceforge.net>,
 <linux-erofs@lists.ozlabs.org>, <ocfs2-devel@oss.oracle.com>,
 <linux-mtd@lists.infradead.org>, <amd-gfx@lists.freedesktop.org>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com>
Message-id: <2a99c52c-d29c-5f5c-57a8-9851018e7420@huawei.com>
Date: Fri, 21 Oct 2022 15:25:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 clxscore=-3 mlxlogscore=884 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210043 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, hsiangkao@linux.alibaba.com,
 rafael@kernel.org, jaegeuk@kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 00/11] fix memory leak while	kset_register()
 fails
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
From: Yang Yingliang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yang Yingliang <yangyingliang@huawei.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: MZfMqDLSaRoEPxPeNEnRqLoJC2iBM9jV
X-Proofpoint-GUID: MZfMqDLSaRoEPxPeNEnRqLoJC2iBM9jV
Reporting-Meta:
 AAF6ik5wP3qMs0PJ5oXw5GNlhF5mJJ4KlSj1vwCx5XKTaI8XySHzbjmc008daxcU
 4jK1Q+v15Krm9lovAyrABFjU1+RhICzTzYwRojaeTT6jOHZD/G4W0Bg4dQ5Qd396
 T88yE7hn3ol/TA96plKIfqACRPtn+BAjupQHdVmD7ubWuq1ib1rtwu5aoIbYwtIT
 b4ygZUX5yOs5nKMdgAtbOqzUI1d+nBCpEB5XwJmPi8sMSlqZc4N2UbVPJTT2V76h
 rg9dYZjQSebPnzWZSy6zoqxh4oxVsDjFPRenDWfWgLeNN5fg5VVDa6kHjhx0klCm
 Ve2rqNi9snWvDwYhVeEQGnGREA5egIyNzOeg/CAQZdfG9Vj3ICo1hUjnkiJaELNz
 8bT2sn8sEB6DOZI3qPdqcWeAdgRExsFBEnardeLzC9c2zSQT1EaSes5TtTBB1N8T
 /H1mohHjT6wK1HoKfogITSfKnMXB+EZrTvYtvcOWffNU5BW9UozmQNI2u7dJXBlI
 Fj8H4j55xAiJmN0yyyAxg46Chpw5JKG/pIj7ypSA5pc=

Hi,

On 2022/10/21 13:29, Luben Tuikov wrote:
> On 2022-10-20 22:20, Yang Yingliang wrote:
>> The previous discussion link:
>> https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/
> The very first discussion on this was here:
>
> https://www.spinics.net/lists/dri-devel/msg368077.html
>
> Please use this link, and not the that one up there you which quoted above,
> and whose commit description is taken verbatim from the this link.
I found this leaks in 
bus_register()/class_register()/kset_create_and_add() at first, and describe
the reason in these patches which is using kobject_set_name() 
description, here is the patches:

https://lore.kernel.org/lkml/20221017014957.156645-1-yangyingliang@huawei.com/T/
https://lore.kernel.org/lkml/20221017031335.1845383-1-yangyingliang@huawei.com/
https://lore.kernel.org/lkml/Y0zfPKAgQSrYZg5o@kroah.com/T/

And then I found other subsystem also have this problem, so posted the 
fix patches for them
(including qemu_fw_cfg/f2fs/erofs/ocfs2/amdgpu_discovery):

https://www.mail-archive.com/qemu-devel@nongnu.org/msg915553.html
https://lore.kernel.org/linux-f2fs-devel/7908686b-9a7c-b754-d312-d689fc28366e@kernel.org/T/#t
https://lore.kernel.org/linux-erofs/20221018073947.693206-1-yangyingliang@huawei.com/
https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/

https://www.spinics.net/lists/dri-devel/msg368092.html
In the amdgpu_discovery patch, I sent a old one which using wrong 
description and you pointer out,
and then I send a v2.

And then the maintainer of ocfs2 has different thought about this, so we 
had a discussion in the link
that I gave out, and Greg suggested me to update kset_register() 
documentation and then put the fix
patches together in one series, so I sent this patchset and use the link.

Thanks,
Yang

>
>> kset_register() is currently used in some places without calling
>> kset_put() in error path, because the callers think it should be
>> kset internal thing to do, but the driver core can not know what
>> caller doing with that memory at times. The memory could be freed
>> both in kset_put() and error path of caller, if it is called in
>> kset_register().
> As I explained in the link above, the reason there's
> a memory leak is that one cannot call kset_register() without
> the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
> in this case, i.e. kset_register() fails with -EINVAL.
>
> Thus, the most common usage is something like this:
>
> 	kobj_set_name(&kset->kobj, format, ...);
> 	kset->kobj.kset = parent_kset;
> 	kset->kobj.ktype = ktype;
> 	res = kset_register(kset);
>
> So, what is being leaked, is the memory allocated in kobj_set_name(),
> by the common idiom shown above. This needs to be mentioned in
> the documentation, at least, in case, in the future this is absolved
> in kset_register() redesign, etc.
>
> Regards,
> Luben
>
>> So make the function documentation more explicit about calling
>> kset_put() in the error path of caller first, so that people
>> have a chance to know what to do here, then fixes this leaks
>> by calling kset_put() from callers.
>>
>> Liu Shixin (1):
>>    ubifs: Fix memory leak in ubifs_sysfs_init()
>>
>> Yang Yingliang (10):
>>    kset: fix documentation for kset_register()
>>    kset: add null pointer check in kset_put()
>>    bus: fix possible memory leak in bus_register()
>>    kobject: fix possible memory leak in kset_create_and_add()
>>    class: fix possible memory leak in __class_register()
>>    firmware: qemu_fw_cfg: fix possible memory leak in
>>      fw_cfg_build_symlink()
>>    f2fs: fix possible memory leak in f2fs_init_sysfs()
>>    erofs: fix possible memory leak in erofs_init_sysfs()
>>    ocfs2: possible memory leak in mlog_sys_init()
>>    drm/amdgpu/discovery: fix possible memory leak
>>
>>   drivers/base/bus.c                            | 4 +++-
>>   drivers/base/class.c                          | 6 ++++++
>>   drivers/firmware/qemu_fw_cfg.c                | 2 +-
>>   drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 +++--
>>   fs/erofs/sysfs.c                              | 4 +++-
>>   fs/f2fs/sysfs.c                               | 4 +++-
>>   fs/ocfs2/cluster/masklog.c                    | 7 ++++++-
>>   fs/ubifs/sysfs.c                              | 2 ++
>>   include/linux/kobject.h                       | 3 ++-
>>   lib/kobject.c                                 | 5 ++++-
>>   10 files changed, 33 insertions(+), 9 deletions(-)
>>
> .

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
