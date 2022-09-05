Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051E0C6FA8C
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=iO81qzVDbUQXffqPR30VoIqVvyRFeq1GOhMSoJMNlmruUf2Ysc7f779iwWPnLlhnd1bcOR9zdd59
   Knvk41eUOJohXwPYfXuEF5CbFkhCA9fh3O62gDS/NdtKnrRPZ+lJAIOLL82KxpnDKE6bS+ohg94F
   H7uorTHAtFl3ai0YQOtO3fs0MjfU1n+OpPEUZQfhvguOg9QhcGbi7kWJtbG6IJ5B+aOjOzyxqsOI
   F/Rr+FtO/3eSfHmsXstfihg7nAUSBYXnQOBNgWsFqsGAXV3muFHU0EqQDSovwjOCnv11qsnT3okY
   YD3lCFHnvxphGJArqciHi47/Cmmd3wi6wAwfzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=kKNIQyM7Z4tFO/tmM1O1wAZ1m9luWPuJQ1Z4tNdu+Rym+h87D9ZW48XHfc8g89fBjKii1WdThMGt
   GVnqpJknT8NLgiSjfgCl3uY0mTC21WilERLwQcfGC3nl+dRpJCPrsolfk0ZyZWOsVWZ23IHohvj/
   I+/DtY/rR9bPpbwMrYH2ktaTRku/+lx9pe8BwRJB1VPwoTItlR/6rCzYz0qdDHEZ5OTYyaK8M9BO
   zH4/H+gJ7c6AvcOf2JebPeRrD5g4kPdPKfsyh6dwb6423CbMJZg9VYPGasG/ykcTbMwSYZpBBiUn
   YTZMoURdgpaxoHjDVIDWuM6DSgUMxmrZrOJXLA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ005EA7146770@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GHg5sVinfTggfGMJ3KSIyuI3Iy
 /YGrJm5c86HHbNO/9EqR5wdO2o8hf2t/UbRUCBJ5Bfab0/1Cg6NI9XJ8Bx2X2FcK3sjEaMnJsyEFZ
 xioV1RR4FEASiyHCUYhbcVQ05U5j3829eVMJI/YWj5yf+Io6HdktHXlECbT31vkidNFxPgNbAozXR
 +g8tszICkibzLudqggdy4KvjP6NatYzxnNEJUbkG2gtYSpgOBpE7o6XlbkhHR/5gP1OEORCoKsUUV
 neUeTCzIGxG4XqvXiCsgjTCsAFvDQrSTWVCxfT4tThAao3H9LOvo4uFIUNopDx8mcEXtDTJk7s7WI
 n+PQDD9g==;
Date: Sun, 4 Sep 2022 22:56:16 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPgAkLglG16ruo@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-12-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-12-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=246 suspectscore=0 impostorscore=0 mlxlogscore=394 mlxscore=0
 malwarescore=0 adultscore=0 clxscore=184 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 11/14] ufs: replace ll_rw_block()
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
X-Proofpoint-GUID: KtfBNxiowsTmouiHlEtoraaT0TZeRonw
X-Proofpoint-ORIG-GUID: KtfBNxiowsTmouiHlEtoraaT0TZeRonw
Reporting-Meta:
 AAEX6ccTAlT4zdJEGABcfzgSR+ptUF2Kw55SPYoeeUJiVFqbuMrfUM2JH76tY5bc
 878CUuRDMNrgrwh7KGGHFMdLTrk+GaV15bFuCYZtLEjAAoz0L/YpxynnAipT2SAx
 2iojaSqyftE695yr4ym1/ow8E/3W6zpq0c0M5p/4WhowKJU0xpp7zFwLZsvwxnDi
 aQE2A8rKob5jlm59VL+tpWK+90wP7fjTbwS7B6SKUhSKmeIZqquso1mvcGanREQx
 ToRtg9FdKGObHo1JopvbAYLfxB2Nt2JmiUnWNocYBVbfq9F+cjp6WXGp8ExZNNWl
 RJ6bpX2/A/cCGHbQ8k09YU/jGUis88vwnddJR+nFt6QYBCuZzqKWYzyMI1/DgEfi
 5x30vzYmONx6sa2Br0O2gg1WYvkvu1IEy9QmWENHjX47O2uI0amsBhypHsQvTbLf
 rzNonhVB8oTD9EbOELeBtVgEYeyFQyEOcprhf7qmw6neXKOnPmt67lmI+mR+yI3B
 1u/sON9sKI4uJIIBtU009G483LpogGR9NheX1K+WNQc=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
