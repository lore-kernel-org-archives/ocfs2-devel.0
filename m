Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DDFCCA47B
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FQ/9MuNtz/KY7lVzR8NZeuTnB+DjKSM+gokqrb8cm5o=;
 b=XzZJlhPhwx8G1ZeswnPg3g8HkGHvby8CrNKI5z1rzuF+MSmen/feFxZ2Z7MNQDwU6WH5oEbpBVMs
   XCuXcS986u5OsFdk2U+HMbdxCEBt4ULUUU2erSMaUTboalETYAXDiEKHrz5U2XNARy30TwqjxZk7
   XD1Fzx4VfNzWBh8P/6G5ZOqviM712w7+OmwDku/E9Z/P26cdK5WVJeiMYT7wf+9qbDyN7dKp/gkR
   VVnuIstRXiPTY6YfwTJqRujLL5DItN5JLWY5gFdrvF8T5kE/elSmGBfhjBQ8DtxQcmIX+V7eEN8j
   HKgCUwuCbpbM+cJ7byTK5ucnzGpkIuL73me0GQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FQ/9MuNtz/KY7lVzR8NZeuTnB+DjKSM+gokqrb8cm5o=;
 b=LEY/AqI+uMgYgelrHIAFb9s3FOLkUpsaWjbnNVyBHBYYXYR02hAuTU0dC6Q6d9BSxMjGmJ2NnBAq
   pkVYlJFO13gpcpkJ2nJpgw+EGKY6Eol2MBYSBjYAGZXF+1BM6ETkGg2jd5Fj2SBwQKsYTmryh6Gg
   vN3dhrHx7vCOTC3T9nn+CGoBYwtyGWt6McO7YOhvLqy4gQ9TER9Ho1C77F1K7DIusqmGQiGu1O1b
   n/Fx0IQmU1aJ1IgNuUmAxkvsmgR1+tQAnPMBTqLVRTgeIF1WkpJb+vnxRQeuw4Zx7pthPuIqT4Lm
   xB180Jv7w8oGY7v0r/taXqR2YmAY47I8xKiUWw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500L39GICGX80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:20:36 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=QT2oIDeJNUc2ojFPGUttSkHbitBmnZ3eylc7PwUBiqw=; b=DQgbhPr3EtdPNe47+1otY6YBJ2
 glTpzusE/3PlFzZ0wogFOE34/jPjI4HFO5cnQgwwiMpFqBKOgjoXbP0RT1mVZp5o1dzq7DSdipebx
 mskJ4CjHJTxc92puWMRmsM7z6maVcYgq9KpF2GPfD5Kat/I2wduKTfHirJfv5i2KIHVA5JzPDIiI2
 lCeBxQ/yPJDj6/LduSFmHxWv1e4YF2Pj2LlDRD0cYcFb6hHpjmH59it0vinWU2nedskYtbfvk4NqO
 0o2MsEcFJ/qxp8wnZyw+NP5jNLRSGYQd3a/fAKXnbGlN6e5TJxP9CWfFegbEyAGvjblO83DMFzvRY
 7Jw3MvhQ==;
Date: Wed, 8 Jun 2022 01:19:50 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBbpob9igYBSWGr@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-11-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-11-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=141
 impostorscore=0 adultscore=0 mlxlogscore=486 phishscore=0 malwarescore=0
 mlxscore=0 clxscore=146 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 10/20] btrfs: Convert btrfs_migratepage to
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
X-Proofpoint-GUID: LoLY3JGxz095NqlOpWUmkJ-2D48AX2lM
X-Proofpoint-ORIG-GUID: LoLY3JGxz095NqlOpWUmkJ-2D48AX2lM
Reporting-Meta:
 AAFavBLxYAZVA0X/GV/gKC7GMFZYjWf/lVRrhvvv0B2nn2g9Blda2leZPrR7+61s
 bUwYlz/zirmZCEOxgNyVGYn8m2s7biqjr3KZz6pQIzKMhnAH7uAbyNfyIDJQGjJh
 EPSekxa4wrjzcCQDLK30t824Dl7J/6/qLfZx9JO/fszrc4+42JhkkYssC3U6+eyQ
 MDVX8OXoQBR76CEr7TnJJMi9S1sxy7BoBk2VLrypKwrqudn15zuZd+gXozC6D0X3
 TVmNC8JTk+v8TcnJQL2OkEezaaEX3B0BIRNCdQR1OUFfzMXG1bGnjLY8fjOVMZTk
 KecednasDuxypDaVUJWIJxxTMFs5TwtR9se+DhG77ue5/CCNCxYUE82m7iCJGcaJ
 MsyVdhPpwMBfoNUaMx8Yin7SgqU4uMq3IYl5V6sIlOQrEjvTEROK/bwL+bv3alR2
 szUdI/eKkqDUXl2/gCF3BV75AKwNMUfHqZa89SkdZZwCbKUZmtaZ+aSHotjrzsZ3
 OLRjGdbKg2xf5/aNq6H9R6MeSRP2254rumVCMkGeV04=

On Mon, Jun 06, 2022 at 09:40:40PM +0100, Matthew Wilcox (Oracle) wrote:
> Use filemap_migrate_folio() to do the bulk of the work, and then copy
> the ordered flag across if needed.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
