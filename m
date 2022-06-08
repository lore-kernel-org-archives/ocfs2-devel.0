Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E19ECCA486
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 09:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PJSB8c5mgdmbLMeAgTCzIl0TNLjzqaHpJ7qmD+OSiSc=;
 b=Gv2Qy8y3zb6GZY2s4LEKLPkJBWx3lQUQYMVIDPh0cWmNd8BBgc4ehoP+Dt8A6oZQ4PV3OEqOEvpJ
   YiJ+V66/9yox+ozQyliI4j1eKRnoBM3Q2yNA30NU5fggY1dLzVdrovcjf5/eHSq7s7217hMK7xTt
   cOSQJmXLgXrq1laSKitNDyoFh4Uqth7knGjgG7urYdslkCGZ7TlYHlhmE3kqhDiADRNXxMdFwQQD
   kXdBczbg8Aqk5uYvNr94LrVp0Y0zz4ZY0sbJJnT/8lJlgDsToekdO3d4kGQwOilSA1PIGkXJweg4
   KxfI/HDI9anJFqytAuL3MSbs7rV0/MHtdWtnUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PJSB8c5mgdmbLMeAgTCzIl0TNLjzqaHpJ7qmD+OSiSc=;
 b=TAZhG6D0utOiILodN1hvvFsayDQgmr3WyvjroGJwjI+TJBI/VzfymYLupa7R/FHeOMzcPA0/6mWy
   KCyKv/740usY7/NTtWP/og8V7siUFX65N5+bOs08FYHTIRXymtayhUgRK98Jq3z3eZMmFkGXWODj
   6hsIG4RtsgPH/lmnB1XUtYsm+Nvxbctb13GS/ArRUKAh0wgZ8G86ctuAwEADdNUWdE+0nmdhvUzX
   f7dMQkJ8SJ4R9qEuEEVlm52ZcXeG3YEsG4U9Iya4ThZEb/bX0u5B0OoQb7bF0sH9I3V+nO584xqB
   hVmBhd7kPRCFjGjK2O0n9kewZr7eQSr/tRTzqw==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500BEWL3XMCC0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 09:59:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654682378;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X7ko0a61KQIEYlZE2OolrSj5KPboqylHtHlNY2Rk0xk=;
 b=VaxoQa74af1KpBUfmYVcmRpHxUBU73u40BqwdLOciO6zi09uLfV8SFOJIzsZvUiWmGRBte
 pVScgcOnTr2fbdx/xfEe21XK+wko0i7sUburY16pt3SZOBspJIA2BVV/L+TL0Nvi6EFJXK
 TnmxPLhFRPltOknj5hWKKjUVs+44CuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=x-gm-message-state:message-id:date:mime-version:user-agent
 :content-language:to:cc:references:from:organization:subject
 :in-reply-to:content-transfer-encoding;
 bh=X7ko0a61KQIEYlZE2OolrSj5KPboqylHtHlNY2Rk0xk=;
 b=zHi8w15SE9HuNxlPhrVYBQ2h8UMGoM92P5Y3XKpvk4LhKnjZgTzpPi0rY4xXW0cHLC
 AEnFu2rLdFXRuhdJghy/vb3+/3wXQ6AzypClqd3v4vacs1age7uahkxaC+JXe8O2sXGQ
 DaaOj0z6A/lauO36mRUdfWZ6eoxPR72BLqryW/MdhKJ+/OuvF/g13lBW19KbfxB9VCaF
 qKanqxcc691zCTE6jMIfmmGfqYWGLIDRuxFny1JTebsZEl2HR6491UhO1RNzK11+l2Tr
 6ZqcXbyMlLdVLNK2tyJ6I9etUCpuxeVxc0iWBOqHncf8kITb5JzGr9xZIQomPeSKevDd s5gw==
X-Gm-Message-State: AOAM530H81XMi5TEGg2/GO7vBBlqqLO/6HMO6QNXCz4QyncppgUGVz7k
 62I6Fr39kyV38vHSzBizvO7myrpdycOF+8ZVmQl69SZOiP6dUkHzp0zxHybqKBSL285umrZKntw
 qQWoSHH7Im3uCqfKeoZ0aEw==
