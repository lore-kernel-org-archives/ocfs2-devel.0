Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B960AC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=ktLJxytwKh+6yfb7q5DhdgtWt0OWsURYmSJ3ajaHshpDXj8o3l8C4s7rRf+iPujDVCh0Ezo8ZLHv
   2mDkHwrdATChB49C7H4IcsJmNxZYJGlOZlu7PAONHdAfLd17W1u2lr+QiBD+ig4z7DKX3CL/ZER5
   DxO5PkeqXkBPb3aXFGyPMN7ybEoekgNRfwP9RxcIfa6WxmslqKj+mxGwPXASo5XWw/+4yl8Ml22I
   l+1IUfCLc3neleqKup84Eb8lspe7t+A0TEwQ8xch0Zh0/J/zE59aUVLwPxWbkm+4NOwt4fb+O6HC
   rjU+UxtwR8TVCg4xJ/e2TY+WXEt1/vhklmkgRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=c1n/NOyc2NUagH1Ps93WgabmX7jOSy1C2PGpYipCu4LtjGufk3k8cpBc3ktW5aRRGNIYIG0f6u2h
   NzXHMEDcgi6BsLeeas9oIMNjVqssAL1T3N4nlOha7uhaIh0l6F8jw9PqIDdjsE9y1vqkdW/P8kdC
   8uiZqZNVeTuQMS4Ajyad6N2c1jcQO/vQI5+Gnaby62Tmd+vgR/KZW7fysRQKhzDvOIrOd8EkFblT
   xADLlgprLE6YdGJEUiycr1RLr1ZdpSjOw/znEGeivSnhJE3QdPopEaS0lb5NJbMqD1S77Aqib2Js
   XaZFa1cPfFVqm/Uq9WTlZt2J9to9OzberHZ29A==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500MK5GLMK370@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:22:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uWRRPV9KcWC5GZyLeg72wrVPcV
 d2Es+zQ5G2bz+iDCx9jxlIZ4447mlBlqNoPDYb3O93nEr+1LyvA+rxtAw2TMYr0dPQZ9HxPAHhfWB
 DCTTSNhJblOGweHs+CQdq+Ssnan2v/3RMqwBIeotDQmSqzv1NU/30QoFNupM4CwnZY7F/IbDQUtwX
 VGFk7zx+BpB5oLGK/dGg1UNjs0P0DeeapOFfN7qJGnXEUdMIf+4TR4piCWXslfOdQs0WP6sxLJP/r
 NG9NQzPIL9u23QXetWJj5e92K6vEuufojvFmOPM8FN4wOPW+xruj+DJ6yhv75Cvm6VCAlXylKJe6t
 2LahBrjA==;
Date: Wed, 8 Jun 2022 01:22:17 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBcOfiduNfPpYYE@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-21-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-21-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 phishscore=0 adultscore=0 clxscore=146 priorityscore=111 lowpriorityscore=0
 mlxlogscore=511 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 20/20] mm/folio-compat: Remove migration
 compatibility functions
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: qe3TkJ1iDcMp7npnikST2xLhwC9qz_XD
X-Proofpoint-ORIG-GUID: qe3TkJ1iDcMp7npnikST2xLhwC9qz_XD
Reporting-Meta:
 AAGAiBEpOU5BQxleE+Hi+JsYU9ou5Ui1C/piCUbvHDjgqz710kk4eqWLEcLDXskl
 4Pj9TrxglgsFfuHIAuoBcwUTpaNN3SQjbe0kSAUkgWCnNyExwRt7apZkes0Fp8wn
 WvDQ2det7rhN/QqywHPND8UzPa9606yXctsm76Nka259ganLWmSKqIkOhTNv8cL/
 UtsdUR6TtRBghsrB9gZkY1VuRjiLH8FpFtslboSlb6GviQaibweQ1wYd/HrbBYxP
 08VuxQ53bWjC6mVk40sUUqkK8fXZeDpKFBzp9oEPN4m4o9gT//hvdtoS8qRdpvhM
 HaJ1+1zfNbuS/u3XjQvgbBqNRM8gPziaR26nxltS+YSIoW3FheozE4zEaMH4ggTK
 1hpjYEh8AEci8v/fg7+crOjSBBReOyKbkhSJj7Ds3fViArs8SSTNWXhTYrQCau7S
 tD2qqsbsVkzgja7/Q0V8aRmN/r2NzsTWQc17EvBIfpSL/Dcw+2n+kP6fZcwAHARx
 qG/ImbftMwybTstKyTDSOustYZ5uLVU7Q0LkNDjGajU=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
