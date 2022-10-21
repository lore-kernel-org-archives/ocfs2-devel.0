Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6250C43217
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 08:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5uvEWFT78AvyHqyXsWgJ3brc45kdwimTSI1+pSGRviI=;
 b=1Yp3bvmlHtOAKMMJh7sYvMhRmPXfVqLit84CZlQOjggL4jV87djCtS7PMV4o8tEvZtegkIzZ4sjy
   ijOLFqM+zARYEjojnlSO3Tl/AwBWIvI+69+sExIn4KL7nCb0HIB4H9BX3zZ0zca7P9WZV89YfX25
   8mUGK7IcKzOyUAPa2sh5v4rHw5k3nuu+gAqs6zGM1ku933CQk2CpOwWYFlKR5OxWyqFh9CtrO+As
   aRpWH6rKTD9mddE5x9f3k5fjTpEjUZFMHDT9dA7qPvLBXeioTlT3oNTf0AKp0gMypISrjUvL+TfW
   beBP5Wig3dhWY0Se3OZ1X3Vd75zAflyH+FTclw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5uvEWFT78AvyHqyXsWgJ3brc45kdwimTSI1+pSGRviI=;
 b=fIKmClSypNOZifRRktkzMQM4WolkQDBYFCNxn2VlPIS5SdKxu+xFQRyFnI3BlSSDPBHupq0THBjl
   k+HbUqyt1m3CKSIEh7gZvshDEV1KpX6p9xjLx8tkabFbvhhkXzvtKgy3MEWTGzxiwZ3DiwmJ8KNT
   MeEqZTkpAqV0p38YiZEeBgLYsD7G8HUYNoU1f+laKXxH0/yrIaZZBvWPUbYIOU6+Nox26Sh3KrYa
   QjLLL6LsxH6Px2q4UqpwCjtRDKybTDHG/iTIzCVbNsPnuFBJke9kRCsTCIY3aW97DVMO6NapgM+t
   nmlpcQ0sQ+ReanAW2Q6jOoNBuhVnB6tuHuNxCQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK300C5EH8MELB0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 08:36:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666341367; bh=VYkxOdyqZTRP94uFOMrKlhrYPkv6+oVeaJOCigiokeE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=0LHArjuO/emmogeedg4sidpH81EIC1oFajIQk20rr9Km/Y0ewObOQB0i43jXid6V8
 MEWVl4mxIE2auEWLdOFh5S0zN7a5cdswL8kZv1F5sHrcBCX+9z8wc+kpjX8Czr8S07
 DVGuTf4yxBxOxcpimxvN26SCCFuV+ZffgRv7I1WQ=
Date: Fri, 21 Oct 2022 10:36:04 +0200
To: Yang Yingliang <yangyingliang@huawei.com>
Message-id: <Y1JZ9IUPL6jZIQ8E@kroah.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com> <Y1IwLOUGayjT9p6d@kroah.com>
 <0591e66f-731a-5f81-fc9d-3a6d80516c65@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <0591e66f-731a-5f81-fc9d-3a6d80516c65@huawei.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 impostorscore=0 priorityscore=422 adultscore=0 clxscore=175 mlxlogscore=871
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210049
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org,
 Luben Tuikov <luben.tuikov@amd.com>, hsiangkao@linux.alibaba.com,
 somlo@cmu.edu, chao@kernel.org, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 alexander.deucher@amd.com, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="iso-8859-1"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: vPoXpZZkJFtQG84r5TOYptq7V7FNxcTn
