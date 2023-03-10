Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643F6C6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 07:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=12XXGOy6suu2C3COLDuaF+VbOIuqAQRkCK8W1JbgaXw=;
 b=Ggz562F1sIkKTVQRbV/SAkmZ+DUi36wUgONkhs7mV1Reqf8HhjmV/e3ujwprJgNdnSytDBRcWSUM
   tWocD0HZWBosVFMiVovmGBpEOZktOIWpk3azbAXdwpu1MwicXm8Bl04K5sX645CHSe5iUSw8UcPe
   GoO/VsrTTjoLK+CjosWAEcCs/9UwDv8UIBs3lfPBogreF4Ua/TCxkkrpW2oqFeNrD8DLfHyxd+G3
   JMxNYOPvQBGKgnMEVuhgUTx+CGvfRK5Fx8A6IYxvI5e/dW7sjI9c9E/g453NeIPZdgeNPINnYi0e
   XifKe4BRKxSds8EZUkit+1fG2O1lhlB9f9eMyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=12XXGOy6suu2C3COLDuaF+VbOIuqAQRkCK8W1JbgaXw=;
 b=oUhpHUyJRGX/IJnmEj0qeF6Z8bBQh6X9ugaR/gMHKqhffX9x9WE/hlfTvssVfjrs4huwcGXC2/6A
   pkgB7k0ntxjfCfX4mKN2FFZKyzGQJq7rFzwGfq0ZV1olzGRCNtcaVxVemg1+Zh2yqN5FaHPl1qOs
   xIWDBERfGDuImAWYFqZ6pHnorf850rUu/ObSOwVbm8tJ/QjZWZcFpxkYXLHTj9LXsriGxFmPDqiD
   CStKhYOOnBq13IUeZuf6kdHfG+mZtf39+LznM3hA+gOfkiU8QKKq4lD9KuhAuVZFP8XD0FG+w+rH
   /9UxiNSTiKScB7yxqlZ3ut7KHm4T4Cg8L2h4bQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00B26MJSWP20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 07:09:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=EDcvvrQIIqqj0w26NDf1+/t5fnp1BRSxAGSW1ypGQIQ=; b=RAkcQ7ImmS2lTehUIQeXCjKfWe
 gDjW1Oxl1C39goN0YsPidlehNPnMZ8naXwWEIZqQGdju+dFDdmgrkMO4qIBupT3j+4XBhM8l5xbyX
 nCRQTWV35y86IfOnPWxLn0eSGVHRfq5WckAyEZxoQf7q6/62tjHLnSPZg4yP3u8BVCRvDJaocCnta
 qng6KHuff+gmazh9o/ww1jRDeGQLhKPYd4yTkoI2ZmQgGzen++y+dVZlNHmbl6raBYtpfxuVp42vN
 jL2TWM2gcWlrIX/qGB1HVajNBan8w49oB1xTY4jSBRhrjt8nKQ66SlqTIGJCI1numMagLrs62qTOu
 O/rtojtQ==;
Date: Fri, 10 Mar 2023 07:09:06 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230310070906.GT3390869@ZenIV>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-2-hch@lst.de> <20230310035353.GM3390869@ZenIV>
 <20230310063756.GA13484@lst.de> <20230310065235.GR3390869@ZenIV>
 <20230310070047.GB13563@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230310070047.GB13563@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 bulkscore=0 clxscore=157 malwarescore=0 priorityscore=265 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=651 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100054
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ufs: don't flush page immediately for
 DIRSYNC directories
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 7piita9bApdVgyjJQFcz9OLqqU5bKVUm
X-Proofpoint-ORIG-GUID: 7piita9bApdVgyjJQFcz9OLqqU5bKVUm
Reporting-Meta:
 AAEjMpWSbbnqQ5GIU8UFE9Ev7Af7cREV2mFvuGm89K3c53yGihnM8+fq/5+caVTe
 /4OeKDy4xYaHpd3Tth3vw6zWKNSJ7H0+JkeRg2XVqrKH785AWIRjr7EouYdt9lov
 YCuTEnt+NFIqx3ZW7fPDE5aNNYaq4TLrNKwtrW2XFxGFfTuL32fzZtQl1AzcG4Lf
 HcOakc1apZoZEO0o1Sq2jBWLQ/hB2MT53oAKlxTE71SZS8SBmuMtTvnj0AhRGaoz
 8FPQKNhqaVSfNBlkc8dbjreSuL4h6NxtfXPWZjjcy2E1j2S3wr+bZLAzud4+G2ou
 KaEWaHyEFk6o1uMtdUNuFsjqD5vaSKxdPzSTqSJ92eA4GypAZeQzpINEM5izzQsU
 qwlbjpZuZc9Pl8JOzGwR3RG56bT+C99avaQvN2Ng7Q69Qn2jtEbmqysUs2a8SGIK
 xvGfCduPp+R2EMwCsNfMM/pis9aSe3pHWWqQCfufUlbZLoCcUFwRLcrDN4NRVLA3
 NQJf2hbD2UkfImg7XE864QJfMC+VPzj+0rhtyCq++Yw=

On Fri, Mar 10, 2023 at 08:00:47AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 10, 2023 at 06:52:35AM +0000, Al Viro wrote:
> > > > Umm...  I'll throw it in ufs pile, I guess (tomorrow - I'll need to
> > > > sort out Fabio's patches in the area as well; IIRC, the latest
> > > > had been in late December).
> > > 
> > > Well, the three patches really should go together, otherwise we miss
> > > yet another merge window.
> > 
> > Umm...  Do you need them in the same (never-rebased?) branch, or would
> > it suffice to have all of them reach mainline by 6.4-rc1?
> 
> The latter.  But patch 3 depends on 1 and 2.

Obviously, but that's not hard to arrange.  OK, will do tomorrow; remind me
if all three are not in vfs.git by Monday...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
