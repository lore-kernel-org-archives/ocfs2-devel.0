Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C860C7EE2A
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Q34pcRjBSNwOMK4IcmmqAdstpKiXfGWLr7LMDTSTSUg=;
 b=QSGcGhzIMM+w5q3x01NQjPPFu60ohTYiUuQ7gFMm6SmsmCF/9/yJb3ujIvg9iU8DPwUXfMsdcn9u
   5BeEBLyYmumar1wOzANIHZJQB5PAOP7sqWoJIyXGINpD5Rg4tTFwL1gfZbxz29Iym1U4xasslfZB
   mWcuFQCcdmS946LyLlnTGJj/Peq3frxYA493wlY6tAnr++MD8YXLpLp/McuWMxw+goKpIWmtJbqL
   hgja3JeOXVPsRjyaeYm7I7WrLU+ZpLBNuXaCp3A3kPnrokyP8piPW3RYTi8PGc8JWnZrvGHbxRec
   nSuXDXIdyFKwl25SQQ2kZHOayAhGek7G5+StjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Q34pcRjBSNwOMK4IcmmqAdstpKiXfGWLr7LMDTSTSUg=;
 b=EFQDpXjxZDXQt94Zni+hBMMMSltcoeWXFEovLIgWlw/g2jryfqMRwf5uyo9d2pTHaerjsGcwggdd
   GyKj675hAe+Q9NFFwxsnd7uspfjw7n5LuJxvsSkgtycieMikNnESzcI7CmJ2xbUQQe+LAhDmYNDY
   S2sk+ioiBmbroZAgadWRM/zOZqTb6mZoedeRusbT59kgof7PL7GNNjAoBYRn4rviNQSqrYBZMqcU
   uAebJoncWAYwTvLx2jR1WGi4kRuK+yhWFhkchGsRlXq6SKkkvzQ0guJ0v4xoA3pEwTKESCNx01ha
   aPV48tPgbjsrguKvxPHLbqNS8Q/6vEu5R50KXQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00GE2M1ANU70@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1679348349; x=1710884349;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=bxVzq8suDNih9SH1Ok62kaz7FvxQWlE5bz197aYsbjU=;
 b=AH+3YiVvFimq/8rgJDVMqB3nX24Ww1MnlEVFD7c0PRHUG5CDL1VWc3Lf
 PF5Z6qyf97EIyuKTS5rbYoJP45H7t+/cdWiF/ka3sZD/Y237970nrMl/n
 AcxSi3UHRLAYnr7e3H5+92ViTlYUeioTOi1oNFFcP8UjOH80uSJSBHGFe
 tMv9upSrnnYuSxncQWlLt/VsSHh/LCbk2/jqvs/iO+FS3YoYif33h8jEL
 +jUglndPCivbBp4E+NoFO/MLO5Ys3E8b4Nq14x6kF+C+MCgOd6vUxV03D
 +ces3gCSSdQ9/QOlkweEhHQFE190rtFRwXfmO9d0lXTsTBzVtO03ztEOE g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d= opensource.wdc.com;
 h=content-transfer-encoding:content-type
 :in-reply-to:organization:from:references:to:content-language
 :subject:user-agent:mime-version:date:message-id; s=dkim; t= 1679348345;
 x=1681940346; bh=bxVzq8suDNih9SH1Ok62kaz7FvxQWlE5bz1 97aYsbjU=;
 b=EKxs8rpUot/qFRHAvND09IIAv6cqU/2Lev47PpifnoY6Vn42PvZ
 bLqMSLk5W+AyQuqTGKwodJfY4iDfhinl9cyIK7N2mtXEWEbGsMTiKxFf0DCuYwfv
 U7tD4WDxe1pbv3HNUfmVAdcHrTAMKvexZTU0GM1jYO4oNPGmPiD77lxKs2Zw8Hzb
 PwIdTneUr52J5sAiu9A7XMDGoEBHZesZf8Ek4BS/umk2gVFaA1nuC+gmt+D5Qto6
 f5pqaIAayhxw2wlTZV+cAvKH6KJ3w/adruI7wi3ZwobRCy9apzq/Jd2TLBhGAwdK
 dxo6IBbJ/jukaj9W89Dx0kqPLMgyapwzAcw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Message-id: <2229e074-d78e-3bd5-bf06-a53e9ad57d02@opensource.wdc.com>
Date: Tue, 21 Mar 2023 06:38:58 +0900
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-language: en-US
To: Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
 trond.myklebust@hammerspace.com, anna@kernel.org, konishi.ryusuke@gmail.com,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 richard@nod.at, djwong@kernel.org, naohiro.aota@wdc.com, jth@kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
References: <20230320184657.56198-1-frank.li@vivo.com>
Organization: Western Digital Research
In-reply-to: <20230320184657.56198-1-frank.li@vivo.com>
X-Source-IP: 68.232.143.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10655
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 clxscore=198 spamscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200184 domainage_hfrom=11266
Cc: linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [RESEND,
	PATCH v2 01/10] kobject: introduce kobject_del_and_put()
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
From: Damien Le Moal via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.98,276,1673884800"; d="scan'208";a="330490369"
X-ServerName: esa2.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 exists:%{i}.spf.hgst.iphmx.com
 ip4:199.255.45.14/32 ip4:199.255.45.15/32 -all
