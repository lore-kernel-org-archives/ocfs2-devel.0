Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337D9C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 07:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/cLPNy1jdnWW/77ByBwAQsEgimyXEUiV84gQMcJ5egM=;
 b=Y4FqlhWZrspk7sMdgS70gfn1z9y80xAzrd71ROoScww+h9uGTiOG1slGSytXC3+EabXEqNtVN2s3
   UX+WGbBxKTJi8cib87KBN0RyGNO8YV0B2Ke/COjABoX3yK8LHYXXOZvUjvspRc0dFkODg6ErZHWF
   A5nWGbCvlBjvvMyA94ZC3r+4TJTP9EZ2OD991liKlhByDCtC+/KFpgJ/KaXjcCHQm2s6YO1uNt0s
   4xAuKIdxjObzJZD4FaOvD/IfPFTJs7Qzyxdj5u3DQ8hZfzWEPNG65TTTfPiQcG1ZqtC9v4FjNcyx
   BHlrEjO07TukfWOTKVHEO4ZRPdB8AoCtCZ1YMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/cLPNy1jdnWW/77ByBwAQsEgimyXEUiV84gQMcJ5egM=;
 b=p1IKTV1sRzN1IgnVspZLbC/uw6N4/9npZSMLByf5bmI8JFYMdph0c/uJ4MRzE30syjVINDuRwU7a
   0ZgjBySn7xVSaLcnQv0q5PkljlPJjz3nfj+xRFMU3d1rWMC8ghjep3Ekk3+dA68QVfXyF8L6z5EO
   YRoBxVAsOaFQUqOG8ZA4GeW00VjTy23EP02DCngK7z+5RdieLPUnQ+Okc7coV0YTMCWM7BpiLYfY
   DFeL1Qp/IH5i1WwmhGhLshm0po7wkSzoxg+aD6l96GFXzhVk9nOlqOMYbLJejPXdA6Gqcx38Ug9F
   3cSZykzCe1vFcva9tWxH3qQBvdDDg0YQGXCNMg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD300FV4JUH9420@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 07:37:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654587426;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=poSLf3SQpSQVqGAvfY9ZUAc4mDsdNw09sPQoA12+Xn0=;
 b=Ei+tS59UADcqRz8t/v6zXFGm4EirBPntNruDT19yvMF9YHB0MHFhp3IEyb+cuD0A992nYg
 D39RQmqe/dt0C1JFN17d4H6Tw+rzmJJNiqBkd5Qr+Z2n5LKSvSi0fssMroXBAMVSEW6qnJ
 HECw1UpOfT6vHDEHvIqVFVk+w02e7rk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:organization:in-reply-to
 :content-transfer-encoding; bh=poSLf3SQpSQVqGAvfY9ZUAc4mDsdNw09sPQoA12+Xn0=;
 b=vgS19nRUClkB36+OthC8gO1GAtL1Rh7+fQ8awLRSuzkzp1gx/VKJeqHWXMAxuwDoEX
 +v12dKntQbFx9iXnivnXArIEGza7DqBZThIewvBUrG3wR9tUcOP+Cy9tX/uX04v1Yt43
 h67MsLacpNS28oFHYn1pFC08K7pIeda1D+nuwDESiJ+/U9JmntJ+LV3BVR7xjbg12ByS
 /d6+/4OtDAjRTXqljDt85kOMF/tZjL23hxY0DOymXFhBQ09YmrPTQzYfXV78LVyOQYFp
 AK+9hFIayIIbc9O54Hfw/SBzd3SrNOInW6vE49MF8N2FeHd5cEIYRQXV7z6t5dxM5m8f f2uQ==
X-Gm-Message-State: AOAM530vJZnE8H0DmtmGXXbEZHRVKAY1VnvFhaCHN3+Pxcud2bUc3ExH
 ZCobYzHd0s07Fle0UhfF94Scz2rozxc1G2URVugn14njAiD0c/ZsUcTBidj/CttEDxcyFQDbVFh
 cCLADpMY2ifkEmI4Axaf3pA==
X-Received: by 2002:a05:600c:4ec9:b0:397:750a:798a with SMTP id
 g9-20020a05600c4ec900b00397750a798amr56010312wmq.169.1654587384018; Tue,
 07 Jun 2022 00:36:24 -0700 (PDT)
