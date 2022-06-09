Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7891CCA47F
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Jun 2022 10:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0xi0u8zP18gXnfNdbgBOlQP6XXI85aUlKGRjvRiq2IA=;
 b=clrGov7hdYk+QJoSQwMIEQ5J7Ij3JCmhXumdopCoeExMvVTmVkl0Xtc4Hbed/d2HXUYiLPDuj/wC
   1VAfKbUFKcMw/tZxvWk/fyD3bM8eeEQmEvFwAKtfikvlbLcMRsGt0g62MOzwdb2hWjtANXMRjuh0
   EqlYYLnnKIeaDyUY4zo6arRDk/stm6h+edH4wuUEwBX7ZL3W+axyR/XL00CSOFjiUAALQwvI5ni1
   Cds/6aglER7t8IjBw7z9Blb3lSMaqEEyVA/a3zhuWSBna2PM/Af/wQMGTEX6WsCS7nfsOFA9/ggn
   RlVU08m30iCsRg6eMObh1zqSIztKj2BMJweFGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0xi0u8zP18gXnfNdbgBOlQP6XXI85aUlKGRjvRiq2IA=;
 b=i94dYk/dYHeJM2H01882cu5ze7s8pNbhBZ/pPkqTWeh7scVy0QpenI3DtIAPwjwcyYrhcdjFeJ6+
   jvwNbS9g7ThUXV1yh/Zw3q/qWMSvONBW9TNPaSG+DnYjh4yRCH154cld1eL+iYNydhXh7U34xaNf
   Frww6FT4lATPmyJuTRhJv1I1LuhiySzjcfjJAcf1Oq/DGAfnaV7L5P6FZlRiNGHb7o/ceKRUhoth
   xvZQd7d8GInCp2M9flOOLv/ev5I2K0daGjOHj2olSsS8FHZcbDhkfKi3o2f4rCTNEl6XWTeWR8KX
   0T/oD2TOZFW3A7ARn9IyVmMAB2ZzCd6eC6YxFw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD7001TKGWGAG80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Jun 2022 10:24:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654770243;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=6a5SsgsnTuFo9sIZWQwmUlikCgiuGiGF/De3NllGDd0=;
 b=O1xC9fxZOMxaqC6rSRf/wp7oRubAOdtuQF660ZO5XT5/cyF74PDWeE2QN9m27mc+BMztdJ
 4cTCEIEgzKecWwUfZ7+HFqcmlsf3bRPqSVsgzJFiymh+8vAQB/cUacDsI0Qr52taSElHs3
 mqthmRsXI3hdg1HfHwjn9aCD07YEUwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:organization:in-reply-to
 :content-transfer-encoding; bh=6a5SsgsnTuFo9sIZWQwmUlikCgiuGiGF/De3NllGDd0=;
 b=8NcsPsa6PzRgcBZHkFUVHN09REF5AtcTjfTvhJPIgxGQBSJTyBptmT+TI/Q6Ep96HJ
 jFe1luNQ+pAg+SGzKek/Utx7kk8Mt3fRCTdWUvhUcVITA423QFb1MD0IdHgcLOg5FDxv
 6GJqesqNQ0iYLNohG6eF0/Jv4ZXy6yh3cGaraot+yEz6IWr4t5GFgpO8ZPDhT7+q5Vmm
 iqcHRswioPL2UyYRqzLEMpk7ll51CJjZO+VkhXBzoXjR0Q8taULNoS8IJcZ4BsWJyCNc
 S1lWIREjCryqJuRoP8oEcPVr5dDZkbfRoo3IpgIr5G4i/d1G67oCXKSsgdWBmeelq+qt IQCA==
X-Gm-Message-State: AOAM533+y6gpI/vR4XgUbwTN6N5FjJBgYYCMzeKCt8BfXHWVsstfbBo0
 MbIlUeFQvmPMUNzr6BqkkNI1Q6mx5weoPMoNPaxApFG183Qj55e/RYnsx/yA3Ir5IzXyMVC2Smt
 EQohXfEsWUj2UlM1CjvmTNg==
