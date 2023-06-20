Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FB8EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 04:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=70JJUJP/2be0efh8sIVEI3Z5DfrF/GtkzZW7QLt4pCc=;
 b=LBybATzj2JsH8LTtBL8H2ugQlVq6CmjMdYW9gi6n4OtNihKwL6DgdPUv9IQ+HtGvKTxY45URW2Dz
   FoT2d2d9IShUcOW4drz3dAoUz36CpLA2YPzLIO7BOufpDZ4sYmU/Vdg1W2reMpwWFr8wOflfclA2
   UgyA2tVLFL2D4J5lfgz8P/KYh4LJl3UPwAUD4wLND14dUBHrVSS/PiJPe98qoEGxdF9x1kNz4g2z
   D/u4nzFW+0yfkH3YbhUFj7oB+rL/O+U28kwBgiZBpTF/GKC8V0AWO9zBipDh/4DZ340C9Hln0OGj
   RakvntT5vUsM426kLU9OPATNQdz7HWwCGloPYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=70JJUJP/2be0efh8sIVEI3Z5DfrF/GtkzZW7QLt4pCc=;
 b=gNqPhAFZjznPt0pzVBdJ+lrh0cRFo8LjkcqqZUWr4eV6qmkhp4K6iuv07zb6f1nDNBHbVRCW2Mr4
   UIsRHrKRkD+KZ9y1E+J9yHetR4CwOWMmrcucn14+xicG+fh+RO7iCkAn810mm3kz7VSXz9GrMA4M
   ye0BYThMYQxBrhBnGnkw2nx+l9ibTaftCo3cje764zsFjlrUerBsAaU/LYIbIRjtjx1ZZppxgrVq
   NU/FsqcnqBAy9GT8qN081dUdxHLZOPmHbEtcgW7eZyMr1pwsV8QYPpUW1sYBabjU0H8y48rERZxy
   vHEb/6I8nA4R06z5yo4Cx5FNxSoPmVTfVswppg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWJ00OUOC1FICE0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 04:48:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=IJtc0dSmvrdtDpxoBDdBZLPgMK+CrBpfQaCUFRKuZTE=; b=xysdKIXlVYrGJm8AdxF81CHfTL
 R53hTcAtaIK4/Wdz2V7GPaDDAbVjZWeX2sAImKPCWK4xbFGJJvUSc3GxJp3S/LOYjldEPyH8TnG6b
 OSmMAZMj1hL5tJsg5vmjXv6o95zaE88JIzozG5KoYd/Q0Vf8v6ql+TGdo3fmkGWitY+tXP5yMElce
 8FT7VE+/j2D8PpL4YVgaQTdKSoDhXcUKhdlleUL7ioMqtNANohbBA5ikhfqHQl7IjkDmhXjBAILEy
 BWPRN7lY2pgW0mLNsUKH5nECS9M/a/v9XfPP4vSISPnRbAEU770rSiUuKC7s9QPoZ2qVkMacR0We4
 FyxEX4gQ==;
Date: Mon, 19 Jun 2023 21:48:11 -0700
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJEvi8CJddmpeluC@infradead.org>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-3-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230619211827.707054-3-beanhuo@iokpp.de>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=202
 mlxlogscore=480 phishscore=0 priorityscore=235 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200043 domainage_hfrom=8757
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 2/5] ext4: No need to check return value
 of block_commit_write()
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
X-Proofpoint-GUID: 4SfxZek0BceZfMiTRNQilyqTg2gwliQC
X-Proofpoint-ORIG-GUID: 4SfxZek0BceZfMiTRNQilyqTg2gwliQC
Reporting-Meta:
 AAFvz8HjO69HYSOUC8Tv/jfbauV7ZXdBQsSI8nXpeVMC+V8HhBuM0/L01AATIcYj
 FFwiSoRuw4tdbW/1o7ZRH0YOrrcdyTZII7kuC4l7gAYCbjSdOc9G7CqYpWjvwsJ7
 eTQao1lt64GdDTeZenMPA6H4+OFrqA1AUDT6PkblSZfReyi6BtapsWY3wmwmXJkh
 6h0jsY8FQhUk9mJd1tAx3BRIUP8NoPbdxFWXB6JQ6NJAGaR0azy/6zuo4xyIholf
 /HYW/npcEcj8Vz5Cz6EH9ON12TJkSpG5RKE7vTcjItQG5/0RRq2/XRKq1dsHLhRW
 HwZnj7CahuktnvPACLYS5VZ2fqitXltzyznm+xfvhoGvlODhlTAERQSrmdvmzYpM
 AWQyV2exrgYxZeWTBK68m+UPkr0h/X+wEJRJrRLGUDmykbpj7ejLHJ2yr1ppL33G
 iNQ9lIyW/ZPJS6c2DChqsuX7wqNsTwW4vXu7ABd5mOZ0gKlfIYJ3ofo/WhktIG7H
 qJyb9CQ+Z6b3w1Bv1zia5HVLi5HNZ7P39IRYDmqqjg==

On Mon, Jun 19, 2023 at 11:18:24PM +0200, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Remove unnecessary check on the return value of block_commit_write(),
> because it always returns 0.

Dropping the error check before the function signature is changes is
really odd.  I'd suggest to merge this and the following patches into
a single one.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
