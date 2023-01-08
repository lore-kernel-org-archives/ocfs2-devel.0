Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC2EC54EBD
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 21:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=igZGUNDD6IdM0FKmktZrp8KDu6XRh4b2/do98reOh1k=;
 b=BZVOzRvGQVa/9edKV9MW7HTqgqSKx822BGE0RbpKxhRzo+wJ2JaMmqbVBnv5hQVIZ15Vu1GstAxY
   y1UaFdMoDSM2S/ZmY7pfDHUQUjTc6g6R+7O0matNK9WUnXu4mXFsAlPsjWTl9SI6+uAvLZrdQwUb
   kWDuL+dFuVxvlUKfzWWckKoztvg6UQmWB3Cb3e3whoyGhUFECAqt5S4pp8zgwpKJF8UNML4zi6QB
   3djIeTkwKypYw1L8UQdDK8DCMq3gpBk4sSqyDU7JOYhASI/3g6DhTjtx6SgKQXqFZjQ10/IAWoJv
   FRusSuen8CMEF8WvThpdF+yAfEa9egWzKeduMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=igZGUNDD6IdM0FKmktZrp8KDu6XRh4b2/do98reOh1k=;
 b=ImLgtysDcVGNTi+mEFqOtNvLdK5SufiWVjB5dgaNTYP6VDj2lf8C0G5V9r19P700YplEarXgiqIn
   iznKVsErfuMoJgBginNHx7ltXWFOIGUnmX+0AXgm2fmp++9sIIOV89cH8GBY9Rzcen0/8qvGRjVK
   uIpKocfvnc7r6u4XtML6kcqtYyFKYZYNmXMXheUKihrNSXSCwAFXRyYXQI8ToXmSZsDpf7FbikzC
   0On2zcjf23wJrIojo+Kj4YFwxWWTlQaBuprObNwaE2RpdQhlzdsX4WR3N1JdTfJBkorSVwScw8fY
   k2J1EhW6sctJ6JTt6BogiCac5vtowcx76F6fyQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600GC4R8Q4Q00@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 21:19:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=smtf3b6c0YiLyegeGcE2QFdIpMIIUxY2QjH9VIZPeqs=; b=LwRCSfg4lurhfJplbjaoasx+AK
 i9NeK9Itn6mhZyaQBDGH8TsyNknvvOz6OzxmWVVH2jlqc/3k/698PgjVLLVYaPEjFaZdELofoEm8c
 w4wtquN4FxNlPO/Tyk44scz4/CWeWCVw2QzvSZmJwjvQ76VjjJJkcBRdiiH/CGf5OOsRAAp5NVqPF
 KodMj3MQOePSeDYwwAhqMQA7DCoBX9hicB1aN6THIdKISHSSVBQVgxGVetK6Oy18dlTXXLTtq7xk7
 wQSlhxVeURFfEUK6vyKbQgKfXUvkaRIuXkjROCzDp83BpM0eSnokETYF8b+nY1OpbJXqWeD3RaIoF
 zcJMPD6g==;
Date: Sun, 8 Jan 2023 21:19:22 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y7szWmUKSwcxsaMu@casper.infradead.org>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-5-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230108165645.381077-5-hch@lst.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=11 clxscore=41
 lowpriorityscore=0 phishscore=0 spamscore=11 mlxscore=11 adultscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 priorityscore=230 malwarescore=0
 mlxlogscore=92 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080159
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 2XRmU9Y1sMqTc8Y2u5YHiQNy_G78KElU
X-Proofpoint-ORIG-GUID: 2XRmU9Y1sMqTc8Y2u5YHiQNy_G78KElU
Reporting-Meta:
 AAHw/Gct2hzzYEO2q+qu8vXWj7FoRvpiTbN/jbiUuRbHJeNq72hN3pa6CXZnJA8O
 r4uGc0Jbg+Epdyylm8/wxXtoGxD6a4GgP/kQzRyXo1xn3SJ/OeW8ayW6GlbV5pzm
 +mR/Jqxrz3UJYm9lnErZp12AKWa/CSezFek+F4mrHybIwE8FWCqGvzA3wC5HkfWk
 EFV5JtO72hNiygV3mdaQssnC9ITh3LAiad+f4+qFNtxVHKjAaJKgDVPNm6hXzW7i
 JvfNDvULXAOOOhhIUpkMboKySrX3zhtUhzY4fXwy+9wJsyLhayoLOud8osVsdDQm
 6P33GnQ4mOT6QD5nPf4vICwCNgA/BBjSF3NwD4KcQ06L2XUknk3So/FtNvKQqSeJ
 KOViEcyu1++XSHQQk1/xRicyklEHmSAoBBOEErXiiNSNWy+fYl+dgpI/Xo4Zmhqk
 NLsiRNRAHIebunzg2Ib5tqWAklDIuPYc3yZ5lv7macSNZO/Xcwa1Mk+KXNentbGP
 5Sk1EnB+HAbJwB2G+QZYBp2BDfCalT3sLDm4Bhhqxg==

On Sun, Jan 08, 2023 at 05:56:42PM +0100, Christoph Hellwig wrote:
> We do not need to writeout modified directory blocks immediately when
> modifying them while the page is locked. It is enough to do the flush
> somewhat later which has the added benefit that inode times can be
> flushed as well. It also allows us to stop depending on
> write_one_page() function.

Similar concerns to the minix patch here ... missing assignments to
'err'.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