X-Received: by 2002:a1c:a301:0:b0:392:9bc5:203c with SMTP id
 m1-20020a1ca301000000b003929bc5203cmr2594375wme.67.1654770241337; Thu,
 09 Jun 2022 03:24:01 -0700 (PDT)
X-Received: by 2002:a1c:a301:0:b0:392:9bc5:203c with SMTP id
 m1-20020a1ca301000000b003929bc5203cmr2594345wme.67.1654770240948; Thu,
 09 Jun 2022 03:24:00 -0700 (PDT)
Message-id: <a079ed41-1978-0551-2b5c-6d61aff7ddf2@redhat.com>
Date: Thu, 9 Jun 2022 12:23:58 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-3-willy@infradead.org>
Organization: Red Hat
In-reply-to: <20220608150249.3033815-3-willy@infradead.org>
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
Subject: Re: [Ocfs2-devel] [PATCH v2 02/19] mm: Convert all PageMovable users
 to movable_operations
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
X-MC-Unique: B6h7lsSBPvmjhHwO642bFw-1
X-Google-Smtp-Source:
 ABdhPJy58rh3fuuccVM2J0IS1QrE1vJ3CH41QyKYHa1IrWm/Rvain2xs2JDw35eE5SOSwtsykjkKLA==
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
X-Proofpoint-GUID: --3xhBXrKrAUfsG8oCTiAhtQaZTsqV-Z
X-Proofpoint-ORIG-GUID: --3xhBXrKrAUfsG8oCTiAhtQaZTsqV-Z
Reporting-Meta:
 AAEdb4bvKlOXGUnmi4u5h6M+clNVwMl2Ek1Rmppx6yDX/SJ96so5g4Mdv98i9Kiw
 yGcHVlKMc6oaQogMMQsfsgJ4O/2GXC8tzuq2YaXX7a8Pl/yvGJBUlQUzHm5pkpey
 r6tNmmsGcpG96Gszz9MBI/QEh1heeCcFBxnPESDitPzFAvTDKei24YXEhy/eq8sa
 BZGgaJZktAH8E2t4kPJ/0/f45SsIevUcWl5d6ZslYfQap30wFmiZxrv4sPmq6qZp
 rByfHpY0OGV7tetiklwWKZJGmmIaHwFmRlP3AdWGOUkMfXea9vtLiJ++qDoS+FEQ
 GcRh5vmfryTRV65dQA5BrPbDUqfEzDPKH3GGZ3aXz2Z52xBE6ItsQLJdBBt9XArw
 Gxgbm7W9A41LssgR/Vh+EQnUt4XHsXMJFdmYOs3+Gg7cX1FlzBADdCVM8RXO+6+U
 YfB5c6xjzNszALgyILafjYsxiMPWfgKlDgWB8VqLiHAVvdyZru6HeUKNNk0ZuShI
 tU9tPQ7RV7tSqcPEwyiQZQEEFRrdBXiz9a3X9/Ptozs=

On 08.06.22 17:02, Matthew Wilcox (Oracle) wrote:
> These drivers are rather uncomfortably hammered into the
> address_space_operations hole.  They aren't filesystems and don't behave
> like filesystems.  They just need their own movable_operations structure,
> which we can point to directly from page->mapping.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  arch/powerpc/platforms/pseries/cmm.c |  60 +---------------
>  drivers/misc/vmw_balloon.c           |  61 +---------------
>  drivers/virtio/virtio_balloon.c      |  47 +-----------
>  include/linux/balloon_compaction.h   |   6 +-
>  include/linux/fs.h                   |   2 -
>  include/linux/migrate.h              |  26 +++++--
>  include/linux/page-flags.h           |   2 +-
>  include/uapi/linux/magic.h           |   4 --
>  mm/balloon_compaction.c              |  10 ++-
>  mm/compaction.c                      |  29 ++++----
>  mm/migrate.c                         |  24 +++----
>  mm/util.c                            |   4 +-
>  mm/z3fold.c                          |  82 +++------------------
>  mm/zsmalloc.c                        | 102 ++++++---------------------
>  14 files changed, 94 insertions(+), 365 deletions(-)

You probably should have cc'ed the relevant maintainers (including me :P ).

For everything except z3fold.c and zsmalloc.c,

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
