Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F7BC67871
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 Oct 2022 02:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zpeN5W3vwjPsGHiJDq9vtJg2lnP7gqYIZ9oxr/ypkio=;
 b=G9Bwd45OX/rvWs6itNA9IbdhCw6r2oLCiS8zEvnhVWwQX+zTPQnNFBDlNbcjTg3052hybmjj7KQu
   IrX2O3WOU0iI1rjaP/nTce6YPpQ35+ZFZkAal0dHj3Eg7pVsVHovWb+YKVblsvCTA9Dh3e/XnzfK
   UabG1WYkrR/1uUxSiO+961DkukvPEfya2O+WTWvW1I7zC1OrWr8By+kYHVXSQ/VsyyyB71mTVves
   oE1MdmV8FwoMnv2SK2Bl/I80t5woMCJcuFtODBHq0rOP8AISju2gluRTuBRiLCh4QBQOz9I7Aq8/
   yXxT5i/f2P80e/OixGSwMLWQKaqEIU8DAiBfjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zpeN5W3vwjPsGHiJDq9vtJg2lnP7gqYIZ9oxr/ypkio=;
 b=f7lz/0EYQSzMm4AHtWMoklUlBZv1tGo5jZJ6HwKZmvYTstcX8rM1ziBGesJRfW7LLGhzW5uHjQju
   uh+IsWJ++Cvj/vvuLJ4meY7jAU+s9PA0MG8C6Sv4PL0/X3DgeijxfBAGTnvEUQeOLTE1JWufGhAk
   Rm5OZbFbmF0EfdUugZKQ3iUqiFsf+raSonFqTzRvKTAMy4YbuczJ3Tv1YbWoWaquywAxo+/8X8p3
   lkcGqLBdhNWgYvO8RdjoKC+jaNTV75plI0snEqrkFBo2spVbWdlQk1S4Km4lRl9oOPH/+ITo4pEq
   5v+RifropCJfKVayZw9PQf7C4rH8QXAe1eNNkg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RKA0068BEC7DZ10@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 25 Oct 2022 02:16:55 +0000 (GMT)
To: Luben Tuikov <luben.tuikov@amd.com>, <linux-kernel@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <linux-f2fs-devel@lists.sourceforge.net>,
 <linux-erofs@lists.ozlabs.org>, <ocfs2-devel@oss.oracle.com>,
 <linux-mtd@lists.infradead.org>, <amd-gfx@lists.freedesktop.org>
References: <20221024121910.1169801-1-yangyingliang@huawei.com>
 <176ae1a1-9240-eef8-04e9-000d47646f4a@amd.com>
 <dcb8b35a-7d0d-cc00-41e3-6e66837c506f@amd.com>
Message-id: <26c8c125-453c-af32-a66c-2a37e964ce19@huawei.com>
Date: Tue, 25 Oct 2022 10:16:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <dcb8b35a-7d0d-cc00-41e3-6e66837c506f@amd.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.255
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10510
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=-45 mlxlogscore=999 malwarescore=0 bulkscore=0
 adultscore=0 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250012 domainage_hfrom=8323
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, hsiangkao@linux.alibaba.com,
 rafael@kernel.org, jaegeuk@kernel.org
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
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga08-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: XV_RDilEW7aJNlsO9Ks6pHANM1ktWaA1
X-Proofpoint-ORIG-GUID: XV_RDilEW7aJNlsO9Ks6pHANM1ktWaA1
Reporting-Meta:
 AAGiQlv6KKDjL1PN60CJ/6fP07nvD0XBbwudDi1oXROTcMKKpxPKqCtj8UGoMVt4
 jteljI4UBfyT1O6DLVft5nLXg+WnpFXfzWpLUNw3Sll87kQFHQf2WPejJ2vEq66t
 YgsK6pKlz/WrK3QvknHliDsoQGl10ra4rFMyg+FaoN8wdIx0VV1YoFm+rFT12Uqv
 pNgqhkBi+bDzHBtaNxY7S6Aa2c5rIdhMB2CYPZ9r9b3B39bXzr/oOl3fF+Gip5Cy
 r+wmTDi/eJEA7FudnACUoZLws1dBu0Yifechx+KYy1759ZToH+EZ/nLi68hRXhBd
 OR8to0aXvQUrNAnrbM8UC4Zxarif7TmZuuR2VEdOi0mOeKBD66ow9Fsl9S6rCWPH
 UVWBI7HDFE26WYEXocHS+Z83bhCK/oa7OHreAu9uPN33ZWUNQ1BMhm1lpKkbSdXP
 Sxsq6vwMsNexaZB/ZiFbVQ0C49eDhTQizx4w7o2cpXFWcGsJ39V0ipd6VxcD3LOe
 1w8EIEwiU5mVI+weIIquPUUvRvq00hIVotJkfgA2

