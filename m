Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE853C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=TWSVViwaZHueBbkLY7AjH1i6FJ9l2c8ihGnZ+c8QNwR7fswiPkXfBv1GHGJ3gRUaItWDcmVClmXw
   NypGhY3RbKG1Mk4hSedGmYDQDhDDn4Tu4slaGzoqFPBJcN8QSVYuJx2RqQQOOG/d6SYRmmT1yQqd
   UpsnjpXHeXVx48n30/lveLgExKYCbiOb+y9oz2NSNbZZ9+hO0zxAcaqQhfzuB12e40uomHfksxY0
   YriwN6ltREreu+eT41WMWVVrZr2KwrPm6Qe4g2SDkXBnqtfUq9P2X/ITzXmnysu5N/kXxriYeSuz
   5Su7WWT0TxP6J6EOh7CGNuRo9xuhTPXuOQ0z1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=lc+JKVXqBBVGmfjFu8Mxzr5sQiUHKU183TU9IZd5eqycfwGDToS3gZFuNBay3+SN45Pu4OKgQHwC
   sahhGGmaHeODab4qvGdlIB4CMOx17ygMSGM8nwbjEORx6VgIIMGZ/Hk3tyK2hGeBdJqr1IqGBbZP
   1h00TMX4p7ue2u4gQ66+73fpdL09DYtfCmQd/tiyWBl7GmU+abuaAii0KTEt3OXp0mwqOEnvhcHU
   OClmAztmNUw1gC7J5GjUWsPDSVPqrdEgZOPG5U0GL392KfCPhwMbWr3z9IufrxltRIinnhajzDLK
   CbvfBCQT5blMaYzD37YCiXyGP4tacAvfB1AmOQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500N32GDGNRE0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:17:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2WbpTPn+U2f2onFg/v0ugFnZX2
 3H4dx4JWOjbSiIxRvjCaObhRBsMKq9bC6nF9DimLeLFDWGOlCsGv/SSuW3LbUUlL8RvgfQmeUxUM+
 dce6wUikqP5CBTPslN7HMq73KTmKfguX7enWI3u6HreYJxYvwpKejaImvWjYA7lnUesFItBoQfHgG
 V2KmHEgRMBi52HHO+gDoVYvM3/22pSzpmMlYdOzyUYNtXIiTAmLtW9ScnNrKoXzRIMhuCbnU1TO3P
 fDIvpr0nruvf4dcNSGU9upYdYVaebOO7GYzBSweUBwZRbV6maP9nTpS156IFNymlthsXHiVwXlh6L
 gVtdLs4A==;
Date: Wed, 8 Jun 2022 01:17:24 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBbFE4FPeRbnkWF@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-8-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-8-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=90
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxlogscore=400 bulkscore=0 spamscore=0 mlxscore=0 clxscore=129 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 07/20] nfs: Convert to migrate_folio
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
X-Proofpoint-GUID: JNjDFHICLACp1J44gRASIt8Xd5spgdaq
X-Proofpoint-ORIG-GUID: JNjDFHICLACp1J44gRASIt8Xd5spgdaq
Reporting-Meta:
 AAFvRAfbreY5MMEj4ymj71B5UXtk2/MLy26Q85CcnT8rHTGqHBygFwj1Gv+nqt2U
 Y7/hw39vDUFHc66eLsiU7Wa6kaJJDOtcmJISp+H5gfg4584iuoViFvyxM+NBsQ8T
 x1jf2+shcO3uZ8kgkJcJm7CRcx1Cdel6fCNMkCtBzqpug6bxdpgXNUdFx7yiKHH+
 4fw6/6St6wVZGHD/6RoWTxSApVVjawRw2CMM+7HEyRZknZI7lKYJP4I0dEIT2Ip0
 Da8r6eyt3ft7ZFbuJTAG22iQ0ZS6ezEqLDrK26XqZjj95mXRPquiBGuCV9tB7BCI
 ffz/cjFguDLzYWYU0D4aDi0Z2o1CT76OV37z/IuiPYdKjfdbrOP6kv+jiI4sUFgH
 8fA0qvqjvhZGInASjUzaywliqATbWlAweKotRCZyYCppOl6u3KOI5BN7FvDS7+rj
 V3/Th5BVRNYBxT+FH+tBV+dbr5+UOlcNMouLgQTZf73sa3Kw9XQKKRI4HxpcMDiX
 lzZrL9vZ5gPyuXGBgCba/TD2ZZswYqxroC6JbKbip7E=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
