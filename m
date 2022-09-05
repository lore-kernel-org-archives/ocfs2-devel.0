Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9086DC6FA8E
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=WsWOOupPdTR7qS8M4p0+sHM/URI2uhv1urk6c4dVETH24vt5ZA+XXcsWYhO7+FF3h+GtnNmfyIJh
   rs+Ukk5SUJfQpeGaXdAoFedb135dGtA/mANGkkHqQALOMCMXGPUp0sLzJM9Lc8lL/587pmkPWcoF
   OS3zyG4BbOp0F3Jxno2rTPmCUhUADBndnnBCPAYxTcZ71uamf61bPfS73m2mT0Pk+Sm+2D2l/swr
   9IRjySshAGYJPqwZG1pDHTV+eu2zh2rCo2jxDSf4FBVZrPO1+PttFdKGq9nAzBRXznnDCsZhEerc
   Z0F5g+XUcemyYF4Mi0wcyOzb+brY7lORKcN1eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=Y+pJPZKNVWpza6ZtgIqVzzVGJ743z00kcEChTDNSdW2oRcnbmQVNMZzeotBhEH8/l0ziyJlTSJlf
   XcyxprJxEJXK2mlN2JattuO4Ahj3ArMNMpADjqujXxAxfEj5xacNhK1yx9I/STJn2oTDGvFVS5Dm
   Hio3XPnGaRiH1pPlqjW6rZjSQhGGEH6Y9d3PNwoD+a8aljMElrL1RjmZ8YkGTwZmQeDEflihB39p
   rrvHwFQnVSUJc8yIUnD80VzVOW7xhak5eWr2hWvvvquYROVoBeJj2d5ARcHYr3C1Gf4RKKw8yMxT
   HCSkw70b6FP3iL7uDWJnFkmHcy78k2Oyr5FtWQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00NSK715UG00@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ONUzWbeQWY+A+ipMdURSaJBzKq
 ONpaW4WtmPCUYEm0k7zA4rQ7uaIPJlvEjIHectIQ2U7TorP7uPj7SJl+7ZAwmdgJeaSi82S+vH5ZM
 BNiRZQLM4fnqQXIdh0CYTkWxF3TaXZIsob6xQm5aRh03pB8uLUiElfJslOvpZ5E5ULqBw2SxqTN2h
 x51WPoCfN+Qr96oyRUGpSQQIzPmqciu5wxaGW3Z3UkzTfF5wWC5RaERasHPn2EQu6PxIHE5ameRKw
 CJtKpTiNPEr3C1EP7GFQij1hdVR8U/Uq+SMny9VoBaYRClTSCjnFbnAyhR0k77/M9PfsiOSrwM9UL
 nF8BJf3w==;
Date: Sun, 4 Sep 2022 22:56:30 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPjmoiYuRpAVkT@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-13-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-13-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=171 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=550 spamscore=0 phishscore=0 adultscore=0 priorityscore=264
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 12/14] fs/buffer: remove ll_rw_block()
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
X-Proofpoint-GUID: bLDZfW173tG5oqsGoY_a-fTgnO_Cg5I3
X-Proofpoint-ORIG-GUID: bLDZfW173tG5oqsGoY_a-fTgnO_Cg5I3
Reporting-Meta:
 AAHm3itCa5jQXKfaaGqKNRfy4jpAPHJxFeFXuiT5el8ryqgwaq7A45bOMfTdOmvR
 EUq+cGO4boF5taZn7cissrWKzUf2TVM0/8yBPK+8Xg6JxUAHkip5JQtV3TXDp6SI
 E6w5ERjf5+JckYZpQ/KvwQ2yL5kXdNK+Mfu2NLBDlET+Uk315f1L8vPezpXiXR77
 nJDcSLd/baSg751vclHLI4SpSfrvmN6rBWjpa3GpyxW4pfIE3pV65EcBzo99tIe1
 c9ulJd/Oln6DpHsn7vIgwkAm5+rX3f5cdY3feVaNFGaTZJEL0hg/Knzx4vS3iujr
 r4X6fktCWYJEF3W6ypVfUVcqpuSj8aTvpaxK6SCfxLYg9rHHomXzuNbipXvhm4T1
 oUYs5eiPGrxdviNFGJTYwzPASUPV7cC4edTOPMhuNW1N0J4VFfhD6u1E0ZKlOfSY
 btEzx6c1bG/U3BjtXLRIem8LEP5fakSvL0vgeqdAeaGouz8sj8BLC65/etg7IY+D
 8jUPB+WKtOXTCWpYSapaqIqI+Pc4kcaiqlJ1acfYxPo=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
