Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A75C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=THZH59Z8Gd6C59QALoG9t3HowwjWv4O1J1IyOBfSoFk=;
 b=T3RKKy/z7cLXU869d1qShKhD6o7/xQHn8BIBie/R4a6YDDJ5dZz2jOk0BWOLdAQyp72HBxUw/Nsv
   vXFawITMLYN1cBLeWhf+v2ivDOcTtpk0KKchZ7ESBAUQJTjkWAtAoyDphS4WhgdwIlrpBiPh2GK4
   CWxi99ddnCG6JB/Iqjj93oFAgPs3xXmA6oxljeG4qi1uSB835GuseYQC6iSfxkkpHcUNe3+0loFK
   u5BLG478uIpcfes8/B4zYpUtDYgjQsnDPg9HSA9l9xOePDCnmWK5R39rpvRZjzgbRaug7kfTdFSq
   77V53AcUwg3lZp2a9FVuNRzt+p1Ow08YVPmgdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=THZH59Z8Gd6C59QALoG9t3HowwjWv4O1J1IyOBfSoFk=;
 b=HWPU/ZwhVtLhey6kQfJuy0Yk0dX93B0TAEXFZ66jqSqUj9QAZINJ7a1rW72kHTZ5yN4CJ+N5+3gD
   SUTr6cYnxU7Wp0sVBXUsexf+pqngiQOEnYc1dCtBjhlhMPXq7GMzXBqFe1s0UkSb0iyUkr9BggsC
   RAsMs+kGWfQHjv/zAEBm8vOze7etDHdLcW4JGjb/sdyKVfAAbhYpAUcmc7EZpQbe0DCLO3cGeUBT
   ptg6BqWYYnsVru8iCS5yUm8TkLS9txbxcqbT6hbGcbdSuUU+8vdSuPJ6clweRTr56W0657L/qPIu
   JJrk24juMTGyUp5+9YudzXphfSFq2snCUBrp+Q==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500NE7G4P1W50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:12:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=Szf0A6CRm0TBzxMXL1+4gkRAFMANtEnQnq4pU3N3BDY=; b=bYF6iw7wjd0y+Z+F/STcPCdMi7
 QSbSyR1GVcGFHB6mUBGkUCvisiY89ZNNX0/Xw7TDYYqDhHEMDOkqpQ78YG7sV4Im0du6F72Z2caY2
 H1v0O8XuuqPMcgOMYc4Efb1MkS92YKtPUeCLJbq9RGFmaygkN6erKP+/0UYxlGLIp8l92hgq4KJ31
 kF5IB4FI7Rq0HgNYKMpkwaCRGuxqr9lQsYWHvQqZ+Vswy62VOxb0dtM/TNE4n9Rus3hm4P1v786GN
 Bu2U9oHHaP3qDEJtlCQFZ55nYDw8n8UvwKtVqn7mGlBP2GXKaLdhKDC9jgMMNKOZ33JSqYzDxDfna
 Md/gh56g==;
Date: Wed, 8 Jun 2022 01:12:09 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBZ2fWTyU9cbyR+@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-5-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-5-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=146 mlxscore=0 mlxlogscore=368
 spamscore=0 impostorscore=0 priorityscore=141 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080036 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 04/20] mm/migrate: Convert
 buffer_migrate_page() to buffer_migrate_folio()
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
X-Proofpoint-GUID: wgySM05x7uF-6Ubg1plmxZTfJwUhnstd
X-Proofpoint-ORIG-GUID: wgySM05x7uF-6Ubg1plmxZTfJwUhnstd
Reporting-Meta:
 AAEUdjyrjDXGADmYWdFqLWtJrFm2+/QdRxjhutZ920/o126QkpEupFLc2jTNKNi1
 lAnYamPZDznTKltv+cnx6JzAOt2VzcIdO7iOem+/D6dsHatpJc/O3Qxp+WK9Rz7t
 fwZsVMgRO2uvTjkf+6v5xkOkHqsKh3iudI622l3LWyoUWqyfP+T7I0BaW4ycRfUG
 sRz74ldALgBO440uDLnwvaPoP7VaEJsoP9jyVJlzu871T0e2kLO0MAx1Gh5H1aHP
 2QQR0rb9H+uV7MWGD+Bu11yvStbQmOOMZi8V7viHZT3pwi5orwQRiDoiiNOMNQul
 Ou+6M1TrkihDARcZAiyAtnO/419wEybxrdoASSu/tV4sA62NbDh8NUZMMwikxLUC
 L2g/IGCBnsH84oi/JpqRWEG3CP7sV2njKhwIxW11+/twZX7B1MLFV0Cub5E70a2i
 CyJCEjlcQ0b94Q9TfivcQPf8kFY8B+ZuKmZ+0vWd+CceS2svCk33d3f9IeLbiCLT
 BZdLC31sBy7j2Rynx+t7BAy3EiZtMVpfnU8VlS6fzkVi

On Mon, Jun 06, 2022 at 09:40:34PM +0100, Matthew Wilcox (Oracle) wrote:
> Use a folio throughout __buffer_migrate_folio(), add kernel-doc for
> buffer_migrate_folio() and buffer_migrate_folio_norefs(), move their
> declarations to buffer.h and switch all filesystems that have wired
> them up.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
