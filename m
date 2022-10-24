Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20162FA3741
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Oct 2022 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9kZ5/4RmxMi70ipe0cftnfCVV6rXXDxtOT6cYsafBZo=;
 b=Vz+kZDHxxGVawON79/zvdyHvrvb0JmPYAlfPSBxkajuOWbaHb3HBMbytCk5cOITKi3gWULE0kTU4
   W1DfNMkDJsxbmWoTJ0sfc3q5YqLjorwAhhBFAH/DeWiP2qaE6plYjrlACnQ4/BC6tig7cF/fYtKO
   ddaqbftXSzRMdIOpIu9chcxnZye6wLhR1dVRgOcJbOvlSMEAw+HOrRLp+v+/RiG2mm1vZyxO++oS
   xfx1qfOzQSN2LZ6n8V6QzU20FO2wtT/pnByTKrLdxaJRV8NhW+Z+xN587MOH9KbtiD0J/chBdWPB
   IxzYrWbyLNiADCVIPVteiP3fYXaXdowFBlOlEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9kZ5/4RmxMi70ipe0cftnfCVV6rXXDxtOT6cYsafBZo=;
 b=DzmxSWspHG653RkvePEEaeuOiWLG0WedndW+3mvpwzVWSpEBdWxWNCGjUaSFExvzOpLzvwRGNWzj
   NGE2/FLQ06+VOGWMnQMNMl1p7IdSFZ8mOZtjpyMQk8GFizsPoBl+p3l2YpCCFUkG8TU9ujf6h20/
   kXCbFqQiBNTkdkR5Bq2k5LWnM5M03cBfVVI6pvKa19Mdrvb2WZ4GywO+4Gd6sOLMrHAm0hcoa9zi
   GuCLAAphj5iW99A/VMsWjp+x0LTwNQfndipQLj0DZww6KZRBfnGwjOXaiRtKyrqmep+7slkimLYL
   +92TSehzdSBbcOQNkwXzjAMUNTTrb5LyuYdKAw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK900GEPFV935B0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Oct 2022 13:52:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1666619524; bh=QIHnXVxCIGETsd0dywR9WOXQe2R85leBxjgt9psJDlE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=a2H9OWmUuPXe1nsvDHzMz7pk28v9U01aePXWCqE/PYv8mU+b3XDQLri0CqGVaRsJz
 jDX3YxQNP/rC/SyUqCZ86yUqxIXbKkp05GDQaItPKZLX+Z/tQqtvt0HtDKDldCwU2Z
 RC0760eEL3DTVNddcLXXtAu1W45/R1VDk/n+VsGo=
Date: Mon, 24 Oct 2022 15:52:56 +0200
To: Yang Yingliang <yangyingliang@huawei.com>
Message-id: <Y1aYuLmlXBRvMP1Z@kroah.com>
References: <20221024121910.1169801-1-yangyingliang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221024121910.1169801-1-yangyingliang@huawei.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10510
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=200 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 priorityscore=628 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240085
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
X-Proofpoint-GUID: dvzmNm9UQdHXvn3zGXWOBYJYJ7PYPov7
X-Proofpoint-ORIG-GUID: dvzmNm9UQdHXvn3zGXWOBYJYJ7PYPov7
Reporting-Meta:
 AAFnv5RMUpXhKzmf+p8lmLy5XPBEWJYJNSicruXAhiJX8tCiPaERJoYFkmjIMZrf
 xcyfLIs4tiF0un5mOchuAK+jrDxLW7ntJeVkPBo3gsWkigAPS0NCvI/zQxP7M82O
 9cfXEXhEcl32pHElLsDP/TXVFho1DxqgeAd6jJzx7yqGhycfRbSwaMZNu7rV/lKw
 w5LDoHcIpufvYp4STB/2jJHEGYEPVVtv+5ceGRWSig4EmJiUMFGh83/+TD2fVH8o
 xWX/veuvndB5I9Z/igoi2oD7kQ4G7i89pqnfiLEp2v6JygBwxvYsT3g+zWh+wU+X
 ybjnqKJB0+wxhFJnB1F++hOGvpGUY3i9e8Bxc7ellpLmw2UAKS4tYQSM0Pgo52eL
 9paN6CdY5rRweVJu0VYmRkeLwZpFTb/JLmwuotuRYgY43aWGeDQSbEjPC9jR8f3x
 nVQrdfM2YNjBZzR12nkG0gwOM+xbEH36gfJnLkaSz00MLUKSJQMlUsKS4yBM8RSj
 2bMLJ+dUYYSIO9inDcSvuIRSLEWDumi7SbyNsheiw8k=

On Mon, Oct 24, 2022 at 08:19:10PM +0800, Yang Yingliang wrote:
> Inject fault while loading module, kset_register() may fail.
> If it fails, the name allocated by kobject_set_name() which
> is called before kset_register() is leaked, because refcount
> of kobject is hold in kset_init().
> 
> As a kset may be embedded in a larger structure which needs
> be freed in release() function or error path in callers, we
> can not call kset_put() in kset_register(), or it will cause
> double free, so just call kfree_const() to free the name and
> set it to NULL.
> 
> With this fix, the callers don't need to care about the name
> freeing and call an extra kset_put() if kset_register() fails.
> 
> Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Free name inside of kset_register() instead of calling kset_put()
>   in drivers.
> ---
>  lib/kobject.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index a0b2dbfcfa23..3409a89c81e5 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>  /**
>   * kset_register() - Initialize and add a kset.
>   * @k: kset.
> + *
> + * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
> + * which is called before kset_register() in caller need be freed.

This comment doesn't make any sense anymore.  No caller needs to worry
about this, right?

>   */
>  int kset_register(struct kset *k)
>  {
> @@ -844,8 +847,11 @@ int kset_register(struct kset *k)
>  
>  	kset_init(k);
>  	err = kobject_add_internal(&k->kobj);
> -	if (err)
> +	if (err) {
> +		kfree_const(k->kobj.name);
> +		k->kobj.name = NULL;

Why are you setting the name here to NULL?

thanks,

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
