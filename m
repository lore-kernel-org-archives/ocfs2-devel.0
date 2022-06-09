Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DCDC433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZaDsoELL6anQPRCfAdYBPVfP+yP2nv9/9wpq6JwLhN8=;
 b=y7QyNjmZC2ozQOsVW/YQJ4yOBrXd1tn95nXukRY+rVXap95xaTWf2MFUnbYs30ElSFg2UqtKb1cc
   5FxnT8tpM0asCnsCquZP74eBkth4ydLWRmhcYcRiM32M692lwQ2PcykzKCvp1dDVG/WHyeOW5QPh
   0g9RDd143sje67d7BZJgEQ2vW5D2Ju2BJv9fiAXcdu/TGK4gC8hJPENoKFQlW0BHJ/b1hppX22wg
   weoxbhriBkdUzOs1M0kvb+hCN6WSvhlrcMLY9t/T7PMgwbu98X8pweDOpdMn/4j2Z/gNMJiJyyS9
   H8PPj7bAnsiIvSFh+UfMrATnM1og8QXi2eFhgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZaDsoELL6anQPRCfAdYBPVfP+yP2nv9/9wpq6JwLhN8=;
 b=OXb5KK2TudWMD3spaFzhDq45VF5aEesXWLeHtsf3Ul3PuiIU2y2jksggwiyG9PXJccYwjT3E6+nv
   X996s/KuKXyYWiV+nUgSL9fs32UI6BK9ch2g3JRHqTrXNRbgWITxm2tBPLPEhvZWkZ6vfRtQBj4O
   x8QKVevRmsW+IXIeBA2emL+HAhYcqk8mrnVBFU/ora/rhmrOHXnhl96igIFF2Zly2j0lZrXirCZc
   3yFsoe0tTgNdDvXrwLIKeM6nhCVMv7Ocp6ofdl8B5LiG3mLOcF1YS386inPaSHpdMTzFK2wOXla6
   oCD7Ir4L7Ax23gTlESlJdxpPGQFN0shIk6C1bA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD700702NHHLH80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 12:46:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654778776;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zufIRXqzWNkS/vBQ6LnlofDt3t0aO0GgELLgxZEV3qM=;
 b=bfaVa0reba5JNx1JCCi449akB/iE7w7HJkh+iPewcoKUtXRVntBOZRj18BsRFXEJQD7Xt3
 GObsr5AzbK9k5Qx9iLnaJWAyVgOUUAb6wweVt7qXGOICRsO1ol959im5WFYdFixia0rC7b
 ZHeTquzJ+C6aZV+E1vVG8wDxl9vLE1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:organization:in-reply-to
 :content-transfer-encoding; bh=zufIRXqzWNkS/vBQ6LnlofDt3t0aO0GgELLgxZEV3qM=;
 b=nJ9EVVbXo5GeX11AmXR7G8wkjECmjjgdbWpbu/QZROTOnUOHKywqsAOTDqH25+FNhV
 MEi80jH+oDTyoObjkwItw4saCFPNKSNtu75YO7GG+1R+A521CcvAVEqCuxl5FKR2mutL
 e3jcg72W13rMrTFfsRWiJc9xKKRmHvO0CiANaJlmHvEys9OpvmhXiwgbOGGoJ8MApuEF
 9tzspCJKNXZKqioVaO4C6rZp2YrnAecrA9PGW/ko2VDOxoCKS1TXAxra1J4NnREdfnBx
 1wnwItyZa9GcYyu1dK+5CB3aT7UwVQatAk+oN/dIcRmLCKBVAVMsNUW2tu7ZiYlW0CG8 8Ftw==
X-Gm-Message-State: AOAM533vHIEYuAJv7JJG8iNVN7jwX3gBUzDtrTFpuZkXZdzOXjRnugZ8
 t4yKn5bme+5J8tEbb4dO/5V/E77fs7dCMcADSqMiPDyvmpFOeqlOufrUXJj6d/gkuqG1m3KBqq9
 lqaQ/PkvL5iv0+I+pU4OuXw==
