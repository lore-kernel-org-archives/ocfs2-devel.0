Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA10C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=jPGrGyYZSEDPZLDHQa2ub7oHV0ATGjAIlFGRLHiXTaluxShNSg204MfMevQwMnwJ3Ext4VmYkiqd
   YF58OCAcij4ULdfwSwOs8sO3KstQhX29POmlKeQIM5mcQ4R+Qplf1gYPh8Co2RBJ/L/06Oa+NOXA
   zUTjONxGCuroUZuLiPoOXJJLthKdTAvPiX9DUe813g6OFMtUgh07BxZw8uHz0PX0srIycDg6GbQB
   GE805/pbLXMlO+dXzq/I09vej8/NScy6TFWR0vD8ziVyfD6qoXbxLbXRIb1kiX5avxg4W6W5EaIA
   w0vMgoHAPMGf2+YbznH+iT3y/v3yjsO/+vCT0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=rqhEgH0UjJL/EcRQ9eaRGYjDWNvdESeG7LxopYZ3Bam9BIYgHfLGLzNflmwSVnGohY3NKNMagn2m
   qdWGSl3ouCX57UmODEqMH8g4kAv1Jc+R/S2U70sh0C5Ilat2acWJ6pXFQeW0mRyQDle7aqVM7mS+
   wprO+pwS6/CzybTKxLIaC+MOndeuZsGA+mVIiV09/CCOHEmRGaZ22qEndW5LwikaYpZykPiYj1Yv
   zRCvGeqTEA+qbYsf8bC+m/Q0Zaqsi6hICJSp6ixmmc5m6UGl/eqIcDpPaZgakSbZa+e8HdaJcixA
   FdE6x7Z3ZEn/3g2JUQ1TRN2TjZiJ+aWmgZW3oA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500L1EG335320@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:11:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vmZrHfBVmCrJQPN+NjTtNn7AeG
 vzYHLqAF7E1N6FlBfiPAwO76M3lNtq6IjHpokndhKPeihb4rAaDn9aa0t4fSYN1U6vyR3CzZHe1JK
 tR/AvISrkQy513ch9a+F+HgwkKfi4A0sd772K1X/s0qd9uOKgmG/gROajc4qHclXgqqmyiLiZPcA8
 6YAnFkMP/5s24f73YsJ2a+M6zvI+HbbVecjyM0fTltnrWVycIbc97/ysBAnGA+JuE+pdUH9Z2QqOw
 zCtIoD186AsR8ABjamAUXrd3oWAbWUt/W8JQUizct1T2O69L43VrAp47jL0VK4HtEwV272LodDzjI
 uYnBFcFw==;
Date: Wed, 8 Jun 2022 01:11:10 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBZnjIZvr1RIdI4@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-3-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-3-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 suspectscore=0 adultscore=0 clxscore=162 priorityscore=194 phishscore=0
 mlxlogscore=450 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080036 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 02/20] mm/migrate: Convert
 fallback_migrate_page() to fallback_migrate_folio()
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
X-Proofpoint-GUID: UxUu-iIQjilHZCjJ9lT0ifzjkFqWmEwE
X-Proofpoint-ORIG-GUID: UxUu-iIQjilHZCjJ9lT0ifzjkFqWmEwE
Reporting-Meta:
 AAHJO9aEsJOTJwAsJu37n/pbcHb37DX0hLGjbNmU78lmr8/QNzH19izNQ2HZfEz0
 rKzfV6cnkaBWzlDfdb68bb0VlmaS56suk5S1PKZ/FwYbAP5ucLViX8q2tNb2Hgjo
 6QzzYZh/Sicc4MuoVzDhPWz+AMm3jqpQkkt2m0DWLqppJSUXUvQVGPzsy38Tbshr
 d4q4Nfi3xAdTMuEnpKdh36xcM99x4xFeyneHkDa0/+yWoqUBT+0aOolLoQYBCN48
 NZTXuMLXRReXTE6Odo4GbnL71xTWJ/Wh9FOq0Xk182urCWyw6SnD29FnH8iiJ87a
 B7m+6C+jWXeTyC0xVFaJLaU/5udlu2AaQxYezADMj4nVvYQ8mo/ba7x7T7bT7XK3
 cSpqATn53QEqxrZXc25RIjh6oo6BM4u4pA04c5SiankJdbepi74lhgmM6DZoQmfB
 /xMnaMgaxTzjiqejkH++GboTufAhl/yDO0ZSXtExmuF1zoAoRpvmetenh/ySfV6E
 JKo7lwqWrjOm+BgSHbacN0v9nhHmph3Jt2+gi5aNeOg=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
