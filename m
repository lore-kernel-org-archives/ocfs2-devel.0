Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1545AC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=YSSl9JJdmDboYdxYmLXPGc2nKqYDFqNpD2deq8VB70MKMHXZxf4vh3xgFOxL/ExwwZNRN/yb/1+n
   g8w12go3aNChrjVjW7ef0ynD56DEVAGt2/xZMamNYCOh0syug863EdNN+1eUTpow2+h8ZZAybHk0
   xQoYGkdB2r+uIWMGgFXdoJKQOdPKY364UV712+qeUOh5iANZiIB5ThRT+/wI1ZG5yYjHPL+lwHUL
   Nm5nI0ElFpyjkPomQmz78HkvwGl+gcFBtHTmzzHTVcZT1cZ5L9kSkN9coY4May/t5+30RXyWNYH4
   CHA5sTm/APqvCxsvgSGcqsPB/vkCYvRs4UCHPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=asLSMFmALq5IHHD7gQaQOmvdFGpg1H/UMzB7b0RFZhjYChY1lofqnXhlcgZ1PR9SaxzKIjU7zW6s
   GYVbY+hssWSfeZiEcQool94HSVyCjsBkFph1kgwdbrGflVwENPXWuTItlVG66pOuc4eHVnsmTM65
   Pw9+h0TE7RP4NOQhCnh9xe8EGHH388AYuYXD9h4gJQPW+QN1j+KIqRM4IPuoVEn++XQknrFdC2lL
   AWfIuuYHYE1gkKDUoHX+xe9qj/ADVWtagWVCJOv/aFD7GKxfDy8H/vDn8iK684T8DETfRyN9ksuc
   BeLT+6EPZZYYKJNcOW4xXeojleq/l0x57lokPw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500N2OGCANRE0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:16:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FO21TYVkz1GrrEA1IBdTPO89xn
 0ZhoZYnarKm0rAuq/YROa1HKdkFK7QK0hedDX/nrx+C0C2WNrc/8GnSud7y6U9FtPf82+dd7N0Y3l
 YkFhhl+68leXo0KExqTjSVhImfkr7x818ptZ7rQAQnAkTTOK+3RQ8NAQ4BjzwC9dwB3ryaKIKFgst
 1az6zm3xoKy7M0JoPyTQjX3ItTvX0lzR7C46szzxNnX5fxrRlYwh8C8eGy+4fFWsfWohqoXnJV1lk
 NUoZvYeV3VZL9xeXVFDRQELmcTse8V//KXOCpI/WLAYTfRuTB+WtV9TBIRC4l0VSz8+pKNnzTprVG
 gQVinkwQ==;
Date: Wed, 8 Jun 2022 01:16:44 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBa7ENPoZ1ofJZj@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-7-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-7-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 spamscore=0 priorityscore=194 impostorscore=0 mlxscore=0 mlxlogscore=400
 suspectscore=0 bulkscore=0 clxscore=162 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 06/20] btrfs: Convert btree_migratepage to
	migrate_folio
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
X-Proofpoint-GUID: 9iy51YgC47pY3S4BpM4yTiDDjxqjFXN_
X-Proofpoint-ORIG-GUID: 9iy51YgC47pY3S4BpM4yTiDDjxqjFXN_
Reporting-Meta:
 AAFGNSJR4rX/CwyTGduzWUJA/ncjlffhypss/P5dm3X+fWBs0U/QKyNPG4mlNQAs
 /QYisRAnrAY4S0P96T9iwSKEC2XM0ejDhYm3XI3ddXf/DzM++auKkoSRy1jJiH8i
 g/CXg0jEzUWOAofKw9MSxJBaxUOvDmDq0CzTq9Im+qXUaAuRO7YZ2EF5FPEX0vNq
 p31ivCHsuxgTMCGm0xlpm5ckeuRLjxDfYKJrKkpqkd89hIThcz/UXD6TCUHz51Yi
 vZtqOOsZkumeSXW0VMNZLrn77EXNXy08Nr/m0DMSsqvMEecG0JLB4ps5ZV9Wk5zN
 lYtzg6LoHHQDD0UReFW4s1RrtUl6tdlZbVfmt5XZM4d2mzmUTFjlvUHBDD6739Qh
 8Pf4kFb81qcrUXes+h9X0xEYUn7tpNPPGatoOHaJ0XshPqrCgYNPkCiSCbNlVqnC
 EOUdpVHN3qTXyO8+mqwPxp4xWciPjBwraeQsK+3P2Tff6b8PWP5syWrsEmxT8FuG
 9xBgdvMu9St529Rc3juuYYigItOC9sSI1uIe0rl+xyo=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