X-Received: by 2002:a05:600c:4ec9:b0:397:750a:798a with SMTP id
 g9-20020a05600c4ec900b00397750a798amr56010293wmq.169.1654587383789; Tue,
 07 Jun 2022 00:36:23 -0700 (PDT)
Message-id: <e4d017a4-556d-bb5f-9830-a8843591bc8d@redhat.com>
Date: Tue, 7 Jun 2022 09:36:21 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-16-willy@infradead.org>
Organization: Red Hat
In-reply-to: <20220606204050.2625949-16-willy@infradead.org>
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=CUSA124A263
 smtp.mailfrom=david@redhat.com
Content-language: en-US
X-Source-IP: 170.10.133.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
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
X-MC-Unique: SZ6yAXFdNKKOZeEODKtkpQ-1
X-Google-Smtp-Source:
 ABdhPJz/TT1zDaD6ih4ST/0Z6l6/VJexv/LUjWrit9gRiSM2S633qB8aLjqIdjv8Hs+falCUt0H+YA==
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
X-Proofpoint-GUID: BnzYrlAVKjIids5enSkAUSTmpSDb_kNI
X-Proofpoint-ORIG-GUID: BnzYrlAVKjIids5enSkAUSTmpSDb_kNI
Reporting-Meta:
 AAGzSnpca0MIfP0pH95dgkmdO/2Gw/fk24ByyoMNufZaGjDTwJCU+jQlfyYImhCg
 pryN2B8GexNrhAYRJlva4SAftYl2Fgf3dPsiX+NDSzufVbzuaaKW5zJEb1THnNvr
 aLQ4cpjayHoo5aqDejMHl9f6eHLJ48JTiGnE5kFwQe2oXR+miictItw0tmHo6AZR
 1CfYTYWCKIsVnlmfOwvHUGtcTLEoSDHeisvcoEADWQNxOyUnr1kl8YUr1gYmn10+
 65jItUpWFbHy/HfoYTAetqtbAoNfK8xc9Mmma30n84N3WOzyIuPFcH+ElKhRnK1i
 GaQitn8H1II+T23yibUvsnF2LR/+p+K1jmzYoq19w/dJg071FgaggJVF4OBGL1+J
 1/rvXc3bws8t0gpiu6yz0m5PB+lqPIFOLIM/RaPilLl7ts8o4+BGPtkOfktlNa9a
 s5JcbmcH2rAHn0RDTfRbj27B/2xAXXwqawvJp+8PXEW9eBnikn94oviOGFGfJqaQ
 U8/Ji1OavUInSX1YmVzyFxWRnfzFX4j2A1tistoJZXho

On 06.06.22 22:40, Matthew Wilcox (Oracle) wrote:
> This is little more than changing the types over; there's no real work
> being done in this function.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/balloon_compaction.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 4b8eab4b3f45..3f75b876ad76 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -230,11 +230,10 @@ static void balloon_page_putback(struct page *page)
>  
>  
>  /* move_to_new_page() counterpart for a ballooned page */
> -static int balloon_page_migrate(struct address_space *mapping,
> -		struct page *newpage, struct page *page,
> -		enum migrate_mode mode)
> +static int balloon_migrate_folio(struct address_space *mapping,
> +		struct folio *dst, struct folio *src, enum migrate_mode mode)
>  {
> -	struct balloon_dev_info *balloon = balloon_page_device(page);
> +	struct balloon_dev_info *balloon = balloon_page_device(&src->page);
>  
>  	/*
>  	 * We can not easily support the no copy case here so ignore it as it
> @@ -244,14 +243,14 @@ static int balloon_page_migrate(struct address_space *mapping,
>  	if (mode == MIGRATE_SYNC_NO_COPY)
>  		return -EINVAL;
>  
> -	VM_BUG_ON_PAGE(!PageLocked(page), page);
> -	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
> +	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
> +	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>  
> -	return balloon->migratepage(balloon, newpage, page, mode);
> +	return balloon->migratepage(balloon, &dst->page, &src->page, mode);
>  }
>  
>  const struct address_space_operations balloon_aops = {
> -	.migratepage = balloon_page_migrate,
> +	.migrate_folio = balloon_migrate_folio,
>  	.isolate_page = balloon_page_isolate,
>  	.putback_page = balloon_page_putback,
>  };

I assume you're working on conversion of the other callbacks as well,
because otherwise, this ends up looking a bit inconsistent and confusing :)

Change LGTM.

-- 
Thanks,

David / dhildenb


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
