Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A595C64EC4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 06:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=N/BIdXSMEF8IFj5YTC+eHL4RZ6Vr12YoublaNQqhVhk=;
 b=htdjGrHjD3vdMV162wsHiiWMtzpQereMItNPBeQfIzmbk90PgHbIYuFTsDjUUKQb6g2EInAonqJY
   XiOW88c9lCE+PyS0LnVhstWuYmq7IaNZ0PvtCFEvWrQl2qUD+XSLf12+3cYIZ81vFRm4hw5E44ky
   O5sUyrYSsgtRitPrpWFgXO8SlPdkEU9paX0CB3YwQ2sp6SPGdKYtAykUl4AvJI38psTttd7RsWRE
   GyrFmhMfnCNbeaR6sBraN4gnyEukMJXTU9uuUJHu6vC5UJafuF50ChKqoyofHbQNQNbIOU7jHrDO
   ydQWb4DsUUeLipZGgXMcR7jhCy9LY55MGcbbtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=N/BIdXSMEF8IFj5YTC+eHL4RZ6Vr12YoublaNQqhVhk=;
 b=guAf34NvhXzjhdXR8D0Oz5Z4wEgqi4IvA4f0XyILwVLAwYUi05lqwYov9N6WkKytKq7T/TS3/TT4
   kInI5dUdHVzzkXAyg0TY/cSHEcKsSkVj537agQNG73pGo2yvUyLv/aWbT+6wKi8n99lIVdthfohe
   n4fgbT7cOqzDonCHYNvrU1F/ms0zB5ANQLR4ex9Ze7sjY9fec1bIvFXIunGFyxczKet9pEZsIs8D
   r+4T16iPskFGPOhHOQErymgfsNM16nsuB0pZ8C01bV5NYeyBQGC+2LmY92NLLldsHPGmEXOmQb0C
   EYJ7zU6uaCHsyTy5Muy08WwGqBunSFRaS1fvfg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00A5YLS8IS20@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 06:52:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=7qEqX21YRrsvSJ/y6xQPPg458jfKZDfNP3maNMRHlbE=; b=I57JSnLN/KuTBHkJec9Ueg23yO
 WAuEjYh4TxVA/K+1XP40YCn8q1pC9rah1z/C5JRl760MBSQ18t1rwiNtXtOfbkTFUh67Ff/TFuBbc
 /NjFtEP/8cAAacdHIxs2xqLC0/SKHBDPMsQhhdQf6PluDJlNqCNQrUnUCENhCLFgKgSIXgn8m+Jje
 hCY2o+SPIIq8bKhUjqA+aIhN2gCj77LAVZTv9wjofmBQ4hG4FJp1CVi6xMZADp1B26bzZtiltycOd
 gqoT/aiNmcqLg0X30jmk17GqkAGIkWuEOiWSJ5S0ZodWyOIxRq1IrDyKZ89EQ0UujH6sqc7MKuCBf
 JY9DvpUA==;
Date: Fri, 10 Mar 2023 06:52:35 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230310065235.GR3390869@ZenIV>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-2-hch@lst.de> <20230310035353.GM3390869@ZenIV>
 <20230310063756.GA13484@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230310063756.GA13484@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=244 mlxlogscore=336
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 clxscore=147 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100052
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
X-Proofpoint-GUID: KF0KPbZYCP1R32txyZYa6RFK4UW9uPe4
X-Proofpoint-ORIG-GUID: KF0KPbZYCP1R32txyZYa6RFK4UW9uPe4
Reporting-Meta:
 AAGJmwTYK/Jb1pXM9Q+UJcYLa/3yXhKGLiadtkRYPD8zHG2sospEekg7mRujdbUW
 +gFOZ63rUYa3LQ8SoOKMngaJP88f4r6q5hks0lK5WfQOG020icWbn834WyU2Vk1c
 +exxjddB2nhp4zsqqMj2U4kG4lF5KGMKeggBYziCNmkdZ+Il2D4TPLou94knH8Cn
 myP2F5z/3txjqy7/O71S0UHCPnmpvlYZpeFT9I6ZX/uxtcp+xz3ynTzI8RNDEDSz
 sOl4FHe+sdBRfpX48aI0+LiKSvc4cgDJwH3WJPoOahlu8mRXKnQ01FyVhJADTFWz
 /0OO5/2xWlpDWa38Qs2tqOCdSBvn9T2BH6gWcsg/KGQjtGK4cGpVQKkaSewYo64N
 zBJ9wDk+K53JZ8izRQXOV7P1WkhHVaVYHZxtf55b55VdYpaY1r7/2C71IZ9sHu0d
 iyR/QBEs3FuBnGP55aI9NTTB7pR4M8pjaFKUd0CXXyBwJ8vvOfAHynC+ea4csXBm
 gMqTqxIpKadicvaouTpLoaboBW10vTBcgw8pBr90sYg=

On Fri, Mar 10, 2023 at 07:37:56AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 10, 2023 at 03:53:53AM +0000, Al Viro wrote:
> > On Tue, Mar 07, 2023 at 03:31:23PM +0100, Christoph Hellwig wrote:
> > > We do not need to writeout modified directory blocks immediately when
> > > modifying them while the page is locked. It is enough to do the flush
> > > somewhat later which has the added benefit that inode times can be
> > > flushed as well. It also allows us to stop depending on
> > > write_one_page() function.
> > > 
> > > Ported from an ext2 patch by Jan Kara.
> > 
> > Umm...  I'll throw it in ufs pile, I guess (tomorrow - I'll need to
> > sort out Fabio's patches in the area as well; IIRC, the latest
> > had been in late December).
> 
> Well, the three patches really should go together, otherwise we miss
> yet another merge window.

Umm...  Do you need them in the same (never-rebased?) branch, or would
it suffice to have all of them reach mainline by 6.4-rc1?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
