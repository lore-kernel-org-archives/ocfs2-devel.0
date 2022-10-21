Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB62C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 09:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Gw7jVQzXM1rVBmEzb8fB/ySePEJqZH+9kA60WEyi5H4=;
 b=1qLtOlVf+9zAPbEDS628fCBdyOmDZ4S84BtaEdAdYVMuBGTD9bClLBMdhEYgbM8l8+6zA/WtRc1E
   GrcPYKlzx2QxSvb543QF1V4CX/Hy4L/OApk/PsO1FYnboPrzcwwcG7e0ZpDyHNXtlvtsNTnP950M
   tPjbloduHv1WevKS6dupAU7ccInsTm/NAntLDtgJl1653tNPYlxAL9ervr3gounvaNVtvbS0hBtM
   t+a+a0VnfZSc4/lDZ98ULubEgge1WzJgTqGqtWLgJPR4Qy/aca9FmfcG8upGeZRD1bnK4P4L3r8m
   rsflGTV31Nw4Xx0/JxbvnLPL0H2K/9olh0m0Sw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Gw7jVQzXM1rVBmEzb8fB/ySePEJqZH+9kA60WEyi5H4=;
 b=c6sEscNBjJrAmjygcorWPoBD4gBqIoNoZzXufckb43Z+M/MdASabC6BX0YoR1FQgeQckCwIbF6jK
   0VGnM46GvjOHQLw9CV1sBcdSJS1Ef7BhRhWSsJTC4JAgt+QI9yBcwFibdZu3Aj+0ulHbq+p/YoES
   MU1khb6GyGZINgcihW8K65IfLqyh17XTwdrINnGs2PEcM/OvMA+/vl7mJV6uONUwJ2IJcyNjFNcO
   +CEBF+LghnrbG4P61M09rYbcv53lnTNlFhzPMtijgR0mz2tW3+up5iCxwIaN/7NL/+ixHCEvoAM2
   dD6CAbc9Bj48ZZBQtUQAzcmEtfwNBIbhZBNEFg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK3006AEJEYOO60@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 09:23:22 +0000 (GMT)
To: Luben Tuikov <luben.tuikov@amd.com>, Greg KH <gregkh@linuxfoundation.org>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com> <Y1IwLOUGayjT9p6d@kroah.com>
 <5efd73b0-d634-d34f-3d7a-13d674e40d04@amd.com> <Y1JV1wxf/7ERAMhl@kroah.com>
 <35e66c7c-ff25-efd3-cfbc-d06130687aa7@amd.com>
 <19689b9e-16d1-c6c5-4ee8-58885fbf8fb0@amd.com>
Message-id: <e8e21756-c5b8-9098-8fb6-8e381bbf3dd1@huawei.com>
Date: Fri, 21 Oct 2022 17:23:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <19689b9e-16d1-c6c5-4ee8-58885fbf8fb0@amd.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.255
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 clxscore=-54 mlxscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210054 domainage_hfrom=8319
Cc: chao@kernel.org, rafael@kernel.org, qemu-devel@nongnu.org, richard@nod.at,
 somlo@cmu.edu, mst@redhat.com, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, linux-f2fs-devel@lists.sourceforge.net,
 liushixin2@huawei.com, linux-mtd@lists.infradead.org,
 hsiangkao@linux.alibaba.com, alexander.deucher@amd.com, jaegeuk@kernel.org,
 huangjianan@oppo.com, linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
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
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga08-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Tc6N08Kb8MwKKl71CaToBKvIFunKBzkQ
X-Proofpoint-GUID: Tc6N08Kb8MwKKl71CaToBKvIFunKBzkQ
Reporting-Meta:
 AAFHorNevimhJsbtue9YNdptmprKDl/hymWXJCbQvv1/Y9eG7AE8JQl8WuWF+TYz
 JpmwiUbRRqqB1v38U0BXY5YhfZ4tOwoW7VZkTN5AIJCWtcbH5OUprIDJhExo113l
 gPPs8oFs9IG3SvUCVCny/bv87Vx6s0mE9OpKPT2pJvZCNu3otmkrIRKKBC2fKGya
 /VDNj0KvTVgehYvwW0o84p7chDac2NU+8QXXvCyhAgVTwysufLoE6Pn4yaxkqTmd
 G5vuYZdrB21pkQAmFULjWttwZfUbmshNc1g3ZR6j5SCwbUkfQ9Rbw2UvDQp4WRmi
 VsF47SR1ZQ/uDmjN9fj6PYhS25cLCrh2OLr0JaDJGTwOQ1A2P1S+p/rzL7R/JQTC
 mXZiskFVWhFaj9JTu4A8SCLnTreQwvhn1FfbUowndGNOc5JS88RFbHNjXdxWJh5J
 VUdKemNkkeKTnvIK9vD8AqXoWd09d8HnpjMj+uUVsW2miGVahCXiqxfeF7GJ+i7g
 suBZV2MHCGK2ADDFD24lrdd3ao/SJzMJXcC4JZv5SfPB