Hi,

On 2022/10/25 5:25, Luben Tuikov wrote:
> On 2022-10-24 17:06, Luben Tuikov wrote:
>> On 2022-10-24 08:19, Yang Yingliang wrote:
>>> Inject fault while loading module, kset_register() may fail.
>>> If it fails, the name allocated by kobject_set_name() which
>>> is called before kset_register() is leaked, because refcount
>>> of kobject is hold in kset_init().
>> "is hold" --> "was set".
>>
>> Also, I'd say "which must be called" instead of "is", since
>> we cannot register kobj/kset without a name--the kobj code crashes,
>> and we want to make this clear. IOW, a novice user may wonder
>> where "is" it called, as opposed to learning that they "must"
>> call it to allocate/set a name, before calling kset_register().
>>
>> So, I'd say this:
>>
>> "If it fails, the name allocated by kobject_set_name() which must
>>   be called before a call to kset_regsiter() is leaked, since
>>   refcount of kobj was set in kset_init()."
> Actually, to be a bit more clear:
>
> "If kset_register() fails, the name allocated by kobject_set_name(),
>   namely kset.kobj.name, which must be called before a call to kset_register(),
>   may be leaked, if the caller doesn't explicitly free it, say by calling kset_put().
>
>   To mitigate this, we free the name in kset_register() when an error is encountered,
>   i.e. when kset_register() returns an error."
Thanks for you suggestion.
>
>>> As a kset may be embedded in a larger structure which needs
>>> be freed in release() function or error path in callers, we
>> Drop "As", start with "A kset". "which needs _to_ be".
>> Also please specify that the release is part of the ktype,
>> like this:
>>
>> "A kset may be embedded in a larger structure which needs to be
>>   freed in ktype.release() or error path in callers, we ..."
>>
>>> can not call kset_put() in kset_register(), or it will cause
>>> double free, so just call kfree_const() to free the name and
>>> set it to NULL.
>>>
>>> With this fix, the callers don't need to care about the name
>>> freeing and call an extra kset_put() if kset_register() fails.
>> This is unclear because you're *missing* a verb:
>> "and call an extra kset_put()".
>> Please add the proper verb _between_ "and call", something like,
>>
>> "With this fix, the callers don't need to care about freeing
>>   the name of the kset, and _can_ call kset_put() if kset_register() fails."
I was mean
the callers don't need to care about freeing the name of the kset and
the callers don't need to care about calling kset_put()

Thanks,
Yang
>>
>> Choose a proper verb here: can, should, cannot, should not, etc.
>>
>> We can do this because you set "kset.kobj.name to NULL, and this
>> is checked for in kobject_cleanup(). We just need to stipulate
>> whether they should/shouldn't have to call kset_put(), or can free the kset
>> and/or the embedding object themselves. This really depends
>> on how we want kset_register() to behave in the future, and on
>> user's own ktype.release implementation...
> Forgot "may", "may not".
>
> So, do we want to say "may call kset_put()", like:
>
> "With this fix, the callers need not care about freeing
>   the name of the kset, and _may_ call kset_put() if kset_register() fails."
>
> Or do we want to say "should" or even "must"--it really depends on
> what else is (would be) going on in kobj registration.
>
> Although, the user may have additional work to be done in the ktype.release()
> callback for the embedding object. It would be good to give them the freedom,
> i.e. "may", to call kset_put(). If that's not the case, this must be explicitly
> stipulated with the proper verb.
>
> Regards,
> Luben
>
> .

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
