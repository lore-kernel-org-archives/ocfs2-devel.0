Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46AA4C43219
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 08:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1oRfXXQdXr343soAjFM4jvSbABUBWix21rPCS4MUXc4=;
 b=pbQbItcj2SuzyXHV5PL9E+zZzR7CzvbWczYsGvJL36UMWLuzGzdvgm7xovOG6gNDgajgF6W/0jBg
   KYtqYNDimzh/MItPf3U8o2cNz6lln+TP0qs/7lM2zCp8ATIdEx/SAOsyHLCmbv1kjIItiAQOs5w1
   rBUyC6pg18h1XrafwMlCOPPg8g3XxUb3xYEZWKC4wMz2Wqjty8ydfgxOGGIEDW0AuCUEc/tgToWP
   jSAQxVbKIoc4lgm62lj9euosJetCnDx2oGjgHrsVfm7oh9QfFLQ/2pJublsMdSvuix4fjobqch0o
   C3tHkamxtNEHpNQVprA3/5j603sF6mROAdTTnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1oRfXXQdXr343soAjFM4jvSbABUBWix21rPCS4MUXc4=;
 b=WuZR1QXWPrk9/tNIo/U9hmS4Oa27FO92LO172QVET+2EgdoYmWa5Wp+oUfmF3Y4FUZfY40ihLLKQ
   tZStzp0lNe0gR0XHSbmlTT31WginftJkRkmgyY2orGIzFkqaIdk/x1xcVUAfb1HByR2m27Ub8uZd
   cNDn/TcmfKaR7e5h9jqligeArGqTAwXme41ZtgfQiw9Ewwwg7O2LB6SOe1wO2r5WYoRgblwcWHAl
   7yqlB+0/mVcHjsAgnARGQI4b0Lu2ujCdPIgu51In1/1YTrkskH++fACnjiWC5i6CK4L9y7biZ0Ol
   4Tfx3hSR82jDDgppOYpuMGfwTrn1fJe6N7Vucg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK300IQ0FU72HE0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 08:06:07 +0000 (GMT)
To: Luben Tuikov <luben.tuikov@amd.com>, <linux-kernel@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <linux-f2fs-devel@lists.sourceforge.net>,
 <linux-erofs@lists.ozlabs.org>, <ocfs2-devel@oss.oracle.com>,
 <linux-mtd@lists.infradead.org>, <amd-gfx@lists.freedesktop.org>,
 <gregkh@linuxfoundation.org>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <20221021022102.2231464-2-yangyingliang@huawei.com>
 <eb0f1459-7980-4a7b-58f9-652eeccc357e@amd.com>
Message-id: <10d887c4-7db0-8958-f661-bd52e6c8b4af@huawei.com>
Date: Fri, 21 Oct 2022 16:05:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <eb0f1459-7980-4a7b-58f9-652eeccc357e@amd.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=268 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=98 adultscore=0
 phishscore=0 mlxlogscore=799 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210047 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, mst@redhat.com, richard@nod.at, somlo@cmu.edu,
 chao@kernel.org, huangjianan@oppo.com, liushixin2@huawei.com,
 jaegeuk@kernel.org, rafael@kernel.org, hsiangkao@linux.alibaba.com
Subject: Re: [Ocfs2-devel] [PATCH 01/11] kset: fix documentation for
	kset_register()
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
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 2fR-GyGXLQHBq6exMQc5V_Cq8W4w2KNJ
X-Proofpoint-GUID: 2fR-GyGXLQHBq6exMQc5V_Cq8W4w2KNJ
Reporting-Meta:
 AAG5GdhD6Fj013tkUCgQ3TQRFcGe1CVg1LBmxKSpG0kCztytiTeFl0KKukGiJb+Y
 YQpkWIbdEC9C0NWw0Pqh7cmG291MV5+1mAr5LH+7bvWTLPnyIYn3rmd1I7EDjZlV
 wpRq+tGvBuctl0qg7KRfvU6tPYHbNkzPe+QI2Nm2meXnHK8gbYiph+oc2KttQjCv
 TNw7BcbRimhtbEraZFF71+7TS9I62aOc45VsyWYvP3EQ2/cvr4hSvQN0sVP1nhLZ
 WQJWHdnajkriDUSsQa8USKp1Ux/F6xT4BAwzQRCqt8Q/vkkqZw/+49dfCygnOfSL
 BJqIrsP1wmJRw9pXQ4MzaJkQb3QGYC+88dPj1+9AJwIex1IcaN2y9dq2hr7EDNHY
 lOh3HK0NVJfKIeZJRHi/o8yqUk2eeQp4MSSxzaU+/OtZlkfgPXAqu01DMGo1YYWM
 NcLdXn7drTWalsY+HABjN8CWn2a6z8IzbAYS86jZ141w/oAVIIXkOMCT/vOcV9KR
 wWJyLKrbFEwAI1+fbCz7K6Na2rW/kvTpLr4U6fKzLOc=


On 2022/10/21 13:34, Luben Tuikov wrote:
> On 2022-10-20 22:20, Yang Yingliang wrote:
>> kset_register() is currently used in some places without calling
>> kset_put() in error path, because the callers think it should be
>> kset internal thing to do, but the driver core can not know what
>> caller doing with that memory at times. The memory could be freed
>> both in kset_put() and error path of caller, if it is called in
>> kset_register().
>>
>> So make the function documentation more explicit about calling
>> kset_put() in the error path of caller.
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   lib/kobject.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index a0b2dbfcfa23..6da04353d974 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>>   /**
>>    * kset_register() - Initialize and add a kset.
>>    * @k: kset.
>> + *
>> + * If this function returns an error, kset_put() must be called to
>> + * properly clean up the memory associated with the object.
>>    */
> And I'd continue the sentence, with " ... with the object,
> for instance the memory for the kset.kobj.name when kobj_set_name(&kset.kobj, format, ...)
> was called before calling kset_register()."
kobject_cleanup() not only frees name, but aslo calls ->release() to 
free another resources.
>
> This makes it clear what we want to make sure is freed, in case of an early error
> from kset_register().

How about like this:

If this function returns an error, kset_put() must be called to clean up the name of
kset object and other memory associated with the object.

>
> Regards,
> Luben
>
>>   int kset_register(struct kset *k)
>>   {
> .

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
