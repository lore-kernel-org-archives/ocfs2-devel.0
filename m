Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF04C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=zW/wv+fqjz9zokd5pkpnSLSUCFvHcdrm4XGKGVXYrrcZdtgh3eyxPn2fer/EJNoEdI5blH3iPKaM
   p1luTyvIt6DSsqEa7psf/dgHBsLTgSSsqzpurt7huSnSHq1RXk/H2UUMDFSYBbBKp45y5NZrmCYu
   yF2b6G9Sw/nBQXQbPULypuG8zDH8bAYbvw9PpZT/4RlKfLUIUF/PTuaOpudX7TsH8xg2X4U3D53t
   DRnbXPplj3jeVhhmGfbYtLCjTEu7bGmrHgjMgGjQzrUvwzCWjhGOnDOW4idAtb37qvsXXS9L4zY+
   z/HuqWKRxWhw7VvpXlV/xDLAaBFwa6M8bDELXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=c8lmqtmTabdVB5//u5ikbBZ3rd5YMyrdpQmbdiFYblWqNloQqJYgDG14jxSTeYqYRQjU5eZLkyly
   1UaQLKZ2NJWcLaOrm+oHa9OcSTVKdzYJ77D14Q+50B8lpsdOZjJBazL8yvPRnl/08PozG9+Nrykn
   ltxFOAG61bZZ0uFVU/hedc1tQ9EATOL2kgW8Wzo+e7CXO6zvdG1YQOSwbj5mIDG7TvDt5FuMkA+E
   fIUIlRXo+KoWpUN/ACkTtcxiaqDjaYAE1SzGnKjtqglWMCp3QPTD/4PBQscCmKS2lHtRPtvkY+4S
   0PQBbFtH+jOeaIHVxagmBDo75u7LvSqmZ4gPrQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500ND7G86AI70@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:14:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TVP8BYurAveyS5a2ptp5SFIihW
 BuI5q00/6pN2s3gp5WhksU/P8/P2qUDb/FHcWz8IJGjzMTYhz0TfzpIAse4uKP/IW8h+OuDqK90xM
 SjRJm7GRWSpMnGR6q4dcVgc/arN1yKbaYlapAgfXlPuc+cbKwGsd3i+ubdgTTNNVXGAb6Nq9WDy8O
 AiQ7zKq+egS0Fz29IorHKLjedhgdJ1XYLzEJA0nIhqRuWgf4eHgQ8NenhgT9y1HqbXMOSc14U8Nef
 0nmBEWbyDsk0TKpJma4NQ+OHTVhznlBOK3CghLojUexldBYZaAgCEfuz2Dt7vGQssU3/GWVDopeI6
 LKtiBMjA==;
Date: Wed, 8 Jun 2022 01:14:12 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBaVJE9aIkK0xs+@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-6-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-6-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=120
 impostorscore=0 adultscore=0 mlxlogscore=455 phishscore=0 malwarescore=0
 mlxscore=0 clxscore=129 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080036 domainage_hfrom=8380
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
X-Proofpoint-GUID: 35OXfM8OEB_Hh5_G74AZ1usrY2of_BAO
X-Proofpoint-ORIG-GUID: 35OXfM8OEB_Hh5_G74AZ1usrY2of_BAO
Reporting-Meta:
 AAHS/llFst/nWDsg4vudm4OIqE0MoLs/XUJImcy4PdgDDLJfTY3U4GLr1uVcqkZb
 pQto/vKzwaszCLecfdRU9+QRZuU5tiSkt571mxnWGwisbQnEq+6DXt3xODjGANto
 BkNngdEUCqjEsaIXezjrvsIv3GT4K9UF5SuH/UWlZvghNzg9hkK43KnpLh3KhTmv
 hy+TdIFGw18VDaC/A+dH16Lx7b7IlDZbWh++BjGvJKb58LL5ATVFP4T1jL0AQIPs
 E+/Zqy7cecKwOI3RSslhq/iUD+WAa5/2uop39su7B+uosylMColh+TW5mPnzG/C0
 dqHF0c/Z3MDIAqf7g1TOQDnLiyYd3sCLgofxuGcokUJcGalH0tsdakZCN6tQbBdL
 cAlkT58Qw5xXVCxq+ygIPNnx20MS78oNTymPvZu/1yxj1EdqndchqFcMBU4Yqf2c
 U8QfRtyvHAnHa/7oKUmvBPbMhFWOAycBy7lg0+0sFdNdpAMiHhNW+M4HRIddCYgM
 ZLwEXvDFmwvEVa9L9de5nXIqrn0oCL8wQIkMh00+dXhP

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