X-Proofpoint-GUID: vPoXpZZkJFtQG84r5TOYptq7V7FNxcTn
Reporting-Meta:
 AAGRY6MvRQAgndvPA2e1b5LD35ynVyl3CfZlE7JDCoDxu9hBBt8E8X5ZDTjCjNcd
 ugR/S2MEMAVQe4Q2p1F+gBQOohJOuii1SRX5JVrYylLAamvW8om0OREhtVeCENc7
 hUAcq+kih3CaYd6b9FMMBISFSgTCtmMDKA2pyUi1Mp3La8CENTM920EmxuVIvLpz
 oWbmf12BoKNO53NuzBYgirvccIf3TxiBaeyVaVSqg17vPr2etIp7E4+uAGStwZTx
 h61lBO9TMphnSE/p0noPVIyPGB8+bB8BSA34S1/9vGvC3QlFnO6DkDXgC3zceRKu
 UdszlNDeYYIPQQKpRjpHSuBxu8GcKh7TgUpObDN6bOd9kICjfWQmCMoPsOVxG9r+
 KGTUE8hSaMbc3eZitb/PwFWC/lPc+KvNnyMEPTP5Puz0aGPovsuMrTxldAAQ1Klr
 wHkrP8UQnK5wvCevmt7kLE6uCyzIzk9pdcuBHhvv1clOjPrMEyokdtmgWrXAboIH
 8IcwuHnUp4mvHX0G4zkKE8ld4v2OYNP6PSRajoFvjgw=

On Fri, Oct 21, 2022 at 04:24:23PM +0800, Yang Yingliang wrote:
> =

> On 2022/10/21 13:37, Greg KH wrote:
> > On Fri, Oct 21, 2022 at 01:29:31AM -0400, Luben Tuikov wrote:
> > > On 2022-10-20 22:20, Yang Yingliang wrote:
> > > > The previous discussion link:
> > > > https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@h=
uawei.com/T/
> > > The very first discussion on this was here:
> > > =

> > > https://www.spinics.net/lists/dri-devel/msg368077.html
> > > =

> > > Please use this link, and not the that one up there you which quoted =
above,
> > > and whose commit description is taken verbatim from the this link.
> > > =

> > > > kset_register() is currently used in some places without calling
> > > > kset_put() in error path, because the callers think it should be
> > > > kset internal thing to do, but the driver core can not know what
> > > > caller doing with that memory at times. The memory could be freed
> > > > both in kset_put() and error path of caller, if it is called in
> > > > kset_register().
> > > As I explained in the link above, the reason there's
> > > a memory leak is that one cannot call kset_register() without
> > > the kset->kobj.name being set--kobj_add_internal() returns -EINVAL,
> > > in this case, i.e. kset_register() fails with -EINVAL.
> > > =

> > > Thus, the most common usage is something like this:
> > > =

> > > 	kobj_set_name(&kset->kobj, format, ...);
> > > 	kset->kobj.kset =3D parent_kset;
> > > 	kset->kobj.ktype =3D ktype;
> > > 	res =3D kset_register(kset);
> > > =

> > > So, what is being leaked, is the memory allocated in kobj_set_name(),
> > > by the common idiom shown above. This needs to be mentioned in
> > > the documentation, at least, in case, in the future this is absolved
> > > in kset_register() redesign, etc.
> > Based on this, can kset_register() just clean up from itself when an
> > error happens?  Ideally that would be the case, as the odds of a kset
> > being embedded in a larger structure is probably slim, but we would have
> > to search the tree to make sure.
> I have search the whole tree, the kset used in bus_register() - patch #3,
> kset_create_and_add() - patch #4
> __class_register() - patch #5,=A0 fw_cfg_build_symlink() - patch #6 and
> amdgpu_discovery.c - patch #10
> is embedded in a larger structure. In these cases, we can not call
> kset_put() in error path in kset_register()

Yes you can as the kobject in the kset should NOT be controling the
lifespan of those larger objects.

If it is, please point out the call chain here as I don't think that
should be possible.

Note all of this is a mess because the kobject name stuff was added much
later, after the driver model had been created and running for a while.
We missed this error path when adding the dynamic kobject name logic,
thank for looking into this.

If you could test the patch posted with your error injection systems,
that could make this all much simpler to solve.

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
