Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75FFC43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=h3EPq2wrZVhp3KfmXtHRbn14SLsdny7sQRECxGxTTZs=;
 b=XWliGWj2UHSQeAKOvxHdqFQAweGug8184H1VekmG+stZ2SjC39auApc24xilMb4v9PBKpBSFvjP8
   WPg/XoWqyTMxsTr3abNyqy0f9fVg0utiEbZiklzoTUZTwnGmqDTXx25fK0mrgoNn4tpToGVyYWtE
   xPawgaDu1GsNc/TryZkMGQ1S7gocbzXqAbEn6+ZXFzW4I3OPHYtED29itw4eqQfvDQrTJPNRb/ed
   4z/3A7b2F/qdKry2H4U+tMVdI9JBpjV56M4vcJPvc0JJF71J4iIu0k1Apa4kv4vsp4wElk+SYyef
   IxnxjCrIulz4Jlri8hsz57kqFId0GUzAWJ1aVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=h3EPq2wrZVhp3KfmXtHRbn14SLsdny7sQRECxGxTTZs=;
 b=f6dTTd8LOwVU+maDE/iSf95l/uwSe80HSYElF3cWSBh4/IAYXSqAI7PcbBUnq1FCLtfykW5WO26l
   EVmtHIH5z7aSH6MXh7lsXPKaxgYZ0ZP/R1d6sJb82hkw8tzKUcoyKWxfjjxMK+hZT6NFV+T5zmP5
   1Gduk7/s1dwj09/cpnqPgYlC7JpG9eatkHIXYBVwiQkTOlAognxZxksNpee70xL31mia331bjrq6
   BhG5TiH13NVK8xxW+JAj9aDWT/mc+wtYKjA45oxzIZD33Cx1r+qJMCXQ/uv1pviXUhma3qBaXugi
   U323jxtdkc1w6UY6GItitIx5ypFdplMLlvpcUA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD400G4L0QO7X60@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 13:42:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654609324;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=U9GWchY9hZYcIJP7lDw5j1KYfu5h/jhdfCsZWPH40Q8=;
 b=RRi4QjAn7sx1oxiTav2LXVEYk4HjhJ6sIs/BBH9vY97myKLAzT5nH3hG6OkQEzW0icahmL
 X9YGMngXem6pGZs0mF3Gu3WsNGsOhCbyluyFNnOwEOlwv3RSHJuynzgqmc2z7z0luUvi7t
 2If3Mg/3tHHa9z/ezVwoOCuCAtbsmSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U9GWchY9hZYcIJP7lDw5j1KYfu5h/jhdfCsZWPH40Q8=;
 b=Q0TOQRx47ObjlFWEil9+kquWLqMD7gNfyjMuIY3uAbrklmdOgNXXC2vszfDJ1O2r5s
 SCu+RhCbCpKdMgANaqE6rZ+cQ2wdYktP5hT2Ept95Ycw+5Jbn5nTZIg8oa4Y3bCSKnkj
 oTMZA59RfVM1ARFqFOUIt/3d3KJEbgIRAgw5W9O+qpZNxaSOjx2L98+FLeUCVD8GhzYW
 iyTKJS3Arolg7EHz529FHwLzoSEBAigchAaCCa7yXdXxspwZcWBrW2b6wYmw41o3pfNf
 6GSQydeqZ+coy75riXczdotr/ZliikhDJpqoc/OPxv5b/VyK+uWQ5GyUCw+Z+ZML+YDr FYAA==
X-Gm-Message-State: AOAM5319KTeM8+4UJlTGVII8MOon9gBTmOrzlews2+ZcU1blBzYGgwFb
 iv9M9fh9HP1QTfrAefQDPYW+zjPc7CaxxiDFEMwkqc1DmlhF/AuNdK+AlJUN2ANyzT79ipiGWeq
 25OQh24WUN9OjiVinccl+DQ==
X-Received: by 2002:ac8:5acc:0:b0:304:f75a:4a1d with SMTP id
 d12-20020ac85acc000000b00304f75a4a1dmr3015556qtd.120.1654609320536; Tue,
 07 Jun 2022 06:42:00 -0700 (PDT)
X-Received: by 2002:ac8:5acc:0:b0:304:f75a:4a1d with SMTP id
 d12-20020ac85acc000000b00304f75a4a1dmr3015540qtd.120.1654609320271; Tue,
 07 Jun 2022 06:42:00 -0700 (PDT)
