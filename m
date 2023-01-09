Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83130C61DB3
	for <ocfs2-devel@archiver.kernel.org>; Mon,  9 Jan 2023 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=86+9ksuaknEXgIPx89Pqcfsl4tiQHOtiI+UJk+MFgeU=;
 b=bfPB45bRonfy1viz1AHqZbt4VQswzvNH9TzKY3+6zfDpZVMM10AF9SM6oX99Ta/ztz/P54i28rKI
   9d/eKYsH2LtALWs3ONUX7MWrogc89j/XL+LYEicyvglQEbSL5sPfzFs71PUbsL2o9vjFiNRELDUH
   siySA9vIIf6lYui3Pai6VGgPsYMKP1V8m+Ujkrr5pOMe/bSPou6pbubf0DjPnzG3d/6mjXOEeCna
   rAXkYcwrjE67pKlgvuVD/XDG43lq+PMKF2BdU2G7PpdF+LewzHe4632fLp01e1E64Kh5EfAXgGaW
   sknsG6m6Qiv4r0yZnvAF5Rn/yuaeGVSFA0pKNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=86+9ksuaknEXgIPx89Pqcfsl4tiQHOtiI+UJk+MFgeU=;
 b=J18/vd+msZmQEe9V6ZEqXIkhPO8SlW0UnnYgStKUAyQcIEuB/p0s6SWu15QyIve9kXot7va/WPx4
   zhK2Y1lqkZVQI02uh9iNVz/nOjTjcBb5RI2Ta+hWjJQpbLirPxk7K5OA/PZJnIa+mR+oayBPAh9A
   lZrRleoHBj2BVgn67lAFcYUP8fO+bFHbSkZK9/DEC1WBalXwH3GNLNxOqbkhXcPDMoaZo3g8mu1u
   bS5IJ2xP6q1IxVmXJxJBIpDN7kAzF08TZ+JP/0ihQbotE3+Ae2XS1GPShTW2EN3jxSrz8Hv3ZfyV
   TTV49HwHxTl3fFGS5tv509ZvPIEZP6oofJ7/PA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO800BXRIBO5ZE0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 09 Jan 2023 20:02:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1673294323;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uqf4EYPtaa7qRzGaumggMD5PgDktxPAtMHctMr6gLGM=;
 b=r7nHWucU7ucFRP3fhs/qdJJmi8IWTyjhS5HquIk9+er3pou1slI3Tziz1P0gwQy7fLoZWn
 pNhRpAn8fAwQwTWe0YhXV5w9A+rV5vlxyfEnw9PEInj1Ui6ywzhAWlFuJMzVZzgC6gUYUR
 59kJnDFifOqb8cczNf6njyjHHZ3gf90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1673294323;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uqf4EYPtaa7qRzGaumggMD5PgDktxPAtMHctMr6gLGM=;
 b=Qo1EnZ1KxOKENH934JGqVsVzwnwFxxdUsqzwmMD8z8C/qM1N9F6aNZ26bkr587ylrLisjp
 sEHRddTliaeafDCg==
Date: Mon, 9 Jan 2023 20:53:09 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230109195309.GU11562@twin.jikos.cz>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230108165645.381077-1-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=564 clxscore=141 lowpriorityscore=0 malwarescore=0 phishscore=0
 mlxscore=0 priorityscore=104 spamscore=0 impostorscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090140
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] remove write_one_page / folio_write_one
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
From: David Sterba via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: dsterba@suse.cz
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: RfHXi1VdYGlZU5utZFIuwUnkMjQ0G9nn
X-Proofpoint-ORIG-GUID: RfHXi1VdYGlZU5utZFIuwUnkMjQ0G9nn
Reporting-Meta:
 AAHIVx2QzxE18pAlMl95L/EwjP0T/XOm3soOk97zTO3wRsG1WhhOr2zSaxE5NMjF
 KtKRDBTRDaZcCsL3YRBBZ45ayGdjKO7M3swSwbY+hz2l7TBtQJX02L2PLPNrgHYv
 D3pXqbetJHpSAabSN0r81cWpGwUtQ9p4KMrW22X4D2sy55rtsFc3EU3rYyIlMkdo
 1Sv9kzetaMPCTnLFefghrhxWZFKYjDVrJKX+2nSZpLO0+LxM9jJPJWCYPXN8SOLi
 eYk46VOfJB6gLCY+Sp7fhsub+4/ZJJUnkswjPgiKlDF4E+C1F1nDMsBaCSbW9DI2
 3hMY2dFX9a/nSLpt2Q6f2JL1Ox5kAsnwvuClqLESOI2mv+XSX1bBTyLl/IJOUpst
 MUdzNbUBt4fzxa5fyuqBO0L3oR8U+h74Z+J8ws/x9oUSvtdwW+nxbgIrQ/A+1OZC
 AhIAH/DSyAci3M9B25KoKLClWu5zA0XZRfJDb9rO30YvldT7CUL+jJOCvIYd+0zO
 r/zKKJue9qqsgGfOwsI4rRbPCr/Js3uNrPLUUbdGczQ=

On Sun, Jan 08, 2023 at 05:56:38PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series removes the write_one_page API, and it's folioized
> implementation as folio_write_one.  These helpers internally call
> ->writepage which we are gradually removing from the kernel.
> 
> For most callers there are better APIs to use, and this cleans them up.
> The big questionmark is jfs, where the metapage abstraction uses the
> pagecache in a bit of an odd way, and which would probably benefit from
> not using the page cache at all like the XFS buffer cache, but given
> that jfs has been in minimum maintaince mode for a long time that might
> not be worth it.  So for now it just moves the implementation of
> write_one_page into jfs instead.
> 
> Diffstat:
>  fs/btrfs/volumes.c      |   50 ++++++++++++++++++++++++------------------------

The btrfs patches were sent separately some time ago, now merged to
misc-next with updated changelogs and with the suggested switch to folio
API in the 2nd patch.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
