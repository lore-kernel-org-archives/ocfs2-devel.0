Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDBDC4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Oct 2022 10:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WE5yAotpIExL+B6C6m4cLkPaJQh86YAnqTIf4Y8fzw8=;
 b=LartdU1MXQXQhq6spkUMT1TPT/W9KM+f8i2SwXUJvibJ5jI68uELIW2lOuW3yFS1QgTGtUlne4i0
   BOJCqfo8JDJmE/4WKVqFoZvEs01XCxrQv3uUyruw9+6p7HiXLlOXRuh4+4FhVDdu8sHwA7OXrQJp
   y80packhfLWGKFKFAeE76ZRrYCpYuhNdSH4/Yv47eabKE2CQlQXvjiEjzutr2p3215K0zcJtVNZj
   ehCYFTyXl9LExDdhyJVPFJuD6Aem1fuwW6OPEatEQxtSPr5VOYFPZoRJ8X5LER6R+M2hGr8EcDQS
   EWwGBIA4Oc1uaEdUX3u3Q06QPCYRNHuUCT8PVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WE5yAotpIExL+B6C6m4cLkPaJQh86YAnqTIf4Y8fzw8=;
 b=Z3L+XbrOhZ9iBavHfZDyZ49+afuLRLrIesLf7C6gsmAU5vvFiHta1Mgw0FhcC4ZnxVbQfA+Zyc2w
   eUkWclM6wKIi+qf53TMA20ruyNR7uTpNShDEzKb/9GSW7FMUNu5b5jVQ+DKobEUEMebJxQDiqzoW
   pgQO6s5OXuHUgCBKBo0x5dR0AM3q+7A0hBZEC4BKaRrBoxZ/LXEA9kTeFAXmn0nLI57xdwbJVJxp
   oe0Rfy1R8O1Wxm9PLOxuwUKbTIl/xr3L5hDKQTvYjODT85t2xJGXZGtn4QR9ZE+P4HozqG1R/Dwl
   rm8UqPcLE3QTf26xMmv8Zc5Ucd3SN0NlxJ0KXA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK100HFDRBL7F50@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Oct 2022 10:18:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666261122; bh=daXGkVi3pyOKL0rt2s6fBwZuSOy24RMPnvpbZbHV1y0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YEEfKZAr+CuwXAeL0M456TdMlRjOIwNFkl29n8jxHOE/PAzAPEJbcD4CC2yAKaVBE
 vyIEKlMw0G0xUSG3btllCyOq4zDh7/G10S1FPu782gI8SB6SP11tzSTapt6UYAnGfe
 dKHQfDphc2inrpX3hjhtUuEReYJhRI5yDAyLKiqI=
Date: Thu, 20 Oct 2022 12:18:39 +0200
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <Y1Egf2CmSZbtRr3f@kroah.com>
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
 <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
 <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
 <0db486eb-6927-927e-3629-958f8f211194@huawei.com>
 <1adbbf98-2700-27c8-4aca-9510bca91458@linux.alibaba.com>
 <f6bc6dd3-f7b7-e757-fc36-d1cfbc7305e5@huawei.com>
 <30747fd7-fe79-2ed8-ce63-425a008e3e4f@linux.alibaba.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <30747fd7-fe79-2ed8-ce63-425a008e3e4f@linux.alibaba.com>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10505
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=152
 priorityscore=398 suspectscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 impostorscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200060
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Yang Yingliang <yangyingliang@huawei.com>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: possible memory leak in
	mlog_sys_init()
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
From: Greg Kroah-Hartman via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="iso-8859-1"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 2JjLFP_-ofPkMAfeR0y_ctHEvrFQQkCv
X-Proofpoint-GUID: 2JjLFP_-ofPkMAfeR0y_ctHEvrFQQkCv
Reporting-Meta:
 AAHAnNJZl0hLXIhS4fD/wqgati3++qtk9H8DBiqW5oMK713mHR94luxFqrxRBdg7
 IGyXsV8BDaJ5BKFrVLzvbvkrMzelfu9+cuTddgjA7uxWoOVXyQvMNYNY2lKpnZ94
 BXksAQ4baGcDulEayQl11g+QaKYO2kI1GSlxt+C5eODCkfL8baGpICwbOY3x+8JI
 HvHGc3EFc5VvQcWVvtJ75MIXNS2rzmj1C0+baCvLmXojIoULv790qIi2t9Ig0nsq
 D6M/vP9NBZ8Ye7MjV8oYuFznWebzWBQ5BKSaqLErS87heQDAwawxi4nPi5gAL/oD
 Pe8c5YOPBfd59rftmN6aDrNk8ik/JCdS0LXqWlpc6cGOZkX8YxYGukWHhbItpbCT
 29Y5db/bg20dzXMNaWyIeYS1DuT5Z8qTbNGqNFvfKPzsmNyDpFhdjxBn1JqffG/8
 KjCyRH62XWI8n0uQwzHe/sMfZ55/nfKpED6EwOaRLhAhCiv2Q+tr+nwSlVuujSKl
 mFhO7MpB6ZhNLRvohLTtAkXMEqxDNIgRKbzktQqriKs=

