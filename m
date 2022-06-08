Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C323C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=itXoHVe8ShweXjUmJHc+/DkLpSthWkGaKAfAgYVpfg8=;
 b=SR6B1U3uVQs3w8T9dIJpMb/YRl61GmtiGTev2LAMvkqq5r++K7bnlpaD/M4foDz66mpPgLfHUJH8
   sI8Du8tN9FeMSYbY/hxK76+OgZHd30OstDBrmaSn8FmjvYT9eaaG3C8K1ssUt+o/FtdUf1q/NGZF
   OXR2J1APmBqRiZLnIffdobVCd592nLrOrm7y5qTZHXpWzIfvLxvHGfUXUpZSTrqeu11OvlM+Cb8J
   qKaKaOCfzAz+6NmMQU4DvdLwy6qkZUyaExiKLUcmtbOshYrsJ1a0dernsVxi1wTlUcNp7p2PhCmU
   y3l4DMsWfZqLCcU/klhQh/Ko2iFEK0nEZRaUag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=itXoHVe8ShweXjUmJHc+/DkLpSthWkGaKAfAgYVpfg8=;
 b=A/6KXD/CytAQvY177ClPJgjqnhMkmEN6i1cjoAsLszgEOFgZ73roG0KQ8LMw0Fmc8UWLc7BvS/2t
   VGmrbAbFW70LQ2XW/JZeocHV625GoqPriLWBg2N/2fJh4fZaji70FVup1GlmVu9OLraRMrzzGaps
   GiHlmjnyEwkn3wYXnenSCK2q6Fg4mOETsLQy6FSFl5FpPWP7ekFwNFMWZWfSNvWH11T6hOqKh2k7
   O+l9hoC3DKE3Hq5ETt2E4556dgMhYIHh+cmwtCKStDjOKS5c0Czci81FUsMW8P/Y3jmAEwxt65iH
   mclGh+g64qT5rbQvWf6ObOJAWn1XaWKYZLilfg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500L28G4Q5320@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:12:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XZpaog3/TCuODd4lbgjHUCLi7x
 x1dw2vGYlLqy0O4P0INgyQxrgGfTRy4wEsy7726U3KdO1hlZ1TtyKX/3Q+mVrxyNhLuNilejbL6Et
 oWr1oU29LE+lbW3FXec5SfhVL/4QSpHDTGPMwWj3jZ9/Gjgz0/wqyXCq2GrNYzJif7Z9p1hjbOCjn
 gmw8YYviv5YBoa+N4qz/e8SdKP0r4xEGs77+sR39vn0hSvQfOJWL+OdZWvqKnac+VAms4uQsKUU3J
 dntDUvhDQaRlJgweGC8KZQuLGbi5RVkn7T1CZiVa3anrYWZsOvgqUMgITIK9P73UMTNZQ6gIUPRpu
 ImsT2ntg==;
Date: Wed, 8 Jun 2022 01:11:29 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBZsUM8j/5ntRK0@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-4-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-4-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=146 mlxscore=0 mlxlogscore=384
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
Subject: Re: [Ocfs2-devel] [PATCH 03/20] mm/migrate: Convert writeout() to	take
 a folio
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
X-Proofpoint-GUID: hYNUjD7oT_mQfpkX7AS9SBtqp0WK4wZW
X-Proofpoint-ORIG-GUID: hYNUjD7oT_mQfpkX7AS9SBtqp0WK4wZW
Reporting-Meta:
 AAF1tUdJEGNt6jAZk02PuY0lmzyiDbNTHDyyl4PejXkB/GRlnwIHpa/qwhaIA6bD
 kQkPIAX+J/YIampU3iVFVhUr3uTlqLOF3oGWs8MPPWfyUVAbMSZDpusQPCIKvoBF
 rU6t1cYdHZwKt/Kg3ir9ryZrsI5/UIRyH6LW2HaogI0N3+xn39FWaIuv1dMmg4Yt
 ng8oMngxmHH3K444Dd0NKzvyzX4Lm+2B3z1/2F9XWE7K9mZ6Jos/KuVuHJOV9jbO
 mJet3pH2U84R1nc3Ppdy1vUZ1HabJBKdgk9jd8Zbz1s9N2LkPT6SLwfLMq3xcFAK
 SC0z7UU9ar14Grov2nOI8H3PGveHpWqM1yYCpFZkCQy8isZnlplR2FcriJKi2pdi
 Mrwatcd3u2Hf5z1cTNE5tEp7+Y8HxeeHtrP7BSSNJOsggyCsRltlCTPxlQfQCS29
 NjAFLgm3sCWOpmMxCu3Ss98DqkZIsonN5IUKEOHH9JwJlZctcytHpHW6B29+s7eh
 6/xlcusdnvYARdiuAR712MyWquVYdyajXI5fOeR+BJUDCQ==

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
