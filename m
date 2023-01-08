Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B55C54EBC
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 21:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8u6idC5g/k0pcMwVPMgiZGq4+CL40qSQ1Aus4Xd35PQ=;
 b=0hl3ue7SXnVv8xnDkbCvRrRX/neohzYhCCVuLFRKixCnvK7zym/QDupQyiUxt9SpfXDI38DuES82
   5C5s6gessEamRdib5Vkda2x+eX99emc0y4CuBaSU16O00TwZd2VPFAeudAvzFiisy9r3o7nb7g2/
   3o6fQSqGvkQuFUzc0URA+mYX+MFUzlm71vo43uwu93S3cA9zAaA1NKaBf9AMrXPWxkMju2uQWOV8
   toCVrLHUYg3rfQ9BItJNDfh9TPTvoynF1s0KaCNAQqYoRdN6l/kLteyauf4HRdT93D/VB8zXNBgH
   MBi+TKZpWpDgbKDdBkpVYFqrISG//KWhdJH8NA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8u6idC5g/k0pcMwVPMgiZGq4+CL40qSQ1Aus4Xd35PQ=;
 b=J74Ut0RtrpPyMeYGLeyOtWFW/Gxp07QQq7VQ0jBzNd9gUukgFBNCIVRXgEzUYlGH/HfO9M9wpIsg
   +YsO5IPInA59D7JXikq2FT0eVJs/OeptyXFhbtAjSxZyfDGJq/uQWavwtAOflHV4lfZWgEEePMms
   Z9zu7SgkCmSpvo/XpWh527FjwqWTgfAyd1zm9BVG/9363eVC4bHXiRuVvtTvrWAQWfQGUQLkEOCk
   9rshzdESgKfZkgp4b6xRETNw9J+nIqwvFyvDI/LX4NSufOZxz0lZr1w52PONRSzF4OrBs5lczSor
   e8VYq29TCBCjMULd3NGnCwkLUljtsRjL5APjFg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600EUCQZ4TCB0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 21:13:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=D7a/bf8y+hnf1vOEi6y8Co5HNDUBH87eZ629Edw7Kh0=; b=McX6ybvWrIyBCWgMTSn5LSbdcf
 7APZ7yKaIVqF9WLPgmBfFbu/wtlzNoBbY3ROyGkglp13HbeM8A3oRGzZ6+BMUEJAH9bUrRjg7h8j8
 jlnuRAO9JiYK8ahCVcAo0iRZvTw8+YYuRObTqFzqJfpZ5rtMal8H/6UlHDqwwJ9BjjWDY6MY8Um8Z
 RCcqyZQ3VCP8EXQQaWkalNAy69z09vzVgP8+buH64VUk2Ecs+reZ1w8LJ/kyj4Yx6OXcjCYXMg/bc
 tRcKu3lg1ysgOGu92TcqM9e5zmvEvQWgQzxW0kHHAQ0eTN+XvbnRUBtGnPKh92rTN4Dj7inDMKYkO
 KwSoeuvw==;
Date: Sun, 8 Jan 2023 21:13:14 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y7sx6iJPeyfVfkYV@casper.infradead.org>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-3-hch@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230108165645.381077-3-hch@lst.de>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 clxscore=-58 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=405
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080158
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 2/7] btrfs: stop using write_one_page in
 btrfs_scratch_superblock
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
X-Proofpoint-ORIG-GUID: pD_dCdihx7llSKHpgNf43sVyBIUgvoSt
X-Proofpoint-GUID: pD_dCdihx7llSKHpgNf43sVyBIUgvoSt
Reporting-Meta:
 AAHn/LKnUgKV0djiBETkhojnBacEvFKMqTXglEKj/gsyd1z8O91coUTAyReRk+ie
 JTtHnbfXZXUNNiFqmEQSqUAEmVhj5pW4Aab5aBScRG2Os+PEfhHdc7zSEngE8C/g
 3O/6FfBoLZkYEzMXb4lnWkXzRHFLcQ/cMS2rlBjG+7GrH74B0l0O5wR2kfZLm6ZR
 R2aIBiCCeMq5w6YIe/OMIkc6LPJJemPXl2tdaxtITkAbE2HraNETZ+waIrCpQimv
 TQxG35R4DjQ91PTT3ffgEFNwiRTrN6wQnF/tuWU+x6esWBv/FNF7pF5fATLRYZ27
 SZsUYq+EW30fwt13/M7eaNTR1Xf+jy1l6we5c0jHbkxDdRPqP3P86eMB/IRwSvhz
 Q9YshlY9JbYrlGL9Tmih23HlGnhvP0GlzBe0ZpTAtrS30MdN+LkI/U6XoF9j3E3d
 kJM0kZbYyo1R+QuKV5Dy7UkYGjk7kizwl6Q6fN9SaI8itcT5GFYl+VWcL4rzXSOI
 xD6hOYZnMxVTFNdsf5+aSsfr/0+lnMbqJGWKgS6uLg==

On Sun, Jan 08, 2023 at 05:56:40PM +0100, Christoph Hellwig wrote:
> +	memset(&disk_super->magic, 0, len);
> +	set_page_dirty(virt_to_page(disk_super));

Could we make this:

	folio_mark_dirty(virt_to_folio(disk_super));

Other than that, looks good.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
