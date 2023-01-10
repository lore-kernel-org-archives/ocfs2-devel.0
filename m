Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C39C61DB3
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 08:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UgFgq5UjJpbJe9Pz9eYHcnpmt/zs6jI5Fe+tzkVZxZc=;
 b=asmV1k5y9exwqcGKksBe3v9FcLeIYlxWvP7z6C2eD32vdXP6MWzeurqrEpCdqL+v7SSrzXwvQyrl
   K34TSK6JfjBWO5aj16C/799mAXhjwp/NmxctBcTToozN35hcSDVu57OmuZqtSwRkOjtjB0ZXbmmR
   qOnV1ksyclUmPhou4CvlhOKF/o5H8eDsOgWMk7I9K+SSq/zxObIFvjzaI5iPOgRd0Oai8TlKl4JG
   UGTx4UYm8MCTOARUh6+phbq8XpQnUN8qQ67vO+Kqv5dLrr54wsihrPMkFdPEwqTp/JUSLfnAgmd+
   Sczhz2to7Ls4eRDhEL+IjT7rErTsroqSUO8NEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=UgFgq5UjJpbJe9Pz9eYHcnpmt/zs6jI5Fe+tzkVZxZc=;
 b=Ky++fM1VqUv/iRCAq4+hGF+YgNgDR70xImO9vB6YjvMzbrmg8Hj537ziuZrVoOIy08i2L3fO76gN
   p/gWiOFklId+Ag+v7Vwo81X1/V9YPDbY190hUezqMaDGLJJnc3obDHHMwe6ewNUH74Sq1mZiOcX9
   olX3iDqxqWr/STMD5edbLCgKJYnF3eqAGz6oxWO8zBS2jvvKulzBJX/f1rENDgb+0J93kuovTutO
   ZqA8znnWFKsIxmy8KeoxHV+6X4H3Al3/lpN8H62gx/N1W1EKoNcOC0OmQJuyDGX4XiypLVKzkH86
   3jr0HF4fX36qCBRgS2oXtVmWehJ5J2ltSV1D8w==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO900O1CGPDKT20@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 08:24:49 +0000 (GMT)
Date: Tue, 10 Jan 2023 09:24:28 +0100
To: Matthew Wilcox <willy@infradead.org>
Message-id: <20230110082428.GC11947@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-5-hch@lst.de> <Y7szWmUKSwcxsaMu@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y7szWmUKSwcxsaMu@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=3 bulkscore=0
 mlxscore=3 spamscore=3 lowpriorityscore=0 suspectscore=0 priorityscore=0
 mlxlogscore=158 impostorscore=0 malwarescore=0 clxscore=222 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100051
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 4/7] sysv: don't flush page immediately for
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: gEAjzAEmDpEeFB2kUbtT9jlAqQ2WAtVD
X-Proofpoint-GUID: gEAjzAEmDpEeFB2kUbtT9jlAqQ2WAtVD
Reporting-Meta:
 AAEOjzj3O7t3sKDX3U38JG6fxU84HivlKYmfklaOJP6pjvqr5xx9OY5nnNjPm0cQ
 byGdKVo+xkYWZMgR3bZTtwjG4jhQj+K9Z5sAxNELySkqVAxw/i6fUG5qdAq/jZWW
 iCH/6taYOsXftd1UQmRN+rsVCu3QY2ujhbRmDfLHFQYsylCPj/fDE/h1X6LY61FC
 ZQ7tvFGsWrVAcRRBkTB4XNJ0UdyimHH8wv6uNS2LDJl7Zr3MtNcXZrpIIX3NZbGX
 TXGkmL+Do2wC5fFK0na4YyqqFGxdaiDiDbAtYKVIBaG7r8pk2/fBNCDC/9dS2rfj
 TZU9Qu/p9wqnLPHRdS4+USB30y9gFewYmF5rOns2z6SQsRj3rRed/RQm6KO3MwBi
 uihJqe46kezGegKIufEz/uUqXpBL0UkANwjVPyyPKYgH0l+INmviUZxHCu6b9aGT
 JfGpvXpBOqlFgZto+d+gaL1c2WhWmRDGanzh73UJWkq5NOzreBcJUlDo9ZIAU4l5
 wbMJpUcwvssEKxi6Xjs1R7CAfX80qHIfSCXu5hUEqHUI

On Sun, Jan 08, 2023 at 09:19:22PM +0000, Matthew Wilcox wrote:
> On Sun, Jan 08, 2023 at 05:56:42PM +0100, Christoph Hellwig wrote:
> > We do not need to writeout modified directory blocks immediately when
> > modifying them while the page is locked. It is enough to do the flush
> > somewhat later which has the added benefit that inode times can be
> > flushed as well. It also allows us to stop depending on
> > write_one_page() function.
> 
> Similar concerns to the minix patch here ... missing assignments to
> 'err'.

Fixed.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