Date: Tue, 7 Jun 2022 09:41:57 -0400
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <Yp9VpZDsUEAZHEuy@bfoster>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-6-willy@infradead.org>
MIME-version: 1.0
In-reply-to: <20220606204050.2625949-6-willy@infradead.org>
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=CUSA124A263
 smtp.mailfrom=bfoster@redhat.com
Content-disposition: inline
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 05/20] mm/migrate: Convert
 expected_page_refs() to folio_expected_refs()
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
From: Brian Foster via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Brian Foster <bfoster@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: JmuO7pQKNUWXLXWY47Z-zg-1
X-Google-Smtp-Source:
 ABdhPJyyavNr4YW+NLtrlTYw3DwYvyx9zxVnBrVGsEoQi3F5ODngxQYCXvCvG44n4ArB8DEsaTyYSw==
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
X-Proofpoint-GUID: 1RP1TKqwAFGRdgIeDQwA0Sysj6mICmbf
X-Proofpoint-ORIG-GUID: 1RP1TKqwAFGRdgIeDQwA0Sysj6mICmbf
Reporting-Meta:
 AAFkcIS6h1XGbefDGn7CgjNGhuXeZ4ta+5hGLxszNOODxxLlrdrponGTNgl1xir2
 MYRYxft/u/z9n4kHRgss55vNTyUy/6O4WiEpns8yeMIaXwKSJu3eqvky44ZITbML
 Tu8Wf6vRbVlJsiLlmddHGvL6BtnMaOXvFe5OyHHYUrcl61aMd+lEFYoXt6pNXVwv
 1W2mpSnK3JZ6kkHIOd0NWYNwzYYTxG+s0X7hf2EDk/KtIiU8DKXX55oSEGQg+ofo
 ODsb6WgGIqw2eGGXx9b5qD4gxDFeO10Q8lcJaxeQowKjpku+i/DeuUCi7FjHXFTz
 wmdn/XiOdsKIrlUNX9Gp5L9kCKSguojNB7kE1NHJKBxk9ipZdrS5Bl/RjpjDOtKZ
 MHRhDJLVEWujkoGJgZ5P77p39GjofdgUlkqSpRblIJHBHPSR8F1tgIKbY8RI44Po
 OvO1k7Mmrt0xwIQoeiQmwRRFLqbfMs4hwD7aLZBDW3ah7zBxhXFAh+JeIHmdxwgp
 +riKjzNwj8Vw8zkD62aR5+QtPzOW6s+RISQzPlP+N23j

On Mon, Jun 06, 2022 at 09:40:35PM +0100, Matthew Wilcox (Oracle) wrote:
> Now that both callers have a folio, convert this function to
> take a folio & rename it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/migrate.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 77b8c662c9ca..e0a593e5b5f9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -337,13 +337,18 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
>  }
>  #endif
>  
> -static int expected_page_refs(struct address_space *mapping, struct page *page)
> +static int folio_expected_refs(struct address_space *mapping,
> +		struct folio *folio)
>  {
> -	int expected_count = 1;
> +	int refs = 1;
> +	if (!mapping)
> +		return refs;
>  
> -	if (mapping)
> -		expected_count += compound_nr(page) + page_has_private(page);
> -	return expected_count;
> +	refs += folio_nr_pages(folio);
> +	if (folio_get_private(folio))
> +		refs++;

Why not folio_has_private() (as seems to be used for later
page_has_private() conversions) here?

> +
> +	return refs;;

Nit: extra ;

Brian

>  }
>  
>  /*
> @@ -360,7 +365,7 @@ int folio_migrate_mapping(struct address_space *mapping,
>  	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
>  	struct zone *oldzone, *newzone;
>  	int dirty;
> -	int expected_count = expected_page_refs(mapping, &folio->page) + extra_count;
> +	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
>  	long nr = folio_nr_pages(folio);
>  
>  	if (!mapping) {
> @@ -670,7 +675,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
>  		return migrate_page(mapping, &dst->page, &src->page, mode);
>  
>  	/* Check whether page does not have extra refs before we do more work */
> -	expected_count = expected_page_refs(mapping, &src->page);
> +	expected_count = folio_expected_refs(mapping, src);
>  	if (folio_ref_count(src) != expected_count)
>  		return -EAGAIN;
>  
> -- 
> 2.35.1
> 
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