On 2022/10/21 16:41, Luben Tuikov wrote:
> On 2022-10-21 04:24, Luben Tuikov wrote:
>> On 2022-10-21 04:18, Greg KH wrote:
>>> On Fri, Oct 21, 2022 at 03:55:18AM -0400, Luben Tuikov wrote:
>>>> On 2022-10-21 01:37, Greg KH wrote:
>>>>> On Fri, Oct 21, 2022 at 01:29:31AM -0400, Luben Tuikov wrote:
>>>>>> On 2022-10-20 22:20, Yang Yingliang wrote:
>>>>>>> The previous discussion link:
>>>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F0db486eb-6927-927e-3629-958f8f211194%40huawei.com%2FT%2F&amp;data=05%7C01%7Cluben.tuikov%40amd.com%7Cd41da3fd6449492d01f808dab33cdb75%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638019371236833115%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=C%2Bj1THkHpzVGks5eqB%2Fm%2FPAkMRohR7CYvRnOCqUqdcM%3D&amp;reserved=0
>>>>>> The very first discussion on this was here:
>>>>>>
>>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Fdri-devel%2Fmsg368077.html&amp;data=05%7C01%7Cluben.tuikov%40amd.com%7Cd41da3fd6449492d01f808dab33cdb75%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638019371236833115%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=pSR10abmK8nAMvKSezqWC0SPUBL4qEwtCCizyIKW7Dc%3D&amp;reserved=0
>>>>>>
>>>>>> Please use this link, and not the that one up there you which quoted above,
>>>>>> and whose commit description is taken verbatim from the this link.
>>>>>>
>>>>>>> kset_register() is currently used in some places without calling
>>>>>>> kset_put() in error path, because the callers think it should be
>>>>>>> kset internal thing to do, but the driver core can not know what
>>>>>>> caller doing with that memory at times. The memory could be freed
>>>>>>> both in kset_put() and error path of caller, if it is called in
>>>>>>> kset_register().
>>>>>> As I explained in the link above, the reason there's
>>>>>> a memory leak is that one cannot call kset_register() without
>>>>>> the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
>>>>>> in this case, i.e. kset_register() fails with -EINVAL.
>>>>>>
>>>>>> Thus, the most common usage is something like this:
>>>>>>
>>>>>> 	kobj_set_name(&kset->kobj, format, ...);
>>>>>> 	kset->kobj.kset = parent_kset;
>>>>>> 	kset->kobj.ktype = ktype;
>>>>>> 	res = kset_register(kset);
>>>>>>
>>>>>> So, what is being leaked, is the memory allocated in kobj_set_name(),
>>>>>> by the common idiom shown above. This needs to be mentioned in
>>>>>> the documentation, at least, in case, in the future this is absolved
>>>>>> in kset_register() redesign, etc.
>>>>> Based on this, can kset_register() just clean up from itself when an
>>>>> error happens?  Ideally that would be the case, as the odds of a kset
>>>>> being embedded in a larger structure is probably slim, but we would have
>>>>> to search the tree to make sure.
>>>> Looking at kset_register(), we can add kset_put() in the error path,
>>>> when kobject_add_internal(&kset->kobj) fails.
>>>>
>>>> See the attached patch. It needs to be tested with the same error injection
>>>> as Yang has been doing.
>>>>
>>>> Now, struct kset is being embedded in larger structs--see amdgpu_discovery.c
>>>> starting at line 575. If you're on an AMD system, it gets you the tree
>>>> structure you'll see when you run "tree /sys/class/drm/card0/device/ip_discovery/".
>>>> That shouldn't be a problem though.
>>> Yes, that shouldn't be an issue as the kobject embedded in a kset is
>>> ONLY for that kset itself, the kset structure should not be controling
>>> the lifespan of the object it is embedded in, right?
>> Yes, and it doesn't. It only does a kobject_get(parent) and kobject_put(parent).
>> So that's fine and natural.
>>
>> Yang, do you want to try the patch in my previous email in this thread, since you've
>> got the error injection set up already?
> I spoke too soon. I believe you're onto something, because looking at the idiom:
>
> 	kobj_set_name(&kset->kobj, format, ...);
> 	kset->kobj.kset = parent_kset;
> 	kset->kobj.ktype = ktype;
> 	res = kset_register(kset);
>
> The ktype defines a release method, which frees the larger struct the kset is embedded in.
> And this would result in double free, for instance in the amdgpu_discovery.c code, if
> kset_put() is called after kset_register() fails, since we kzalloc the larger object
> just before and kfree it on error just after. Ideally, we'd only "revert" the actions
> done by kobj_set_name(), as there's some error recovery on create_dir() in kobject_add_internal().
>
> So, we cannot do this business with the kset_put() on error from kset_register(), after all.
> Not sure how this wasn't caught in Yang's testing--the kernel should've complained.
I have already tried the change that in your posted patch when I was 
debugging this issue
before sent these fixes, because it may lead double free in some cases, 
and I had mentioned
it in this mail:

https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/#m68eade1993859dfc6c3d14d35f988d35a32ef837

Thanks,
Yang
>
> Regards,
> Luben
>
> .

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
