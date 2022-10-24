Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540F0ECAAA1
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Oct 2022 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UvufVaP0rClNA5RT69XZpg2eL7/R7Ery//J3oi7z3nA=;
 b=CgWxHdhZoUSRBp+pHjlIBE+tup3W6P4xBxPqPB3DjbUhS/QcBdQ96DSrDeWAYTHkHV0de5m6NjQE
   OGm0MFpUix1oun34CIctgqFLXB/bhnVah5JVu+ALB1X3Z/iSpjoLcJzkoWFaqfLUoz10BYyR2lyQ
   v+tXr6LQC6RQeLWmt5roV1Ss/l6aqgywPPDWFkoCY2H309cUsbbXz29Hxf+yCV/OKboNYewMsyQF
   v8k6B7QTJhrD7Xe9OXgAqI3/ej6Cr9hucWF6V2V1B9P6exFvOQ6yt8hpHaopjIl9HMPJpqeJ866X
   P3WXnyIwFBlUwDiTY4KtebXqtVBbXsyRYX+NyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UvufVaP0rClNA5RT69XZpg2eL7/R7Ery//J3oi7z3nA=;
 b=Lo2oRLA9enjQGM8rEXohsERYQRnxrQT9X7L7+XLsKOlVODMG6QjbCcOEr2g3z1FPCxzJ3hf4F79U
   d7zmBrPVF+bDcw3vZQvk7GN4yci/lG9dHCtidFQvUwDgMQID+z+8U09UQ8jBm0m6bH0SNmDyx4YE
   3wgF1dC3HAfTMc8siH7bQOgvfAOOLRKi7enX1uTDd4EWw3nXtMW1Dh2LMjxFBwotze83pKwQPPMT
   J5TBjBILuBTtsAUvrvMrdiNgK9JUNzRUMgHS3xHgcVSQBlptav6oluOW2rr76WSuWgyz2xsg6y46
   FGyXcO04BupU/hm0axSQgnN+6pBNkrl4XyYygQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK9002DXJHILF90@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Oct 2022 15:10:30 +0000 (GMT)
To: Greg KH <gregkh@linuxfoundation.org>
References: <20221024121910.1169801-1-yangyingliang@huawei.com>
 <Y1aYuLmlXBRvMP1Z@kroah.com> <8281fc72-948a-162d-6e5f-a9fe29d8ee46@huawei.com>
 <Y1am4mjS+obAbUTJ@kroah.com>
Message-id: <87e4e75b-a26e-6b4b-4799-c56c0b8891c0@huawei.com>
Date: Mon, 24 Oct 2022 23:10:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <Y1am4mjS+obAbUTJ@kroah.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.255
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10510
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 bulkscore=0 adultscore=0
 spamscore=0 clxscore=-54 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240093 domainage_hfrom=8322
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com,
 yangyingliang@huawei.com, hsiangkao@linux.alibaba.com, somlo@cmu.edu,
 chao@kernel.org, jaegeuk@kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, alexander.deucher@amd.com,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] kset: fix memory leak when
 kset_register() returns error
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
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga08-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: VVn7UIfwCeUyO2HX-MEWJnNX1XwRSNXS
X-Proofpoint-ORIG-GUID: VVn7UIfwCeUyO2HX-MEWJnNX1XwRSNXS
Reporting-Meta:
 AAE5vYm5LyXIXb2R51lje3dt1kIG61Kd0FkyOFUtxS371sg94+DPYUnLT3XuPzk8
 ggboiez+D3lm+M9YAXaUEm8SlTQhfoHzUld47gdP3Z3LAGWc76yhmeL3hKYHlMSy
 W4+pDUDMAAmvsWMUlHywMB6v4JN22F9iQ+73xT8/9XUgG09F+vY1zYu+nUs3K5Rv
 3WVSaxgme2kX+B3hoTRGw8TAMHJ/oJHydbeF2Qg9fswWDsVdjdHwPGT9jrIG7rwm
 z5nRockwAyp8wXNTYo6fHsPCjM6JLWUuq+vUp2l0ZbG9vWnUYMgMqVMI1qGXM2hn
 slQgF6GV7Qk7ROBnxb6J2RI42Lh+tqZX5YddGMeXkWJvDk5ejEM2e/qXxPBkDYii
 1UEtjF7dPWiph/z4S/fJvMMmI4SQjf0/aOMBoP834aDG8rrOauSUNUb/DHyq0dVY
 EW3MtB83tF7GJV0Zp9qRp7adV1lAOrNHtMF39djdzs5Rts3F9dKA6MVcayc477RN
 UQHre2nPEWjnRXAmsKen77yBMJgeWtse61ZvadlByA==


