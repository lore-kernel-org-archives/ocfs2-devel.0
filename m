Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A3CC6FA94
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=GoxhlHxiHjWZPqYJ+CB/HQV6sTMsl0AG/GlV49Chw/pRi1v3Fa3reMj5qG7c2jzeOJ+S1ECKupo8
   1dOwulWYXyiM7bzJd7buhqnjyyD4WbFM068cMK/XtajIvh0MnulWjoh8bOgrjHs6WmyGJePBh6X1
   641BELkdVbTUiC33pHuLn+bU9+kuuPndFPgLaUGMYh5HXYvl/gqtzTdj7dd7u2tvi/jca/AgEuS9
   DGDOPOVvDvywUR8smj7+FWhJfmI1oFQM7oBrOfHkTZPCDyfUAUcoSiWfY4CQ3rU0PeOu68roXztt
   IM+P6MZR3WIfzp8ldBuCWEKDLf/VfLVo+vSBqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=agRbO+FfOKfL9xhCZ2WQz0UOdVWIGgLh1xUFs1IJUSYFHdIk+VfTUK5vX6pUVlKoaSt14E08aHiP
   9km4uHx4jiBiIQ++HBXJNEP+cRS3LLndvWHmxfIfn6xxQjRfUQLxp2Wkr9gaLpjVrSY9W4HCkkcd
   iVy1DpfvGfarx5lBY7vGQjAXEaRuwNdb0/EOEhM5qKYWyg2If84LGjPkcLxkpmeqUFC/bG0SgFXN
   fCjz5HIUtbPhzKU/2WOL553n4o3CSLuyURf+HlQUz6Bca++L+8qFbJdIYuQlIBP0pa6Bd9xg+C4O
   cr1vG6Ye5wFnxpEozvCdi41q3QX12/bah4B7lw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ005BL70W6770@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rcrKA4ZssVM5s2966RXlKJk/CQ
 GRHxMdQOOWGNnWCPNxp3yrIYlRUxMmh1vCxvMOFQbdAx8hhmZJjgH9p+16vhAgxAH83ESL/Ao1t3A
 UB+1TLy7rXttE8fUFQjY97gGFOoP8fR3iaw5Rg16PZ0LvgchkLApV7iiSxM9JvlkuA1YHmQLPwQgE
 Iq4ruVUotF3jVrifwEm8OmhChA/PzqUAqbi18zhesNRmQI6eoSqoZhf49Ip0hsalei1VB1/s+2tsI
 o167o9FKkKXdM8Ih8UNbX8eeQJCDE7WkOo2VfIOmVJ8rSW6OBzyPGMKa60dgjvV3wpJvuLO37UB5X
 TNhO0hxg==;
Date: Sun, 4 Sep 2022 22:52:16 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWOkPZ8eggVKbg4@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-2-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-2-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=262 phishscore=0 bulkscore=0
 mlxlogscore=424 lowpriorityscore=0 clxscore=161 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 01/14] fs/buffer: remove	__breadahead_gfp()
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
X-Proofpoint-GUID: 1Qzm8bYHoyHF8AhwZ1rlAZ4CN5Ba_n4d
X-Proofpoint-ORIG-GUID: 1Qzm8bYHoyHF8AhwZ1rlAZ4CN5Ba_n4d
Reporting-Meta:
 AAHm3itCa5jQXKfaaGqKNRfy4jpAPHJxFeFXuiT5el8ryqgwaq7A45bOMfTdOmvR
 EUq+cGO4boF5taZn7ciVsrWKzUf2TVM0/8xwkTviVJ+4hbJ5kpoPhYSDksM8A6uc
 dakL0vTNlQ7dg3+SupKLEd5Gnyf6n6ifhnb5nLN0aNYjFPzTsZsbBvEdxNI9YAQT
 5q++kqo34XB5jI4hQDPkYBBtTHt6774eE7uwmvrigrAwrKFm0+R6AuRy2THWIjvi
 5oLL+8Ggs3GFsSam5NPJfCZxbfCjWSQ//FNdb/rHJQsNHkRUDccIW8r6h5seRsFm
 8HDdHWaoWGZxoRojp6ck01uXsIPh0URD4Y43O+Sgy0NTSaVV0BCirFQWTSevZrfH
 wpCPzNDv4LU0M9vH6Kzwk2/RFb+DsIQKpLmHgP5PvbMx1crAickhjku9eEQC9IoI
 ElroxYv0uo+d3rgA6SXgEAvp69G446XrumzGiWVwMK5m81dodzIa//h9+3f/2gt4
 +Is0fQRZMTzN6UwKEOoR9VP6eqWYrFI+t6wUk63y/J9G

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
