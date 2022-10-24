Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE15ECAAA1
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Oct 2022 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EtTChZP17fRR9Xqu1bCqnJ+4WaojBukPEnqQho/9nfQ=;
 b=k0RSDpq2UvF+kfSayyo8qlZecmhLNuZTfs6HSFoqKvGQJfYtzTeZgs3BuT/SC7Co7ANH3ynMAURf
   CJGJZ/FED4ir1Q57iydeKwg19sDkMiVHab3Ogo2vdC3RqskvRl/J6084sVNAKiisZMVQp7NcM2Kf
   w1rQ0z0Y/VBu3a3bPFS3rSYpcK481rKc3b+1piuG2QWxviwBVouSBSft0OXCWzOgRVwAuGzApH8x
   22418QbFAcpi90rGMr5zDi97O9yu3FAc1XD2HIyO8/FYGoalCdo3LJQTW/CgU+Gik/YqDtmv2qsa
   cc4NIYfoQ1k5RpP//y1eVF3gY1tjybLHhjGXQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EtTChZP17fRR9Xqu1bCqnJ+4WaojBukPEnqQho/9nfQ=;
 b=RFtTQtc4trcktpyaOdLho0TssZ5tfgTD5ZfbxuoG3YHAsYhCzv9yDyHWJLtebOShOit92ipkfPBP
   V1Ex3jE0NRNmTnnOEYNRi+MDo8oCsBfJPEk7xB17iIG+YeoLzhRSVaakgnG6029W+d/2xu2QP7pT
   NJJU/REEzyRZthRyTEYwoUI6yNQ3KrleLz4pLJVX8VlPPP2kAcr66nL7+2Z6IOHAGNaYtQ+u4zZD
   zm2VubFG+ltY3AsjEqXNQX35eHqqOSQlmxeqlxT5iDtRWJn0jHLisLl72/Z1VSho2rANVx3U2T48
   AourDmS61Of8+pbwzJZSMwxiwcdBe6TJHcPN+A==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK900241INZLF80@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Oct 2022 14:52:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666623153; bh=iIf7CBp4DRtS4RK5w27tn1+7LfTAdJA8NimWQF9sSvg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=0R1tizG1JTD1VZMfei9eZUwBceJMo27F3IPhrwxgizVbdIXR/VebztKIjUAfm+TJ2
 cpiPAbSdylVk4YR/PmDNZIIZzoMbWnp7XnOykqA3Po0XqNtgjvxOXuMeqXyiEX1VR+
 i+cMHZA9GYInHS3HEvmT7UEBSkL+YkXi0BemMqzI=
Date: Mon, 24 Oct 2022 16:53:22 +0200
To: Yang Yingliang <yangyingliang@huawei.com>
Message-id: <Y1am4mjS+obAbUTJ@kroah.com>
References: <20221024121910.1169801-1-yangyingliang@huawei.com>
 <Y1aYuLmlXBRvMP1Z@kroah.com> <8281fc72-948a-162d-6e5f-a9fe29d8ee46@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <8281fc72-948a-162d-6e5f-a9fe29d8ee46@huawei.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10510
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=639
 adultscore=0 clxscore=224 suspectscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240091
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, somlo@cmu.edu, chao@kernel.org,
 jaegeuk@kernel.org, linux-kernel@vger.kernel.org,
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: f1DLm87A-6n-IL2j7VFvIZGxiWNZU2gZ
X-Proofpoint-ORIG-GUID: f1DLm87A-6n-IL2j7VFvIZGxiWNZU2gZ
Reporting-Meta:
 AAE6cxYTIoozDZcuy6sg4SFwdM4qoPKmxIRcU7EJpaJhZzlou10r9sgOizjg8OUL
 IklgzdAW/2el2R/BHwhMH0cqA0lA+C+m8NCSoY/R6kPTsb1CM2La/gf9WcktG90l
 69cSmmS1Pev4WvCQJxg2oqc6Ig7qwhWagv1FtJU2YAMeWUogSih9IUxCQKzFLcgh
 qvxL6kLF1QcETOyeWfH6HmyyCtrBKH2Y7LHeJdC0B+BRh2sE+qDKDBJK2AhKez5P
 2Gl8HMhvO+rf7glcqhL1jBAgiNmdBH7sf9JKHtNpeQpcFk4yI1BrtuH65h83mL11
 VgZC7eBZ6Bay5RIp+8+3pdAgTs/l0i2nOw9//VTiHC5276l6sSabb+LwZ35qpb4p
 59j6boTRgeQIeaHSlca5Xd4vMDKyNrX/4OnhotyDC6N2J+KB+TXP26fBLYxCsjfT
 FTpkiVA24hIq9mbiihDRwwNY1gEsQErWIFhdFDR1MLGFL61uDd4xc9pZpA+D7oUx
 VOSXs6JF+/iaTDN6DOpEmhImci9Jsr/TZmybI3jM

On Mon, Oct 24, 2022 at 10:39:44PM +0800, Yang Yingliang wrote:
> 
> On 2022/10/24 21:52, Greg KH wrote:
> > On Mon, Oct 24, 2022 at 08:19:10PM +0800, Yang Yingliang wrote:
> > > Inject fault while loading module, kset_register() may fail.
> > > If it fails, the name allocated by kobject_set_name() which
> > > is called before kset_register() is leaked, because refcount
> > > of kobject is hold in kset_init().
> > > 
> > > As a kset may be embedded in a larger structure which needs
> > > be freed in release() function or error path in callers, we
> > > can not call kset_put() in kset_register(), or it will cause
> > > double free, so just call kfree_const() to free the name and
> > > set it to NULL.
> > > 
> > > With this fix, the callers don't need to care about the name
> > > freeing and call an extra kset_put() if kset_register() fails.
> > > 
> > > Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > ---
> > > v1 -> v2:
> > >    Free name inside of kset_register() instead of calling kset_put()
> > >    in drivers.
> > > ---
> > >   lib/kobject.c | 8 +++++++-
> > >   1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/kobject.c b/lib/kobject.c
> > > index a0b2dbfcfa23..3409a89c81e5 100644
> > > --- a/lib/kobject.c
> > > +++ b/lib/kobject.c
> > > @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
> > >   /**
> > >    * kset_register() - Initialize and add a kset.
> > >    * @k: kset.
> > > + *
> > > + * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
> > > + * which is called before kset_register() in caller need be freed.
> > This comment doesn't make any sense anymore.  No caller needs to worry
> > about this, right?
> With this fix, the name is freed inside of kset_register(), it can not be
> accessed,

Agreed.

> if it allocated dynamically, but callers don't know this if no comment here,
> they may use it in error path (something like to print error message with
> it),
> so how about comment like this to tell callers not to use the name:
> 
> NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
> is freed, it can not be used any more.

Sure, that's a better way to word it.

> > >    */
> > >   int kset_register(struct kset *k)
> > >   {
> > > @@ -844,8 +847,11 @@ int kset_register(struct kset *k)
> > >   	kset_init(k);
> > >   	err = kobject_add_internal(&k->kobj);
> > > -	if (err)
> > > +	if (err) {
> > > +		kfree_const(k->kobj.name);
> > > +		k->kobj.name = NULL;
> > Why are you setting the name here to NULL?
> I set it to NULL to avoid accessing bad pointer in callers,
> if callers use it in error path, current callers won't use this
> name pointer in error path, so we can remove this assignment?

Ah, I didn't think about using it on error paths.  Ideally that would
never happen, but that's good to set just to make it obvious.  How about
adding a small comment here saying why you are setting it so we all
remember it in 5 years when we look at the code again.

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
