Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855E1C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=VnyMBjOrFnra2PtKSEuBya1Ma7SHdRbvyadbAjM5+uGRJmPDleSCNm10d17zdz66frEG/viZdKV9
   tmsYdOGW9tg9ILCvv/jP2Fp1ahr66SLQvMHm8wy1DzdNAdYP9hrh7EkpZVAyoD/7HdDnvrfnprhl
   ZDfnx5mYanMkuHtC8wbr4Rt2HCXP9fT2m2I1a8/RYZCeZ3+qM/zl+GNWvrY7Q6FnSENRpdayDHZX
   wDv4jvyNMkgjshWVkzJxy2rFsof0Lg8Q73ybMYUXgENbW9U/tT0l2lh5GLT3CmpD3+x4vsij2M6E
   dtm76sN1Rlbw7Wx35wTKtEtkZOPv5AB7bjuqBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=GtFyf99TsTIapQhq7KcD3Ko4VBfRdjaa4KCp56vRr2efttVGeo8i0iTpfmTSoVHQ22D/pcBsee6e
   QN9OajX8r7LRYkSaU+aewJovtur+nzoomDU/f1uxpmQLKmPOAR4u8JV3qxlUczhqmnCAKtNO7DuP
   /ofPSK4JdqNjWhCVE3XtOivuLzkQ2KK36KERRGqY/RRJJMDqvpPiWCuLwwC67QcrE3NReQQoWcqb
   BvQFZhJYUs/qTODc/Iahp36Rqdj8Q1jJ7K30FR1cLYjFVQ4TukgP+GkHTEZhgwb5vhDyScG6gNWH
   eSwDjRHiSGMC+6cIRkIt/W4+cWdC1m7sH8Ghhw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500GSCGIBU120@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:20:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iB9dmVG9Ng3F2WTe/9TMxSCMuj
 ja0RHUmc9eQ5DhMz/J/4DLElaK1jbZ2WgebeBsycUKTpSk4XXZFan+9M4VKyV244r+9vrHLxfSXLu
 1Den0nhP5oq1v1RsBXC4KWrnFQR1GBOy5k4TDdPwCR83x4wgMBUgNlNfVHjeNnQFCqIK9FnubxtMN
 zWdv+oBD2Y2+ygzsJQKEKOjolNrf5KkOYpEfdDkwHbNa6JfEvO7NvQ802MWmg938HniKikRrHTl/j
 MGOjmrWcaz3uDl43QgwvycXByY5WxieHX6UmoFYrw/Hv+/92Pu6qHF8ifergHW1d73fV9QIISQE8n
 +Y5c58cg==;
Date: Wed, 8 Jun 2022 01:20:19 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBbwx5MhNRpqou/@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-14-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-14-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=120
 impostorscore=0 adultscore=0 mlxlogscore=400 phishscore=0 malwarescore=0
 mlxscore=0 clxscore=129 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 13/20] aio: Convert to migrate_folio
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
X-Proofpoint-ORIG-GUID: EkmLFbqN4RyU72J6cCpVz6hfYbto3a1C
X-Proofpoint-GUID: EkmLFbqN4RyU72J6cCpVz6hfYbto3a1C
Reporting-Meta:
 AAFWCATqpaqSMlf6sHWhELSRcSe2Eb/3BAB7UlokzF2uK8SH6SmA8NAw75Pt9Xfr
 vfgw9yZyNV8GEy7fhl4lJ9htVSNjO1ifqmbquCNckk3nA/SshdHMDbNAlkGFUTnP
 Rq2K4A6EmfB1iy+q6wj/PixKLFGramqmNqeIEPasdR4YbcbpFYwgYxbQsfgG4un/
 f23hwgmrBjfvIM/uX1z/lL98TgBTfp30efjQ6dua9fO9x2hdCRl6CQBVAxutWnoQ
 u6DM/3zz4GqLj7o7KGkuNw8QDi1JujE5pMOWOg46XmygK2i/3eRNiAm+VpAYAxW1
 ayHFfJhBKr60KzmUtVKOhZBiWheVBpPElH9SP4svC2FTXe7bludf8GR4kr5Olbhp
 MP1ygx4YVKMqAetVuOLZEcFjkK3eBlx68bUvX/nzT+B795tztEKN6eQSwEnVM5dP
 6YTs+SJmmLiz5XfE2D0rHpkiZRrvYzsF73TJneGqYH4G/Y2mcsprssVBjNkBdpz5
 AbKpBlTmSyFnOAuf4Bui+uMGjQYDy7KIFZjGZ0j+Lsos

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
