Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C34C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YFXF2DuWUaiwLSOj0F3AIFYRSjqJ4XBrqC16qXuN+Aw=;
 b=RXqZr6RSrQAKXwfTLbqh3knhawFePVQIhgWN7TonkhNYLNH+tvaJE0a8eoFVoESrL1+9JtWKRzoy
   8vB8uHeeMvNtVJjzst+4RW6ngyTHOJLTawA7vRV7fUW4qPkIMXpYD4fPDeK7epF2Lvfq0RzendMN
   3afxHS3NPwmAK8VgfS5rSZulzQGdxC5ujv9yFh+c25Qb1P6HwBNhrVapMMVui4BRklESMvle+ZIt
   PuCHxMbdRCwdQOBsqJrYMUyPzZ6KoxINHBL3ZOEDiBrtsD5vdjhF9Fwe2+P0BvkCTofWiwg/OFZJ
   A6o6z6Guk+7s1dJ2xOcC2Bool7vhQwVvxosQ6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YFXF2DuWUaiwLSOj0F3AIFYRSjqJ4XBrqC16qXuN+Aw=;
 b=GH9W5q+04nul9aOEe5FziLYCJgLtRaBTYUNKfik6UIfiW1dsS1mFlrwrpm8q0yXWUDLS7d/5PvRK
   lQHLKfgm0N+GXRwupUVJXwnh+3Xo1l9/nyxMB141FV6sDMg5ibHqdCKVvffcfWcYBjWTnWspPOpw
   PkNOLz8PXqSKTz99kULpsmI5l06sOFQknY5VaSWjHDp/PZ+CT2m0zXV/GLXoWTqr8IpFB5SroPW9
   7cmrdlQYvFg21u+0txtVeOt/McrIZRrKW7EvLMXdogj7sYcP9QECV2wYYqKeIhjbLzc9u5HnZu3z
   /un3MxCvF15AoXPvJuVNbHt/G5gJRPtxhELSWw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HE8M9YU4C0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:05:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:Content-ID:Content-Description;
 bh=L9ybHoqkMQFtFgAKSKAUEOlBEraEcHfvZKxNTrnAqQ8=; b=txJ9J4YPrbulci+oxX/K1jvzXj
 8gms4zn8OqR/RStS8wT9jgDaq6tCr0xQ50GF2QciDZSPopEVcnXqcG9w2/K5XJ1BTwpW2RGCMVDA3
 jmixF0VaBheGVq3jZaojwfuYLAQ4/4Mglf66TIU/khX83gOPm4zJJDJ3ou8TXUFMlSJvyOL8I9hxL
 hx9nNbqp2gLScWmRlyHDlcj4q4nSOat130S2f7AGVfoaMNZ1nXqC2ZbfhhUNn3oLONf4dJ00se0wZ
 /QPbSgFP9I0m9WnIywznAmgQ/IfAzP4kiOxdsv2B4GrBWPwAkOiqBswZsWccIWUz5jFEPpf/f4t6x
 GlFV09uw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:52 +0200
Message-id: <20220406060516.409838-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=483
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 priorityscore=0 clxscore=261 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060026
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 03/27] target: fix discard alignment on	partitions
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
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: DaxiFdxWSpZPeN83SQ-IRw-jxUzxSEun
X-Proofpoint-GUID: DaxiFdxWSpZPeN83SQ-IRw-jxUzxSEun
Reporting-Meta:
 AAFA3RAva8NK0F4DU7GXDKMNv8F81v+/T8cnfcu1pR8JL379nfcep1yVbQ456sbM
 zV01fI0nfl5FvXqvW5OoFi2Uq27gBWiifPScHNShbE8u+KKEuzH3yBxeX7Fl/VOI
 NfzwNxTsW0HRYXKGr4akCuDF6mqG6xXr5srHUwKKCFcg4g2f9eSjNvj0kaKaFRO1
 xh/n+VDcDFBePKWykPye3/T2Rb2cSJDIRtSfs/jpvwsL6HlLvFyDX57KOA8bRNbG
 8PFqhVKhtMgLCEyLPDFXMpTGnWrO45WCfAantmrdL58tg6Zfk5pglODiYPX6OhbQ
 Nzqmv51roUBASPklf46bWY1j0EEz43lhKtP6nh/GHUW9EadsMiRJcnGeBiYcDXIM
 Go6OE4DsArv2jEcQX1rnlmC1n2krNyl3tw8Z5ZykiJCdroU+spC4vkE725coEgW5
 dYfs2chY3wPYZuOvUBLOWpBgcL7mB9GsDbasv3Rq4RTqQ9fZwKlUKbkef2P10IGz
 ASv2gjbwVIwrKZXYFjrdNNnwMvVvNkW9cB9rVnj9mRf1

VXNlIHRoZSBwcm9wZXIgYmRldl9kaXNjYXJkX2FsaWdubWVudCBoZWxwZXIgdGhhdCBhY2NvdW50
cyBmb3IgcGFydGl0aW9uCm9mZnNldHMuCgpG0ZZ4ZXM6IGM2NmFjOWRiOGQ0YSAoIltTQ1NJXSB0
YXJnZXQ6IEFkZCBMSU8gdGFyZ2V0IGNvcmUgdjQuMC4wLXJjNiIpClNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgotLS0KIGRyaXZlcnMvdGFyZ2V0L3RhcmdldF9j
b3JlX2RldmljZS5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2Rl
dmljZS5jIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfZGV2aWNlLmMKaW5kZXggM2ExZWM3
MDVjZDgwYi4uMTZlNzc1YmNmNGE3YyAxMDA2NDQKLS0tIGEvZHJpdmVycy90YXJnZXQvdGFyZ2V0
X2NvcmVfZGV2aWNlLmMKKysrIGIvZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfZGV2aWNlLmMK
QEAgLTg0OSw4ICs4NDksOCBAQCBib29sIHRhcmdldF9jb25maWd1cmVfdW5tYXBfZnJvbV9xdWV1
ZShzdHJ1Y3Qgc2VfZGV2X2F0dHJpYiAqYXR0cmliLAogCSAqLwogCWF0dHJpYi0+bWF4X3VubWFw
X2Jsb2NrX2Rlc2NfY291bnQgPSAxOwogCWF0dHJpYi0+dW5tYXBfZ3JhbnVsYXJpdHkgPSBxLT5s
aW1pdHMuZGlzY2FyZF9ncmFudWxhcml0eSAvIGJsb2NrX3NpemU7Ci0JYXR0cmliLT51bm1hcF9n
cmFudWxhcml0eV9hbGlnbm1lbnQgPSBxLT5saW1pdHMuZGlzY2FyZF9hbGlnbm1lbnQgLwotCQkJ
CQkJCQlibG9ja19zaXplOworCWF0dHJpYi0+dW5tYXBfZ3JhbnVsYXJpdHlfYWxpZ25tZW50ID0K
KwkJYmRldl9kaXNjYXJkX2FsaWdubWVudChiZGV2KSAvIGJsb2NrX3NpemU7CiAJcmV0dXJuIHRy
dWU7CiB9CiBFWFBPUlRfU1lNQk9MKHRhcmdldF9jb25maWd1cmVfdW5tYXBfZnJvbV9xdWV1ZSk7
Ci0tIAoyLjMwLjIKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20K
aHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
