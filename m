Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55562C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ygROw9SVV4J9a9SJaLU1l//D2n3VShmuMnwO2vlubTs=;
 b=qdFquOl2YWUeeolQfCQW5DGJ7NH8bbJk5+O2HKDm6bHWn5M0aYYqzvsC04SsW8Gt1TrsmDkjxE6I
   mNi77p6yLwKL/L5A7QuYZeOCZuhttD+FgG4RPUgUOVHxY14PyVpzLKL+zxE6EtlOGAMvGsTjZmrQ
   elqeAs/99ZiCflo5ThohGAQ0gsdhmOWWLjCQCw6cgyRsjk+0mAN/fus8tFOpTqMC6HV36ML1jqZp
   OhTkXJCZwr/DZ3gwmP8+QqPeWkYVsr/qfBxT3LicEWvUb8d7dLHulSpzRXRz5AXaQIATGhKYZwm1
   Gr45/g2uiEYtvjhC78JTD1eWFCF9tnZSlU4beA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ygROw9SVV4J9a9SJaLU1l//D2n3VShmuMnwO2vlubTs=;
 b=K7UxyIbtAkHlCA3cveP0QQDgG/kAjhkEMApQHedbWChsh4/cmOM0dVcnxpCVcQmHpGgzrDJbZt7d
   hB7yY4oCi0UcobFEIXHYwyrY6/jAYpwk7dsiVQ7vq0+M7Xza6rAknk2ZsshOQ2N6OaN/61e5Ztzb
   YqY4rxfaLXRKCLC4D5LbE3UCZFxky+8xP/UvBAgq4R3sTfmb/ut/jT7PdKLCSC5AIve7HzL1fDHh
   3VBR/TrcUw/VIFCpsAdS1U508PKij3iESY+4eKh8iqZ50D6ePKjv5KlJut5icuLsqTL8hs7p1uBQ
   Qsz9ld7zRnD161S/9UL+WIS0qTy8qIkC+J1w9A==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500D7AGENFFA0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:18:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=L1AvlWFHwiBlKlQQzU0xpyS1S48Sf4mV1g7YW62sB5o=; b=c8LIJtZY/Ea9Zj7ABHzI+bMXvA
 OURxjVH1jqQKjooyu90JyWo9Lei4eHfWj74y8qzcjeGS15+HT4UyZsLxxjz7Yl1Q73yWI3sS+l4ik
 sBIbOTs2vjWkv587GvrtnDe5+9gkgDAeLXwsxlGBXINihXqcmKzGQXi5mWdvAHa418P8Ia4x2E4gB
 nu8+7+M3O7aQUiy5LHqW0BG2L704jiNW3H6eiQnf6+Hue4sZDXUBr+i4eZgEU86kQivSxLwVKkp+W
 r6ZINI+yw8BsPr7FM2C9csARaKi3DWDVSMEi/cm4BvcRh7BZIPxuIbWJXaaVzzd2yEIC92+/LIJDR
 HFBmQzvg==;
Date: Wed, 8 Jun 2022 01:18:03 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBbO+yLvK2vCnk5@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-9-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-9-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 phishscore=0 adultscore=0 clxscore=129 priorityscore=120 lowpriorityscore=0
 mlxlogscore=362 impostorscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 08/20] mm/migrate: Convert migrate_page() to
 migrate_folio()
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
X-Proofpoint-GUID: 9LlBk4WnBuY-nlVsxVwumoOqiEoXe4JW
X-Proofpoint-ORIG-GUID: 9LlBk4WnBuY-nlVsxVwumoOqiEoXe4JW
Reporting-Meta:
 AAElQOzfTXt3yUYv2DsjsgcxxLoip/G4Bo9M7WTWi44eKW7GYMIKOO+b1TJ/fgRF
 OuY+pZYH7EWZZoKpPiMM8kFIu9Q+jBtX9zEta67wAPuoeDdhnCULFskLdCeRRV3v
 d02sgb7gpu82uB5Hg/OG53p6v6IN7SUNUZsS2xtBmwVV0fS5DWPj2gR6VK7V788e
 w0kvZyRhJHgViCwX7/BxvXPH7AaUkzeGSiscmJROOH8pkJ/L4eB1h3Y+vL8t+vHi
 6x+VqHPfPnUvDTx43jG3Sdq3g8+4ys6k/QhPCgTsMES3W0wbcpYMjORkuUUfqIqH
 LTuOptR0FPb3kOshFJtgBQp5MZThH4HVhpI6cUlGZK+KoDkVspyo9UeHdyyvqumf
 HKlsS1Y46H+bYgTJ60P7GkYty36Vmt5YBLrNgrvBzUCaTJIA++gf2eYCTMQjiG0E
 N8feFeJrQX+ZayIUeD6Cuw8X5Pg4Sv62hflk7xzLwUQ3uWawzWhtYPKIP3RoNAGj
 szgwZW9Zpkw5EZjiyv348lplMzNIXj7ILU8IPYFuzS4=

On Mon, Jun 06, 2022 at 09:40:38PM +0100, Matthew Wilcox (Oracle) wrote:
> Convert all callers to pass a folio.  Most have the folio
> already available.  Switch all users from aops->migratepage to
> aops->migrate_folio.  Also turn the documentation into kerneldoc.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
