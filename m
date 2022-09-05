Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438E8ECAAD5
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=pGp78DjKGnjnTBMgLs6nvjTVA3D2ThMi5JgV48SgZL621NNz+8Y3zY/sEyp1qo9aqTdOqGHrZYkL
   LYsFLEpEZq6A31gU5TQ1GDUHumE2nJ00D/VbwdkuoZTxJ/xme1V7M8j00RslxbKKkiX7ko+bkBsM
   GOohQcTukQRNHbXHjDGgKPEjbaaWTEC3W8pb+QgD52A7DNHQ5smyAhNbvu4ORimqCw+udGEDOWm3
   t6yx6Juk0R2h1dblBG07B7s6lGzD1sU3AF+FqTIiWoJoTNEgYbEvWQetympLOtCCVmyedFIDubIW
   XEwgJg2chGUC3hqAyoQyFJ8ZiqjPEqRONNoA3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=aaVydbbCJXFdbWQS14pDTBgSjcvn+k/8+qHlPdMmK1QLJI0Z1frTfNFoxa/27kmFN03wx3KBkOzz
   u6UH++ASEb17Qp50b1w3AhwtEiIXaUIMmIdGGxSsg0SMhYEYg3gBafa8GhUOfGgW2aaRa5C+R3q5
   mAaYg/04Np0xW0lROCOedbt6hiCoj/ojidzRF7fLp/swcu+VxyxHskRHL0gc9SWwh7CXAylK3lzA
   csaIfMDmqIRvo/TlhHChhocy29Uo/wX/ePFoqkp0yxX1i6Yj6iBhq99+nWBeVIQYlHvXO0ZmioyZ
   jx5UuOt1ntgdESxaABI1p65X4job2qsrfYtvvg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00HG5716WG60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=adBU85hcFLxQUxvxq3SV5Qn+y1
 mVL/kTtlpIFWOwgDNp+R0tTtQSW2wewdcwTE74bxh1WlAUKqTWx2bOzh0GwyIzOaPtD4smALgof6X
 Zypa+MRjxsZ7L7hYGg35t5V1UtuoClOUGy7HT2GrjCuzQCIE20XlO0CN8SD39ESrxfipgpyj92xYR
 gvlwwFiMMACZawjkpxAvP23rkGt9m5Lwt42Ug6iiT2gSRMEKfTtRjTpq+5zhS8ZoooGTOLXptEEhQ
 RGRBvbKdzKHsFCyX3iYdOtIadubp+KLAIGe81DkcjmSO90oGSViaUlApYlxMKqXBy5qDNo3pTMBvp
 M2le5NwQ==;
Date: Sun, 4 Sep 2022 22:57:20 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPwDCWx4gYephr@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-15-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-15-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=387 impostorscore=0 mlxlogscore=495 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=175 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 14/14] fs/buffer: remove	bh_submit_read()
 helper
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
X-Proofpoint-GUID: YebsQeRbyyfFk5WiHMRqDFfbgOSGieWz
X-Proofpoint-ORIG-GUID: YebsQeRbyyfFk5WiHMRqDFfbgOSGieWz
Reporting-Meta:
 AAEX6ccTAlT4zdJEGABcfzgSR+ptUF2Kw55SPYoeeUJiVFqbuMrfUM2JH76tY5bc
 878CUuRDMNrgrwh7KGGSFMdLTrk+GaV15bHSkMeTmLVn4vhZ+WTvFDeCCjcljtZi
 vPuPyhPOaVGwLcqvLFRz2vnuvd17OCDOShqCYM7eL2btQoJg/EqRGPHH6siSoG2j
 iP1V4+xtKkqxsY6IQW6wVi4IkdARbLuBArEqHMOj4p5g0//HQ2mVU0GZCvgu1tGG
 qBrzz0IbzeetwEKAVAfVBmhpeQZjrPAst4dfZbwOcZbIa4EnsbgXng77FAoLzQfl
 uHzAhK4rO/n4Jpq5Lvp29oSB3+U7uUT7KMC9Edk+xvBUKtg45WkBXXnFwCx0BliR
 XArQ4Bde/qY5/F8wJPGBJc4tIkGx3g6Haehlw0CM9rzsvJ0pduUP+0k7g4IIrT/y
 Lt3spRBBwK43U+mFJT27kYb9OHJDFV7Z3HZBtOIKDm4cgoEqeAmOd31oKSVSxZgu
 BmwnrID390m5LIhrbVUOYcSODoq2jCgU0LTQDm2K7pK/

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