On Thu, Oct 20, 2022 at 10:06:48AM +0800, Joseph Qi wrote:
> =

> =

> On 10/19/22 10:57 AM, Yang Yingliang wrote:
> > =

> > On 2022/10/19 10:26, Joseph Qi wrote:
> >>
> >> On 10/18/22 10:28 PM, Yang Yingliang wrote:
> >>> On 2022/10/18 21:39, Joseph Qi wrote:
> >>>> On 10/18/22 6:33 PM, Yang Yingliang wrote:
> >>>>> Hi,
> >>>>>
> >>>>> On 2022/10/18 17:02, Joseph Qi wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> On 10/18/22 3:52 PM, Yang Yingliang wrote:
> >>>>>>> Inject fault while probing module, kset_register() may fail,
> >>>>>>> if it fails, but the refcount of kobject is not decreased to
> >>>>>>> 0, the name allocated in kobject_set_name() is leaked. Fix
> >>>>>>> this by calling kset_put(), so that name can be freed in
> >>>>>>> callback function kobject_cleanup().
> >>>>>>>
> >>>>>>> unreferenced object 0xffff888100da9348 (size 8):
> >>>>>>> =A0=A0=A0=A0 comm "modprobe", pid 257, jiffies 4294701096 (age 33=
.334s)
> >>>>>>> =A0=A0=A0=A0 hex dump (first 8 bytes):
> >>>>>>> =A0=A0=A0=A0=A0=A0 6c 6f 67 6d 61 73 6b 00=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 logmask.
> >>>>>>> =A0=A0=A0=A0 backtrace:
> >>>>>>> =A0=A0=A0=A0=A0=A0 [<00000000306e441c>] __kmalloc_node_track_call=
er+0x44/0x1b0
> >>>>>>> =A0=A0=A0=A0=A0=A0 [<000000007c491a9e>] kstrdup+0x3a/0x70
> >>>>>>> =A0=A0=A0=A0=A0=A0 [<0000000015719a3b>] kstrdup_const+0x63/0x80
> >>>>>>> =A0=A0=A0=A0=A0=A0 [<0000000084e458ea>] kvasprintf_const+0x149/0x=
180
> >>>>>>> =A0=A0=A0=A0=A0=A0 [<0000000091302b42>] kobject_set_name_vargs+0x=
56/0x150
> >>>>>>> =A0=A0=A0=A0=A0=A0 [<000000005f48eeac>] kobject_set_name+0xab/0xe0
> >>>>>>>
> >>>>>>> Fixes: 34980ca8faeb ("Drivers: clean up direct setting of the nam=
e of a kset")
> >>>>>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> >>>>>>> ---
> >>>>>>> =A0=A0=A0 fs/ocfs2/cluster/masklog.c | 7 ++++++-
> >>>>>>> =A0=A0=A0 1 file changed, 6 insertions(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklo=
g.c
> >>>>>>> index 563881ddbf00..7f9ba816d955 100644
> >>>>>>> --- a/fs/ocfs2/cluster/masklog.c
> >>>>>>> +++ b/fs/ocfs2/cluster/masklog.c
> >>>>>>> @@ -156,6 +156,7 @@ static struct kset mlog_kset =3D {
> >>>>>>> =A0=A0=A0 int mlog_sys_init(struct kset *o2cb_kset)
> >>>>>>> =A0=A0=A0 {
> >>>>>>> =A0=A0=A0=A0=A0=A0=A0 int i =3D 0;
> >>>>>>> +=A0=A0=A0 int ret;
> >>>>>>> =A0=A0=A0 =A0=A0=A0=A0=A0 while (mlog_attrs[i].attr.mode) {
> >>>>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mlog_default_attrs[i] =3D &mlog=
_attrs[i].attr;
> >>>>>>> @@ -165,7 +166,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
> >>>>>>> =A0=A0=A0 =A0=A0=A0=A0=A0 kobject_set_name(&mlog_kset.kobj, "logm=
ask");
> >>>>>>> =A0=A0=A0=A0=A0=A0=A0 mlog_kset.kobj.kset =3D o2cb_kset;
> >>>>>>> -=A0=A0=A0 return kset_register(&mlog_kset);
> >>>>>>> +=A0=A0=A0 ret =3D kset_register(&mlog_kset);
> >>>>>> If register fails, it will call unregister in o2cb_sys_init(), whi=
ch
> >>>>>> will put kobject.
> >>>>> They are different ksets, the kset unregistered in o2cb_sys_init() =
is 'o2cb_kset', the
> >>>>> kset used to registered in mlog_sys_init() is 'mlog_kset', and they=
 hold difference
> >>>>> refcounts.
> >>>>> Yes, you are right. I've mixed the two ksets up.
> >>>> In theory, kset_register() may return error because of a NULL kset, =
so
> >>>> here we may not call kset_put() directly, I'm not sure if a static
> >>>> checker will happy.
> >>>> Though this can't happen since it's already statically allocated...
> >>> kset_register() may fail if kobject_add_internal() return error (can'=
t allocate memory), the name
> >>> "logmask" is dynamically alloctated while ocfs2 is compile as module =
and insert it (if ocfs2 is
> >>> built in kernel, the name is constant, it won't cause a leak), so the=
 name can be leaked.
> >> What I mean is kset_register() may fail with many reasons, or even
> >> without kset_init().
> >> I wonder if we have to handle this internal kset_register(), but not
> >> leave it to caller. This may benefit other callers as well.
> >>
> >> Something like:
> >> err =3D kobject_add_internal(&k->kobj);
> >> if (err) {
> >> =A0=A0=A0=A0kset_put(k);
> >> =A0=A0=A0=A0return err;
> >> }
> > I had think about this method to fix this, but some kset is allocated d=
ynamically in driver and
> > it's freed in callback function which is called after kset_put() and in=
 error path in driver will free
> > it again, it leads double free in some drivers.
> > =

> I don't think it's good idea that caller has to take care part of the
> internal logic of kset_register() in case of error.
> Hi Greg, what do you think?

I think if you are messing around with raw ksets, you have to handle
them properly :)

For some driver and kobject core functions, once you call register, you
have to call put() to handle an error because the driver core can not
know what you are doing with that memory at times.

But, maybe for ksets this is not needed and the kobject core can
properly clean up from an error here.  Yang, can you please look into
this?  That might make this much simpler.

Either way, the documentation for kset_register() needs to be fixed up
first, so that people have a chance to know what to do here and THEN we
can fix up the callers like this.

Yang, can you do this all as one long series that I can take through the
driver core tree.  No need to scatter it all across a bunch of different
subsystems.

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
