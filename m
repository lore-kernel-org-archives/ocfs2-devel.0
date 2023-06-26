Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2263FEB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R6KDmpKDaMksqH5Y6ZoFGZSRaq/dXNnsbWwjMPOz3sU=;
 b=slRxkfVcpkm2UFl64iIw1IRRkUDdZmfne32CfO+wxwwzWW7buePsL8lzMbjJRZwa2HTm68Rox2+O
   IgiNkAMe9CNUVRLOlZTgTMPFUOuF/BMA/G8ndRysf+3SyTh62lEE3tW45FpgKzd9y9864JFrpJ4F
   Z7bbunZNYnIdcDpNSQLOs6Ty+vIuINRhfQPPekt7utsa/x0DBRZyhdvOuhxM+UloOSq9c9cozMfK
   5EDES4hiAA7UvCX2XmZlfGduXR9u+I0QtAbnQgfKKEZhijcu/f85Pp3nUmdZZU25dalIRBY37yFO
   NGYmZEGrsdIET6kC14CWox7r5fU1GWp27mV0Ig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=R6KDmpKDaMksqH5Y6ZoFGZSRaq/dXNnsbWwjMPOz3sU=;
 b=KmHouytwM2YtaDnhXWDIPD0stpnZ4+wrjeL9smf7SUVLxqvbVgxxhqKgeTNagJlNkpTFzQbus8pD
   IUsQ1OZtOhBcI8SRQF12uIwMM0NQ8YxE9xccAdPZajaA+eSHxgV3XRDZjlHTJg1NiOmrnNF8k7tf
   bYqlo7OZoDp6ozbnZQBjsp6oU2n+rU+TBqTuK8vAA2MRq6P6dbQXExWxoD8g6usjbE4Qw/LupKvJ
   MbLt5ZVZ/N3sTAaTm+YwoxRmut6uGwqznavshUDI3pUyHVjUYyvYAwB3QSRJEeLyk9SVzZjYf7Ml
   D+6jGBjRGHk7wxcPQ1700dc0+ryamyhGxekkpg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWV00DZS19L8F90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 12:27:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=3Fnlcm06KG3ZhOYahi/chwTRVVkhSDvG0K9SeqiS5DE=; b=Kbk3zz0BfOzOZJUrGovlBDWliQ
 DVc4oS4e8s4KFQMM3PWa1fNnBIg/2eIYh3q936RZcyrYe2kuW1PAeKdeixEad6/EGoF4ZpjXq3Xe/
 vGPuiBF0Z/OIm5a1SMcqWIH0CMThpXe7QNYPkVknc+cx9l/s+70tRVs9ocToTahg2S6CdEuWpEH92
 8e4s7psYmG39wYTJhkdnjQrFvribhVHhJwoCYbjuzo43AFftERadw3hMP8Lqk0K7nNkWXxYu70MDc
 D1o2OIB8XBlCWRy+S3Ufq9QgbHxawyR9LnN///ppSLe1tXGrxF+JfMypyKbloYl8x0twn/gOwVrZh
 HPUMQT0Q==;
Date: Mon, 26 Jun 2023 13:26:55 +0100
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJmED0CpVewunniH@casper.infradead.org>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230626055518.842392-1-beanhuo@iokpp.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=795
 clxscore=143 spamscore=0 phishscore=0 bulkscore=0 priorityscore=215
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260111 domainage_hfrom=8763
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, hch@infradead.org, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, linux-fsdevel@vger.kernel.org,
 jack@suse.cz, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [RESEND PATCH v3 0/2] clean up block_commit_write
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
X-Proofpoint-ORIG-GUID: W4KvMIV7pPR_Rhys2dWyi2U9mMdDVnX4
X-Proofpoint-GUID: W4KvMIV7pPR_Rhys2dWyi2U9mMdDVnX4
Reporting-Meta:
 AAFCIBCH01iSJVNpPw+vOh+oYAG6nECpF4l/pFsAtKFwSy1khwHwzTajY1z2sfU3
 6/m0GoAsn7uZoqhdD/Auv2N8hQ2fszOUszVZTYHp/lFVJntggBw7FqEmwrCnwCfu
 itLutl3aA9dzgJjT2yL5OBSngbncoKK2SA13LfRuI5sFNNdg/5xCS7jRinMW/QIP
 BNZpK5SxByeenuXXKEhL2tnWIHZ0DhN91yiQkXXNYvZyqEzMIu02w1n20s4ABj4N
 hqaNQg02VOdZR0d35UL99LwJ8B6wmSGfejXICjKcYXDoofCEuk1K+bO8idsjcFK/
 rv2NQqt2FdvXTOW07H1YYm5GPTyjwy1S95ENp5TR/tizDL+qUUpPWO3wM2dvzYd8
 FL/JnvpWJHUceOQp1KvjO4nGaWnnSm0LN9ZE9OX8CwIxO3bVU1xWoFXz6g2prCAJ
 cdmhxVoKboDpqMLMHhEWbgikT1DF1vImPxCTLTbWQBtrem27MJyQgZt/hcFAs74l
 H6XGKD36+PAP5q9KZjvE5GHnyurQG13novf7tPLjvHg=

On Mon, Jun 26, 2023 at 07:55:16AM +0200, Bean Huo wrote:
> change log:
>     v1--v2:
>         1. reordered patches
> 
>     v2--v3:
>         1. rebased patches to git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next

It's be nice to have a bit of an explanation for the whole series here,
but I think the two patches work standalone.

If you'd like to extend this work, you could convert the callers of
block_commit_write() to use a folio instead of a page and then unify
block_commit_write() and __block_commit_write() as you did in the earlier
version of your patchset.  It shouldn't be too hard, both callers in
ext4 and the caller in iomap are already done.  That just leaves the
three callers in ocfs2 and the one caller in udf.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
