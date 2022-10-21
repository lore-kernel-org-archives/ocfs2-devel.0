Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95CDC433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 08:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d0JlSwEf8zNE0BXvTSRGUyoUHWpbzjx8BhTw7G18Ovw=;
 b=iYs2SSTs9HRVmYW9X/7Gr3HreIqKlgqOQ5Ec6VolWGXoeYjKx1Ns6jYgroAZKO/gDbteK4wrkF82
   SE7VS0QxSK8D5jk2hb5Fz0rtEZSrZs1XJGQxn4Q4coAalDtM+PMDzqL/94l00q37MxvwRF7Wr/oX
   rpVxCI/VchuP8HrTLqeI8iPAiq2sV48gY9EWdE55uH/WeWxg5NUKgN0T07uOYC+Dv2oyOBe0uqSd
   Tf8Pdz3lb/t4/WBnf/MlTQwSqrKZmUu+xmh4Vwv656AaDhlEvzeLeUM89Jjg5GIt4H+arrbh7fTE
   8p0Gk+iVwcTA+k7+h5sPZ8ga4F5ADRIe1GP5ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=d0JlSwEf8zNE0BXvTSRGUyoUHWpbzjx8BhTw7G18Ovw=;
 b=Vbtx0xDSEnJd4jXkyI1VZ0kPaOmhMsn9R3O/hRf+xyK1Y0uTuMfTUMEzwxHGvJqSe8yw6oOoMvf0
   DYMS/vMkxohGKVskalzAHpGc6akxcWfyDNZrYjJLmBse1u447MI33hNQgk9rVaIVrKnMv15vduN5
   hJe4Pl3B8fKLgImETwWHVZYUHTSf04Q67iCvNvvfWnjcVdbgRxUBhTbvSEF9fDgNIbZsO99G1IRo
   FiCb4UHneBOUHCizXUdICwO5f5Ilp3+40vE/626BitA+tCKXKAfoudPY7P2wybZO6i3RucjJLxW9
   oH7chiqZPzpflNg1WbBdgw/KEb3bdhJRLdrPSw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK300AFAGBVZ090@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 08:16:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666340188; bh=nDtywa6mieJPfGn7a73ycNgAHcz816CMD4ioaA/ZgqM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lO82TxFXbxQ1cn2DOqHCEKyNscPmKusZYKwJGtS1W9wHd/+uOdMexrwxM5m/eoZGP
 ixuN1pMyIVVKVRufxw1DnKqd7DCICC9i7tVNcPFmRr0aUFAthWwsrDgNS/LTSDl6lj
 lH2fmm/4fi6QX2qSDaq/NHngB7BNdQ/cZRRC7bts=
Date: Fri, 21 Oct 2022 10:16:26 +0200
To: Yang Yingliang <yangyingliang@huawei.com>
Message-id: <Y1JVWsLs0EQ3dtxM@kroah.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <20221021022102.2231464-2-yangyingliang@huawei.com>
 <eb0f1459-7980-4a7b-58f9-652eeccc357e@amd.com>
 <10d887c4-7db0-8958-f661-bd52e6c8b4af@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <10d887c4-7db0-8958-f661-bd52e6c8b4af@huawei.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 priorityscore=382 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 clxscore=145 mlxlogscore=743 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210048
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org,
 Luben Tuikov <luben.tuikov@amd.com>, hsiangkao@linux.alibaba.com,
 somlo@cmu.edu, chao@kernel.org, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 alexander.deucher@amd.com, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: nHXUqGK3aDaHCMlMKdejY0iKo5L4P9F2
X-Proofpoint-GUID: nHXUqGK3aDaHCMlMKdejY0iKo5L4P9F2
Reporting-Meta:
 AAFk9+RxUNFyP4Rxhht/iTqc3EUPZKy9oHRzsiJMQUU2VQvHl3w8SngHLVySStIh
 OT8LJYJ6cl5+CuI0zLuzMwQTIbu5H42d+zjJ0vo68qYNX+4UBpTH6FF8uw2ipNSy
 6Db1fI4O896MWrCtJ3dQFVMrDQnFzPq6wa1HmR8oTv5bK8mX83p//0Cr88FfUPOA
 QHW1kRlnd9m6dPUpwzAdOp9kG5cCFh7TthDFio3+siksJJnlQ+SFiKAbz/9Y/Rxo
 whSN744DcY+LwfwNLDUV74GKfvsjiGF7KwGg+pPxVbEyWRXor67TMsKvY/69l/x7
 LG/YmHp7RCcmRHune/7yGDRpsQ82heKIT93bixc3cAQUnb32eqFcJn1/NbNhAfc4
 4XWoFK0zqpr3EL+HiC/rVKC1G9sjRrRzj5vKknQdZndOCHgtwiVQxLNi+3YxXsne
 GTszINbYL2UGC0cxfJVXfkATO6naXWLcFMlLfQCMDiQparbyLprqsT7NODvFRCfy
 zsmO3oekFXRIpjyfPbw21wiV3tKQgjQzW+pOKEgbhhCf

On Fri, Oct 21, 2022 at 04:05:18PM +0800, Yang Yingliang wrote:
> 
> On 2022/10/21 13:34, Luben Tuikov wrote:
> > On 2022-10-20 22:20, Yang Yingliang wrote:
> > > kset_register() is currently used in some places without calling
> > > kset_put() in error path, because the callers think it should be
> > > kset internal thing to do, but the driver core can not know what
> > > caller doing with that memory at times. The memory could be freed
> > > both in kset_put() and error path of caller, if it is called in
> > > kset_register().
> > > 
> > > So make the function documentation more explicit about calling
> > > kset_put() in the error path of caller.
> > > 
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > ---
> > >   lib/kobject.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/lib/kobject.c b/lib/kobject.c
> > > index a0b2dbfcfa23..6da04353d974 100644
> > > --- a/lib/kobject.c
> > > +++ b/lib/kobject.c
> > > @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
> > >   /**
> > >    * kset_register() - Initialize and add a kset.
> > >    * @k: kset.
> > > + *
> > > + * If this function returns an error, kset_put() must be called to
> > > + * properly clean up the memory associated with the object.
> > >    */
> > And I'd continue the sentence, with " ... with the object,
> > for instance the memory for the kset.kobj.name when kobj_set_name(&kset.kobj, format, ...)
> > was called before calling kset_register()."
> kobject_cleanup() not only frees name, but aslo calls ->release() to free
> another resources.

Yes, but it's the kobject of the kset, which does need to have it's name
cleaned up, but that kobject should NOT be freeing any larger structures
that the kset might be embedded in, right?

> > This makes it clear what we want to make sure is freed, in case of an early error
> > from kset_register().
> 
> How about like this:
> 
> If this function returns an error, kset_put() must be called to clean up the name of
> kset object and other memory associated with the object.

Again, I think we can fix this up to not be needed.

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
