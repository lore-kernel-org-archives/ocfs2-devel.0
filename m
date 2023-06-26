Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8CAEB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 12:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QeAdkySCjQNUluJ9jRRj96eunu2ygJ4CXR58pCMEMos=;
 b=qUIu1bWgIP1YifnxEuHsDjqPck6ORMOqe/sGeyRT7TMzzNiZzVoBln91nNGZVFCkLV0EK3jnOxe5
   /KHlM97dQJ0q7asVhAzlaYqsNTibsxGmTBHDRGceDX8+LUdheC+aj5O0EgAu1E+++uY7BczVce88
   y+vMW6IHOuLKMjvIEYp7JwqYtHyJzLL6aEvwu8qMfKqDj9g39tYHVry8fyFWeFh8d92QRxATysKA
   GOxRQHrxoRaTcfhQae6E6GkNZ/WOS7nI5C6VrSoAgTLCy3UalQDkvED12TgONi4ogEH/5m8cQ2MQ
   6Vid8rf9ejU0R3RgZ15zPB06x2xs7Pu838IvwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QeAdkySCjQNUluJ9jRRj96eunu2ygJ4CXR58pCMEMos=;
 b=lj4EdG+BCFLRQsVCvQd2SFFJQLi2IqZCaSBoWQ/HdSMPg7cQBF/2S8MXRdiHicLkjyoMHggknns4
   O8RlifR/KmdcSxtd2aox3O3IBY6yBrWIgVUOaaLjZ5524hFxybaWnMWBvg3+Dug81ILrjfJ4YpH+
   x7CldGIuswU3hb3eq9g+r/f0ruse8XNqK5yusYvY2FEsaDsxGVYMafIphvOvVS4Tu/61OdRi5CmS
   xFEc/wUQ9QIGw/f7ciQwkOnxM7oaUcsugJb/a6z0/nCLAm4YQy9R1GnSz2jMQb7n8durb0QObMaU
   f/IxoR8N1dmzbYwSuBqJoxqti/O285HCfudWjA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWV00160110WN40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 12:22:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=QW8TEI4qH5XCRgSwvkSbDgPot3AE97HrQk+bQXZ3kvQ=; b=QitTNH+/N/BFpZARCix979ERxI
 b6Iptj9RWzhdn7qboGO3PfmG88sySWpFQ2qT7DxL6W+TgoK93OCGrZ1g/1d9gVnCI0B0voOq1+wi/
 2exEGgCCYkK+z0TLkLYcK9ItLpUdUx/rADWxvJaYAoEpjSfEcLR22gjwGgwzRaHgQh3DozSZc2YZX
 mvpwRPq8SaZz869b/ZAgYhCx1yZu/SJ4bQImIQCs/8vW+0RrxPmf6Q2fEN0soDXZnS+61zR0HGNzq
 bdIJIApXUsUtOEcKJOzovxhjVcHrowVDprRtfLJNJwgyGToLhiAPQoQw6eNi0FcTb2kRzeWvAstA1
 CZWkyyNg==;
Date: Mon, 26 Jun 2023 13:21:33 +0100
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJmCzUD3CYv/ZV06@casper.infradead.org>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
 <20230626055518.842392-3-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230626055518.842392-3-beanhuo@iokpp.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=170 lowpriorityscore=0 clxscore=167 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=583 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260110 domainage_hfrom=8763
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, hch@infradead.org, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, linux-fsdevel@vger.kernel.org,
 jack@suse.cz, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RESEND PATCH v3 2/2] fs: convert block_commit_write
 to return void
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
X-Proofpoint-ORIG-GUID: TOb47APYpkfCnPFcdgKlW96c_-xh0qDv
X-Proofpoint-GUID: TOb47APYpkfCnPFcdgKlW96c_-xh0qDv
Reporting-Meta:
 AAECMX7AONLZl4hmM8/YsnydvjeQa4B9vwKZQaztMyMwtpxlKhyxHmM+i6rgeFjl
 J+hIdyGhd721AMf+KijpQpcuO7NAjAGLIyaUTfxJz1bACnmvtLEAjZqV3I9hembn
 ci6brpSTJ1vq5UGb+22hdWZhn50rdvuspQqK2BBNqbFkbESy5+iEGVQvqwUX7Qlb
 InLVvxZpVc8IRx9RNd+efByEqejIcHVqhpUZXJ8CqyYUird8qxaIUooTZKAK3d6m
 akh1nlMy08/fHKh5Rsv1IckcAId4ujNaEuEkm69BrRQJlsMI6gMbui9nOQWffK5f
 eI0VJt+J2VyzWd3m5wrKYly+L007BrbMhdUcREoXih7W7okYoLq0I1yw5mBYaouU
 h/anjww1xpy0/AoSM2Mw6xdHohpyTJ3d0CpIT5nO2iA7JeCOxIkAluDRfF4vYDJV
 1XRimvUdfsEPlD+vqTsqAUUmFSZqH5sAUD2ZBW4c/6/fbwcr5KUZ0NVFru7bJJn7
 DlwuYllqc0t67y+Tk/Bi0n0Z8nNwL35zP6Exu1DkrSE=

On Mon, Jun 26, 2023 at 07:55:18AM +0200, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> block_commit_write() always returns 0, this patch changes it to
> return void.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
