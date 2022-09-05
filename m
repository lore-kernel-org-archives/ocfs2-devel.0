Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32912C6FA96
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=ejvgyfwNC5iG45c1KRHmM49oO75EbZF0yxqSu8FKWYMHP6IxEoegPlpsvp+ymVFiKOrtwR2HvLd7
   NIaBKLuM234ZwaeVlcMGthOuIwSdl8q5pgEp7aes22Ecnys2kDUNf/ASyPX4biL9DJLu9gRYp9Q0
   HdmyJDPsqSjhFJlzC4Ir2FVbrcK/e0lCJ8kcVLquyYH6nqORbucUVWoSNYUc0DD26I5rHrHNCVc3
   JxboBegwce1OOS6i8+CFz3MaDjrglyLVZJOTPpNOvy8AgL0HcRg7byvkzELHNCHUR+/2b2ZP/Q9I
   bRREdr1ilAckM+YuKDI3s9F2Y9x27bJX14TljA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=bQyw2BgpIRBI4C84gQ4uHylqk8N+j+Ucs20rQSrRzFWAJVlbxFLSRMNUGSOaYZN4ByDA5hk7e0Lz
   82pwcIfmTmdzQHxGna/v0d5XTHrS1Hf867htwmWwkD2pr4wZafigc9FDZZkQhU6U1E62bJqXcfks
   H+6aNzCepMwJs/IOg+ctXI3gyyC1HI94cGmbvooEPdXtkLKGaErz393MA25Mb510f+SEgsYOAGPk
   JuWF0K9AMfFuEa2XQ1AP/YWSE/JDtjUnetlrSRMGU0/BLEuB3yLcdctQIgcwP44rvHUgMQUAdoZF
   HKIaICKjPXNeXp1DFgTd3GZ1oQr22b2rBi4W8Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00KOY70X4L90@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Dx4iopb1PtT6m9CrW137HPiOVS
 crbUQf8yqcmt/1PtFRcr7I7wBcbpU4xWI8B9Thko4B7k/yPL//28+WWNnbi0qIwkb9+x0dYyTtqor
 EHmRCvlz92e/+6uAP4NSaexbWcHB/0IR/bf9+V0JhrrXQp4QjA0xwfqLmn+E5RyL+YodpfAbPbcC8
 kTn9m/ETUH7+V+7eBtg+grnEUJUdiXBE8tsv9N8kTFp9Zub6fL9bS+dG49pWi+CIWrRpes6NFNqmh
 5wtYcti13qP22WJT1wuqXSFeCpeZ63F9caOcrn2b2uc7mJiLb+Cs7LQT5DcdF5OWFQN/ds2YChhX1
 Xr3AhUYg==;
Date: Sun, 4 Sep 2022 22:53:07 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWOw+Vt0K6qO3jF@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-4-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-4-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=181 phishscore=0 bulkscore=0
 mlxlogscore=360 lowpriorityscore=0 clxscore=258 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 03/14] fs/buffer: replace ll_rw_block()
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
X-Proofpoint-GUID: ebedKw6NeW5GEfKYYbuOZ7r31YD_b3-v
X-Proofpoint-ORIG-GUID: ebedKw6NeW5GEfKYYbuOZ7r31YD_b3-v
Reporting-Meta:
 AAH1w6+o4zvk+yLcKnvQvyPadZvw4rgWL9DsLCd5oqcFlphn57iTDwOJyuVeSn87
 225iGt7is+jqIaarxUXO+ueQSh75cXtt64jlHhaMvFPIC5Pq/kYL8PmV9GtHRVvU
 td1Ql2gwyhgADeQkAtB8BnqXlOKdOUF2wdFDfzlXKIXQrVy8Fh66ca50iU3iChEc
 YhHmDT+CFtSy/Lq2oMlh1NJZJUQ83EVqxCmwjcfbv3SyMYrmEU5mjfJdArqiFBmt
 e+aPxLVoGeVmOHykv8ysAg5hZd0CTenvUajXl8UiLTXK5rPxkeLafkoESqEIKs8A
 QV/CRmUtRTeumZnZpjlmA214iXSVI/InGQs843r4tipV0rHEuyPrWbNJ/paCAwvM
 D11xrSdQBpmdqbkwDfmMtBIzCXf+DwY3luSWsHC5jL0+wO9i1IzVE/igGp3UsScn
 Bl+h+gHLcFD6Ge4K4xUNMNHyW9BY2iEJuyc8tHQKNTipfCRfmKdZ9s6SNlEZSTlM
 FhX8vKsFn5ZoB+g0HqCmYxo+bDME5WvQ0OqX7gbY62S7

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