On 2022/10/24 22:53, Greg KH wrote:
> On Mon, Oct 24, 2022 at 10:39:44PM +0800, Yang Yingliang wrote:
>> On 2022/10/24 21:52, Greg KH wrote:
>>> On Mon, Oct 24, 2022 at 08:19:10PM +0800, Yang Yingliang wrote:
>>>> Inject fault while loading module, kset_register() may fail.
>>>> If it fails, the name allocated by kobject_set_name() which
>>>> is called before kset_register() is leaked, because refcount
>>>> of kobject is hold in kset_init().
>>>>
>>>> As a kset may be embedded in a larger structure which needs
>>>> be freed in release() function or error path in callers, we
>>>> can not call kset_put() in kset_register(), or it will cause
>>>> double free, so just call kfree_const() to free the name and
>>>> set it to NULL.
>>>>
>>>> With this fix, the callers don't need to care about the name
>>>> freeing and call an extra kset_put() if kset_register() fails.
>>>>
>>>> Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
>>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>>>> ---
>>>> v1 -> v2:
>>>>     Free name inside of kset_register() instead of calling kset_put()
>>>>     in drivers.
>>>> ---
>>>>    lib/kobject.c | 8 +++++++-
>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/lib/kobject.c b/lib/kobject.c
>>>> index a0b2dbfcfa23..3409a89c81e5 100644
>>>> --- a/lib/kobject.c
>>>> +++ b/lib/kobject.c
>>>> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>>>>    /**
>>>>     * kset_register() - Initialize and add a kset.
>>>>     * @k: kset.
>>>> + *
>>>> + * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
>>>> + * which is called before kset_register() in caller need be freed.
>>> This comment doesn't make any sense anymore.  No caller needs to worry
>>> about this, right?
>> With this fix, the name is freed inside of kset_register(), it can not be
>> accessed,
> Agreed.
>
>> if it allocated dynamically, but callers don't know this if no comment here,
>> they may use it in error path (something like to print error message with
>> it),
>> so how about comment like this to tell callers not to use the name:
>>
>> NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
>> is freed, it can not be used any more.
> Sure, that's a better way to word it.
>
>>>>     */
>>>>    int kset_register(struct kset *k)
>>>>    {
>>>> @@ -844,8 +847,11 @@ int kset_register(struct kset *k)
>>>>    	kset_init(k);
>>>>    	err = kobject_add_internal(&k->kobj);
>>>> -	if (err)
>>>> +	if (err) {
>>>> +		kfree_const(k->kobj.name);
>>>> +		k->kobj.name = NULL;
>>> Why are you setting the name here to NULL?
>> I set it to NULL to avoid accessing bad pointer in callers,
>> if callers use it in error path, current callers won't use this
>> name pointer in error path, so we can remove this assignment?
> Ah, I didn't think about using it on error paths.  Ideally that would
> never happen, but that's good to set just to make it obvious.  How about
> adding a small comment here saying why you are setting it so we all
> remember it in 5 years when we look at the code again.
OK, I can add it in v3.

Thanks,
Yang
>
> thanks,
>
> greg k-h
> .

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
