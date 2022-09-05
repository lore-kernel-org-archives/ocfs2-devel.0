Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEC6C6FA86
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=B8tefo+ZbHCOFeFVsn3tATdHG8Azv+RQeju99zE3++TcKx/CmY2ce5aB3JbRFn/12NM66ZCEEGBC
   igc7ZcyJOEtwQHkqyCI18jhvu8PJh6s1li5ynEoAjmwxojgY4EBjD17LRxtYEv/viXNSxlswTEHG
   uVqEcdheJ37C5c4jBpDvdbr9U7Q1Bk/3ggr0gcae3QYy+Fdimm7BdNirl0x/Nca2LHHFODF2QkI4
   y3MQFboopv2faK/YFuC0GlpqVF7Z9CMXLdlDojnMyLP3aFDYAKwGx+qOn9sMdIH/3CmBfKpIu68U
   hVnRenSxF4BQY54OFHjhB8JajOMsJSKQ3wSx8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=VhTwBWvXS7uHBca/dBLSbP0bywmHAO8IT7z5FFRPMA26MSI08bPMg4vMrrn11WKaL2H0tQSCSgjf
   chQ3teeK5xWRGK0QKqqVQRclbAqaUx2LWgzXKd275qHCO4UOvfU/+asB9tYLMrCDi0ts3OHlNl8y
   EQ99KzyYl8reU00V/l3eiGOPBtQ3NZ9lnfUckUsg/68lINjWmjmtLJ0KAIigHPbY1iGearXzT5gh
   K45VZifTl7B1jJrKCBpMR0j2/xnFK9sDvoZVxExqNLU41puIBQ6mqfCvLfkKXhEKx9RrU+sm1rsf
   nLp2Bo76zV8XQQ0MRTOv4ow5QwZb1UWHzxWy+w==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ006QS713R350@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xHrLLVQ7hhBCFSTGmr4+80syfG
 jG3gpWM1UlI9KFGQrAAz9zKPaBEVruMBNzKz3Ngw/tga03S2eUZoEHY68aqCRhpOeSeQHz+RUHw0h
 EeJTzpTB8mG5INCct2DivjSclwNgJRQIH+NXwCL4z8PWj9kjEJV8tR1Dj1cnmoUrd7+xE/4wUwmGb
 FMqXFr/+VVQ6/VWupMIm9nWxy1bMVvGsr8Xy7b3fsnYcLpYXzvTn+Gbw7WSIEPc6wqX1chHjfX+4+
 JgsK4gPF90m1uXae11IWR4MhQu7kH+hJQepZ3ioTNbLrsCoanZUSSafsGIVLsYOII3HAa3Wklt6yv
 98AUYATA==;
Date: Sun, 4 Sep 2022 22:55:59 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPb7wcSs30o/QY@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-11-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-11-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=251 impostorscore=0 mlxlogscore=394 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=195 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 10/14] udf: replace ll_rw_block()
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
X-Proofpoint-GUID: m_XQeyuobWNfMxKbRvJXzX2-28A8D5ul
X-Proofpoint-ORIG-GUID: m_XQeyuobWNfMxKbRvJXzX2-28A8D5ul
Reporting-Meta:
 AAHxvMdLq8JJ+wa7nuWtihrCSMzUFoYlP2DjaDsU7zhLgb2ZqzMnfTRDPSHjLxR9
 marA8swS7MpOhFbZpCN9PZzTkfNtBVIMR7z/2YMJaw5UCPkYWhjkBRc2jlc+LkrK
 7O9xqNF4/n4cYXx6Nb2Bf6HHExdWpmdOZhwOl8Y5VLx2qEDC15IdFKBPtL9DQejM
 AqrIJjbLVNpeKnm0bwzwFywhqEXY7+kpubuGuIUe9dWEIgiPWgQ9/F3pCeA8/WTQ
 0uV0ZrJt1EGUBduAxqXTbAyAq2w/Wifk/5/btMYsAuJeO2KDaStp7PT/VLtUDyDB
 mUnTUaprVEWYMKkCtBnCcoKds1JhOhidP+9DIjr03V1WYyBN5lNOInwtRlIOdypL
 n6tBAHadf8VvNR2jzIh7Dki8chqH4Gid2juBBKJCTttSGBANad1zIcRR8qGsoFR1
 9ulXbxf3AjIvEvVJw2YWStj6wjE7TFzpZVkaYdHoPAmHOhQAc/wI//8Q2RZOjVO3
 7QN1snYhL/Y7jlYkv4SxPYLaWbqSKFx258+1w+y9YN8=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