X-Received: by 2002:a05:600c:154d:b0:394:8d64:9166 with SMTP id
 f13-20020a05600c154d00b003948d649166mr33665196wmg.102.1654682374071; Wed,
 08 Jun 2022 02:59:34 -0700 (PDT)
X-Received: by 2002:a05:600c:154d:b0:394:8d64:9166 with SMTP id
 f13-20020a05600c154d00b003948d649166mr33665171wmg.102.1654682373804; Wed,
 08 Jun 2022 02:59:33 -0700 (PDT)
Message-id: <36cc5e2b-b768-ce1c-fa30-72a932587289@redhat.com>
Date: Wed, 8 Jun 2022 11:59:31 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Matthew Wilcox <willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-16-willy@infradead.org>
 <e4d017a4-556d-bb5f-9830-a8843591bc8d@redhat.com>
 <Yp9fj/Si2qyb61Y3@casper.infradead.org> <Yp+lU55H4igaV3pB@casper.infradead.org>
Organization: Red Hat
In-reply-to: <Yp+lU55H4igaV3pB@casper.infradead.org>
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=CUSA124A263
 smtp.mailfrom=david@redhat.com
Content-language: en-US
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 Rafael Aquini <aquini@redhat.com>, Minchan Kim <minchan@kernel.org>,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 15/20] balloon: Convert to migrate_folio
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
From: David Hildenbrand via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Hildenbrand <david@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: CBFm46LWO6eSJeK3nKdkFQ-1
X-Google-Smtp-Source:
 ABdhPJw4BCTXIM51kCwL6Z6H/hpvqsMvzu1fv9X/GhiUOzp5r00CIAo0BKvmPAyhZ/PubqP5kGP1SQ==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
 ip4:103.23.66.26 ip4:103.23.67.26 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
 ip4:103.23.66.26 ip4:103.23.67.26 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: Oqs8vmjxDdk-ZkOJwJczZaavKhagvhPT
X-Proofpoint-GUID: Oqs8vmjxDdk-ZkOJwJczZaavKhagvhPT
Reporting-Meta:
 AAGnx2XvP9kfm53J79sZUgZo9mEsahRKKgMZ/PZL5jCaXE+wQXiPlIDmsIJFTl+V
 sVffy4Qw5Oe4rft3XFmzYjnSMScOhMyzmVmtTGxhygWw/cuvJP5ko6o7Qj2xNC24
 C/mQOeMckU1rzELZkfh95pJQ4yaROnJKLUvz1IIG/+ZuKiVVkdl+5dzLc7D5Fnji
 n34rCofIpZOSMFS71WvzjnpGV1UuwHJzQSPj4naKClLGFQgEbUdrs35cRsmrkiQw
 dkdbe1EBN5IypsJA9RNv2tbIvWSk03U4/NHZr7Aw068Ra3uwVXXq2I/fHdnIveZu
 cBS6rbABrXccZhYmVqQWqIMJV15vennBJAiEzleyzSExc1x5zRU3gV63KcMTsWmn
 kBCuPbx/0+/ngaYDU7dTa+cMZsbOxGCvUtxEk4pJEy+6vt10W+J3o90zHFXfgG8w
 ewe618EbRDveOGNZ1HJRecvbi1ppjY+/nVtVHX487D2mgeozuynsyt+d41bJEmF1
 wY1SZmX29kr+OR0pf8DYCwXI9OovfYgZx3NWDkVXBQ9K

