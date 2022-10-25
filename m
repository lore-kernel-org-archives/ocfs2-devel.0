Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CD9C04A95
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 Oct 2022 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WFM4cs20Shp8/00KNA7PzeMofmaoeiR77tUZLGTqCyc=;
 b=FP9k/Mmqnu6Pl+nMkiEgTXRwH7aIFR6V/qqWGIbUzHoT0PCqsJ3brKd+XrsFM3OBhZeZjZ24XcLS
   I7SACPibfS57LncpCcbs1N2Y4Vwbry+JU64p4aBKtYLELQ76EYYVHRgr5yhFNEfP0viCdkI4FOUk
   PnVQbVyqsxA1YQVhbEV6styTxHDa+sD7x2dKY7AMPqYWTKriMFBjH5NwtBiXjGnE/cVpMQO+jxYQ
   zqsc2hwotCWfYKIFauh+tZhqQm/lC/J3rp23ayXt8NK3ANErcVWgs2t/Fd2R/Kb5kJai+Ru+mHVz
   jkVHfaVM3iVnQJw4sAlo/6nmoHuZPdaYrEKEqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WFM4cs20Shp8/00KNA7PzeMofmaoeiR77tUZLGTqCyc=;
 b=sQ8x9gDrQquyO1gZQOwIkX81VUtMnII0jLTgb2SKkH6QCGS+WzWorpmtNeNeGeW/VVQxq3znsXm4
   Dlq8723hzsI6TGB8PZgjReFVscwp3Q3kpi173PBXOIng674vHqDlvjweDoVDT3M94QDLTl8aVz55
   owfghZaUUN/QUMnAyMhDveRDwdd3ojypg3HLd8mYei5U34DOELrtAKwdq+4UQQAhC4PtCcofPwGx
   j2k7KGDH+UtGcCUNxU33nq0wBWTAf3OLRr1Rk9Qfd5Z0ckBOiK27Nowg2eYg/jk1kT3+CuLcWPE9
   N7f/hxrN70x0FwZRyAaN6xtGWSXxyGTEu4OrNQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RKB00E92J5BU1D0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 25 Oct 2022 16:58:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666717074; bh=TOr7/IBl9W+Hpc/R8LxJAyq9QpYQbWCv3WJvy2nka0k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=IuS0pwxkNWhb/Pc3fD1YeILTwYuQDWG7J6hJ35bK6Ucsyh68N7Gpf7db0oIcWSg5J
 +A52AVp6gq97BqnXsSXSdptDSLkW3H2w/eBLbjyhblutXXWvXsvxCZQTb1o8df8D0g
 X2/xsNKaI+imRsgqBblFS8hu7gUdhG4pmfgst1Zw=
Date: Tue, 25 Oct 2022 18:57:51 +0200
To: Yang Yingliang <yangyingliang@huawei.com>
Message-id: <Y1gVj6Uq2NDScYdY@kroah.com>
References: <20221025071549.1280528-1-yangyingliang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221025071549.1280528-1-yangyingliang@huawei.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10511
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=136 bulkscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=841 phishscore=0 priorityscore=308
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250096
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, somlo@cmu.edu, chao@kernel.org,
 jaegeuk@kernel.org, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, alexander.deucher@amd.com,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3] kset: fix memory leak when
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
X-Proofpoint-GUID: jJ_mr46hYlN5d6xMqeqANO1trYBaOG3M
X-Proofpoint-ORIG-GUID: jJ_mr46hYlN5d6xMqeqANO1trYBaOG3M
Reporting-Meta:
 AAEmN536qo0YA76mxEDl37QLJ8clvBR5X0rg8gg/IfiHd6ea2uD4V5XNsKu7lsl8
 NzKuACezYq8Ab21rdHy9t0eGb3DK4tDu3tc5ByR//RmhXUh+QnrQ03452wY+3J6L
 XAta1SembPp7+pa6jUTGQVkzObBv1ocpJu4oQr1/u1dLrARXQqqM4cTKP1KZRCAo
 1QAwZeAByVH/Lk8zfMlAnu2txAoWo3u6YAKXQQ5sG6CcHfrJhOmi/hv+6Gv3eaOe
 GHk1Ma8RbNDDo1sSMTfgdu0oEGwFTZGXkeAxPmb7kT+xRXAVkea6QFMDowNWnu9N
 /fyAZs6w9XmD+9I117foSpGc2u+AjqHG6BejSnH3hBBbyIzVDcWK7LHS+sEBVYjJ
 iZkhTgMH8K3L+q5fm6EfwzdBnFAm0cCHZh+7TvXvk8s7r+Z1S59zmUYnw92uvptA
 JG1abmvX7/ZQ9UFu7KS1uZfq6hjVOsuMaQchunaC0hQETm0XMSJlE4b6DzGbOpX4
 1JzdRTaxRKNw9qlDAie9QCBPHyaXz4SDsRuRXixFhoE=

On Tue, Oct 25, 2022 at 03:15:49PM +0800, Yang Yingliang wrote:
> Inject fault while loading module, kset_register() may fail.
> If it fails, the kset.kobj.name allocated by kobject_set_name()
> which must be called before a call to kset_register() may be
> leaked, since refcount of kobj was set in kset_init().
> 
> To mitigate this, we free the name in kset_register() when an
> error is encountered, i.e. when kset_register() returns an error.
> 
> A kset may be embedded in a larger structure which may be dynamically
> allocated in callers, it needs to be freed in ktype.release() or error
> path in callers, in this case, we can not call kset_put() in kset_register(),
> or it will cause double free, so just call kfree_const() to free the
> name and set it to NULL to avoid accessing bad pointer in callers.
> 
> With this fix, the callers don't need care about freeing the name
> and may call kset_put() if kset_register() fails.
> 
> Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2 -> v3:
>   Update commit message and comment of kset_register().
> 
> v1 -> v2:
>   Free name inside of kset_register() instead of calling kset_put()
>   in drivers.

Thank you for all of this, it's a much nicer and cleaner fix than
forcing all callers to try to handle it instead.

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