X-Spam: Clean
X-Proofpoint-GUID: DJg1ZRZWueWqLkmVYVHpzBi6xy9YBdRr
X-Proofpoint-ORIG-GUID: DJg1ZRZWueWqLkmVYVHpzBi6xy9YBdRr
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAF2ZR2AfcWj9C6hRzKffIFez1A4y/BOnktonO7NLGDJcKz+ILtJptIP0diSvwpV
 0hZMpCogTOpWjtLGGhYl39hs9YiwQElOkbpZ3/HdGbI4vEFlvu2uJ3geemUKbsLe
 1NZXVE1P88JQSKtvXZaK7KUDR5UWEp8V6CybZpCGv5PRMEShLW2YUxCQsLG08XE0
 ErmHtcm+cYRFd1cI5OOdlNSTsMqrLYavh4557ZY/i/eI2B6WAbOAmDgHl4L4/9br
 6PUAkNcCGyfmyoIFrQ1f2vThpAB7kKU+ni7qe2gR12GiEYH9cDbsAri3Dkn8vyKy
 wLPqZ0J9xchggQ8h0rGTC2TK+qnMl8oIZDMx7AYWqPTrBdyHsgz+W+uuG8mliU9j
 E3e3nifjJCfOUkJoW6C5DM1gXjLoDBrOY7Oxhlh7Lbwr/c/1FatEtl60IR5SlgBW
 aEaQrwaTFN7kyUHG0EsqvhKYyS+dxqV8ytvUnAORF5wpGAIwhoqNnErmSpTO05aV
 jyrAVjqCbB/WjXAmZSH1SfZX34LGMTIu6dhLoDmhPNc3
IronPort-SDR:
 HIKIpZLSl3LliBku0oFJgqa60atXxQRrPoTNJRA+BBfS9zReE36D0n8q4v1uBj7M0Tyi+iOtDP
 IBw3DM/NnQfe24iendkLf4NFt4tdPzLEc5mnnYp8ERPibjyVpGnkvXsdY+AkBNq6hrtql4Ps1t
 Taz18LdtHdx34e+eKPVGO2lNSEylQ2WcNdb9/FDd12foMnPPH5Ws/drbkdJlj+2DclHwqHhoHD
 6xWH0MSYzp/cu1BonBJpfPw+NVh+1uGP7ZZ29jYdgK56dAInp9iit9VQxzpcFZmWKau/XBTsnk HI4=
IronPort-SDR:
 IYEzk06Npp4jjsFrh+h5/ix6oN1I9F7wuSjx8p3ciaJ2h866OsVjk0tXhVa6KLDmYWWvLrPSKd
 yI/u/F2S8zbXETHUbE0A0tJeZNeadY7nA4Z5Dir0NWFPzl4BdB02NUmCitKC+hjcJNhRiDb0lK
 AGq9EYlAX0Owh28t0qEAv8wfiqcy5yodxOwYXnjdtpnDbeW8apVQK0AUaCNZSbHvekrzamhONB
 HJHbtiL//l6hLfSy/ub5uGCgf6+g1NX9x88tKLjuVy1XaTlmL9vrz6uTltS5+uwOGwe8wMQsal /Oc=
WDCIronportException: Internal

On 3/21/23 03:46, Yangtao Li wrote:
> There are plenty of using kobject_del() and kobject_put() together
> in the kernel tree. This patch wraps these two calls in a single helper.
> 
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> ---
> v2:
> -add kobject_del_and_put() users
> resend patchset to gregkh, Rafael and Damien
>  include/linux/kobject.h |  1 +
>  lib/kobject.c           | 17 +++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
> index bdab370a24f4..782d4bd119f8 100644
> --- a/include/linux/kobject.h
> +++ b/include/linux/kobject.h
> @@ -111,6 +111,7 @@ extern struct kobject *kobject_get(struct kobject *kobj);
>  extern struct kobject * __must_check kobject_get_unless_zero(
>  						struct kobject *kobj);
>  extern void kobject_put(struct kobject *kobj);
> +extern void kobject_del_and_put(struct kobject *kobj);
>  
>  extern const void *kobject_namespace(const struct kobject *kobj);
>  extern void kobject_get_ownership(const struct kobject *kobj,
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 6e2f0bee3560..8c0293e37214 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -731,6 +731,20 @@ void kobject_put(struct kobject *kobj)
>  }
>  EXPORT_SYMBOL(kobject_put);
>  
> +/**
> + * kobject_del_and_put() - Delete kobject.
> + * @kobj: object.
> + *
> + * Unlink kobject from hierarchy and decrement the refcount.
> + * If refcount is 0, call kobject_cleanup().
> + */
> +void kobject_del_and_put(struct kobject *kobj)
> +{
> +	kobject_del(kobj);
> +	kobject_put(kobj);
> +}
> +EXPORT_SYMBOL_GPL(kobject_del_and_put);

Why not make this an inline helper defined in include/linux/kobject.h instead of
a new symbol ?

> +
>  static void dynamic_kobj_release(struct kobject *kobj)
>  {
>  	pr_debug("kobject: (%p): %s\n", kobj, __func__);
> @@ -874,8 +888,7 @@ void kset_unregister(struct kset *k)
>  {
>  	if (!k)
>  		return;
> -	kobject_del(&k->kobj);
> -	kobject_put(&k->kobj);
> +	kobject_del_and_put(&k->kobj);
>  }
>  EXPORT_SYMBOL(kset_unregister);
>  

-- 
Damien Le Moal
Western Digital Research


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
