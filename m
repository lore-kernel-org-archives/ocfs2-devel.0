Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85963C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=2cWWt0IWkd7xN/K4YRJAjP8OxUbyHYVvY9rvmpObQq2kFPzfxEzrP5TI14rsPFuNtTE6geDYZXq9
   3NdsgxzvucucVQGy/FHfMthBBAwJ2ApSywFP/lZ83iO6z1HKfAA0Si0o6dAh0/hxjUQZ0HD8efqK
   +QmimGwlYaINi8MiNnKxhG8kFku2DUEejKV9gB39JH6PZDr3uH5JPk7PiNRh+8ACPJu33Rnhqve5
   B3sAvyzBLDhpCPFAwQhFzr6dbK6nfrdnt0dp2j0SQplaQ58c72U9v2/antuo/aha2Nlo38uy6eLD
   JLUe2UYErW0xW3tNRXTXfwMB4+uxZ5VgedDjcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=RsJzanHLaaSDOZdxfCS/lWxtXPje+TCnkBoybottbl1PGquvKwd+EdETIHR2mx4EEyzsXIddx7cq
   wk7tIuA4uPhoi3trv/sNMXrOKHv8SlEYFJF0vkmz6gPaOWcz0DNWi3/mGTDOyIhXisZGSvg52w8m
   QmAPS/a/GEqnexIbyrbxHIuJVW276kLVzwhqJLiigp2mFuq4MvX+1LU6wMqNtts9ra8nFsDIpAk4
   1qpRRGRrSztzz6Zq7pB3b9KZmQfePfkZ7hoe+peylCz2BE6FEFIWpr+kCcESRVOGQg5U4MncOyY6
   a/DLB+Gix7t+ydt3o8hdE0qbxiAdXybnGvzy/g==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500LXBG13GX70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:10:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QCgoXq5iyQhTALtdEeT03gus84
 /SZt2KmN/kbkkznD8mxt4fn0Z8dlxKGrNIU6z9Tq0FFIuAm+b+fcHh5xBPcmZW5rP48bfJx70ovz+
 Td2Iggqp6r0UTr8qhNb83MALf8XIIi8vGd7tH+ajIGkQrUqXnmE5Gxa/sozhjuge09+X0FHB+kxfZ
 h+w8V1KO/i9H0jFi+rQYS8ZfFcWqM0iUavuBA48bsfJEc1Ac2u26IYQVsTEogpcES4L2lZaukHbs9
 tV6tFilWwqfJzX1XIwt3St+XZlrqYsXtxhfaE6WvS2uxDP092sWqRNdEPUfjUj7dTfeGSyFCuMdre
 T1EzGpuA==;
Date: Wed, 8 Jun 2022 01:09:50 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBZTpzF/B6kduqm@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-2-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-2-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 clxscore=162 lowpriorityscore=0 mlxlogscore=323 priorityscore=225
 suspectscore=0 impostorscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080036 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 01/20] fs: Add aops->migrate_folio
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
X-Proofpoint-ORIG-GUID: i5DRWyvcqWB7yR0IWiFe8x4jbk1gWH24
X-Proofpoint-GUID: i5DRWyvcqWB7yR0IWiFe8x4jbk1gWH24
Reporting-Meta:
 AAGAiBEpOU5BQxleE+Hi+JsYU9ou5Ui1C/piCUbvHDjgqz710kk4eqWLEcLDXskl
 4Pj9TrxglgsFfuHIAuqYcQUTpaNN3SQjbe0YWDawIhhhxFnqmKu8Mg1M3xfS2Lyo
 Vd8jrTkYcAu5YsPveENqGoOY0xqLRRcVX20+5gWMBRmrrjuW6F/NA/bqbOUqmsmI
 T1MRH1CRmj+Slujhlt1w2cq1goycOWMuh5JKU5qe4yxy8FbzpFrxROebZ2CsqhS7
 BIR0Li3VIeFtNXxEovNkK6DWjtTLccohMfay1VuPIr1SeCfiVa2FnK62dktC4GYX
 hkaiyeCmgTCx0cqZLEbqZXVnUVvn249Pz8NwVbdfXpxTXGdNefUoN117KMY5gGbp
 QN8cgc1Ho3t1g/+vXk7lAwNYt1+fV6Yb7a7heRqo5Zp+rQdlkulbMhmwBPIW6TkT
 C1lPjjyMKpjv0nTUB5O/uS5srq1OhxuOP+yW3pHSDCLQkFHULwXls+wx6pzhoNXT
 dPfT11abCuHesp5QAIAuBR6ICBTCSt7Ob+oml2ekswDC

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