X-Received: by 2002:a05:6000:168b:b0:218:54da:90ba with SMTP id
 y11-20020a056000168b00b0021854da90bamr12022157wrd.283.1654778773733; Thu,
 09 Jun 2022 05:46:13 -0700 (PDT)
X-Received: by 2002:a05:6000:168b:b0:218:54da:90ba with SMTP id
 y11-20020a056000168b00b0021854da90bamr12022117wrd.283.1654778773451; Thu,
 09 Jun 2022 05:46:13 -0700 (PDT)
Message-id: <c204c627-ec6b-cd8c-412d-57c8f55c61fa@redhat.com>
Date: Thu, 9 Jun 2022 14:46:11 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-2-willy@infradead.org>
Organization: Red Hat
In-reply-to: <20220608150249.3033815-2-willy@infradead.org>
Authentication-results: relay.mimecast.com; auth=pass smtp.auth=CUSA124A263
 smtp.mailfrom=david@redhat.com
Content-language: en-US
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2 01/19] secretmem: Remove isolate_page
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
X-MC-Unique: 7UiEVf6IN0SK2IqEVac5hg-1
X-Google-Smtp-Source:
 ABdhPJxFg5i2EPJ88Gv87gtw7EHVrLhSwsyQAltgpPZk1DxRKIUlDObIOhdmhH9jKki5ThpOI9Vqng==
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
X-Proofpoint-GUID: nLo87hmh-RU0ayih1RRdd0cUHXnpQ9T0
X-Proofpoint-ORIG-GUID: nLo87hmh-RU0ayih1RRdd0cUHXnpQ9T0
Reporting-Meta:
 AAGni/yQTh7fcOMzRT8aS4a0ZQqGUSrNXFi8yvblSY96+bYcuAwOKXGKSYq0J9NO
 jXJyXToyLxAW4+bQ/jOQP0qt0m/kg+O6hANzeQIRVB7OkcSZMBV2N5sjaktRCo0/
 Qh94DAyvi5prbeSD7LFFabG9HHDFKzR5RsC7qE+siyMM4k97QfPjcRNw2o+czZPg
 OebWff+SYTwTiBjf0Jutx9mDt9AGs84EJm1v6xii9+sO0Sg/um1tjrlDBLE9B3+J
 xsnjOkn5vrZurhtZXhHmbeN2Sj7uNyCxdvlAjRV6qTIf/TJY4rQdyUALmMoqQcTM
 hcGdljeAJ8xqnGtIaDZPnwMvxnAkV+vWt4SroafRFKD3g3Zat0tqtwIZYvd7RdwQ
 rZEJkWwHTnrzbsDmNcws06UlbIK1h6Cx/RMM3oT6vEzGNA5shUpL3MR13TFhaPY2
 o/RBBm7dOYCQwtCulTDJAgI0d5rrq/oWyHIRjosIk6OWgQtWNWo03/ghmdC65gyK
 GFRm2cSP+UC2fbb/QXafjt8hTSE5KH5TuIp3n7IK053v

On 08.06.22 17:02, Matthew Wilcox (Oracle) wrote:
> The isolate_page operation is never called for filesystems, only
> for device drivers which call SetPageMovable.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/secretmem.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 206ed6b40c1d..1c7f1775b56e 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -133,11 +133,6 @@ static const struct file_operations secretmem_fops = {
>  	.mmap		= secretmem_mmap,
>  };
>  
> -static bool secretmem_isolate_page(struct page *page, isolate_mode_t mode)
> -{
> -	return false;
> -}
> -
>  static int secretmem_migratepage(struct address_space *mapping,
>  				 struct page *newpage, struct page *page,
>  				 enum migrate_mode mode)
> @@ -155,7 +150,6 @@ const struct address_space_operations secretmem_aops = {
>  	.dirty_folio	= noop_dirty_folio,
>  	.free_folio	= secretmem_free_folio,
>  	.migratepage	= secretmem_migratepage,
> -	.isolate_page	= secretmem_isolate_page,
>  };
>  
>  static int secretmem_setattr(struct user_namespace *mnt_userns,

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