On 07.06.22 21:21, Matthew Wilcox wrote:
> On Tue, Jun 07, 2022 at 03:24:15PM +0100, Matthew Wilcox wrote:
>> On Tue, Jun 07, 2022 at 09:36:21AM +0200, David Hildenbrand wrote:
>>> On 06.06.22 22:40, Matthew Wilcox (Oracle) wrote:
>>>>  const struct address_space_operations balloon_aops = {
>>>> -	.migratepage = balloon_page_migrate,
>>>> +	.migrate_folio = balloon_migrate_folio,
>>>>  	.isolate_page = balloon_page_isolate,
>>>>  	.putback_page = balloon_page_putback,
>>>>  };
>>>
>>> I assume you're working on conversion of the other callbacks as well,
>>> because otherwise, this ends up looking a bit inconsistent and confusing :)
>>
>> My intention was to finish converting aops for the next merge window.
>>
>> However, it seems to me that we goofed back in 2016 by merging
>> commit bda807d44454.  isolate_page() and putback_page() should
>> never have been part of address_space_operations.
>>
>> I'm about to embark on creating a new migrate_operations struct
>> for drivers to use that contains only isolate/putback/migrate.
>> No filesystem uses isolate/putback, so those can just be deleted.
>> Both migrate_operations & address_space_operations will contain a
>> migrate callback.

That makes sense to me. I wonder if there was a design
decision/discussion behind that. CCing Rafael.

@Rafael, full mail at

https://lkml.kernel.org/r/Yp+lU55H4igaV3pB@casper.infradead.org

> 
> Well, that went more smoothly than I thought it would.
> 
> I can't see a nice way to split this patch up (other than making secretmem
> its own patch).  We just don't have enough bits in struct page to support
> both ways of handling PageMovable at the same time, so we can't convert
> one driver at a time.  The diffstat is pretty compelling.

Yes, splitting rather overcomplicates stuff.

> 
> The patch is on top of this patch series; I think it probably makes
> sense to shuffle it to be first, to avoid changing these drivers to
> folios, then changing them back.

Absolutely.

> 
> Questions:
> 
> Is what I've done with zsmalloc acceptable?  The locking in that
> file is rather complex.
> 
> Can we now eliminate balloon_mnt / balloon_fs from cmm.c?  I haven't even
> compiled thatfile , but it seems like the filesystem serves no use now.
> 
> Similar question for vmw_balloon.c, although I have compiled that.

IIRC, virtio-balloon, cmm and vmw_balloon all have the mnt/fs just for
page migration purposes. So if one can get rid of them, all should be
able to get rid of them. Essentially everything that uses the balloon
compaction framework.

That should go into separate patches then.

> 
> ---
> 
> I just spotted a bug with zs_unregister_migration(); it won't compile
> without CONFIG_MIGRATION.  I'll fix that up if the general approach is
> acceptable.
> 
>  arch/powerpc/platforms/pseries/cmm.c |   13 --------
>  drivers/misc/vmw_balloon.c           |   10 ------
>  include/linux/balloon_compaction.h   |    6 +---
>  include/linux/fs.h                   |    2 -
>  include/linux/migrate.h              |   27 ++++++++++++++----
>  include/linux/page-flags.h           |    2 -
>  mm/balloon_compaction.c              |   18 ++++++------
>  mm/compaction.c                      |   29 ++++++++-----------
>  mm/migrate.c                         |   23 ++++++++-------
>  mm/secretmem.c                       |    6 ----
>  mm/util.c                            |    4 +-
>  mm/z3fold.c                          |   45 ++++++------------------------
>  mm/zsmalloc.c                        |   52 +++++++++--------------------------
>  13 files changed, 83 insertions(+), 154 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 15ed8206c463..2ecbab3db723 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -578,23 +578,10 @@ static int cmm_balloon_compaction_init(void)
>  		return rc;
>  	}
>  
> -	b_dev_info.inode = alloc_anon_inode(balloon_mnt->mnt_sb);
> -	if (IS_ERR(b_dev_info.inode)) {
> -		rc = PTR_ERR(b_dev_info.inode);
> -		b_dev_info.inode = NULL;
> -		kern_unmount(balloon_mnt);
> -		balloon_mnt = NULL;
> -		return rc;
> -	}
> -
> -	b_dev_info.inode->i_mapping->a_ops = &balloon_aops;


Are you missing similar updates to drivers/virtio/virtio_balloon.c ?

At least, there we're also using balloon_aops, so this patch shouldn't
compile.


Skimming over it, nothing else jumped at me.

-- 
Thanks,

David / dhildenb


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
