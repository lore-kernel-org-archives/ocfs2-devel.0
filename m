Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4594CC6FA8B
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=xsN5OQ6q8b6vbbyWrcwWPZCtsCs1O7Q5OxF4cs73M4+0xr2sU7fCpCZTRk3XC7rElmNr/3YFeNjX
   U61mokYEpjzSOfApfqxeq87fofEN0cUT1w2H9fhINK+evHroGe9OL6fdWm46HggJuxmX38A76IH2
   NLrx+QkEFBu7YqKItjXTJ5iIs7vC9iQ8jYi8OZoqMij9OiEkRZigAY7F2B9sdnVgTyyp9hqGa5Dh
   RoWCfzkECc5AZ3HJs+kc3CvzD8g2glOiFB4eksWPK8AIyVg7/f8p+Fz+hJwvOLQyJZCRpfgQpoVs
   9rk0V9+ksp2UPQ5/gQTblWU9UyREi9am6bF7QQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=U308gYebOXnnNWU7Hv5l0dERVLf48fImxokAcRqEoeAu6wGd0NiXoaQjbtlWqRuIQOdMRrT7wc1I
   bikfI2wHSgZtb9+QO5WPQwQkPxmgTUW9BZwFKI8p6sy1/gFJdP7Uu28Ou1vNIozP0NE0bief8t2Y
   LKUo/qwT6GUbeGij2vu6eGmrhRb2s6injSeB0+mBLAEAbwVbTTA4PFDB2FiPdQLeK0MjeMBJsbfL
   UMSo7s93AVmwZGoHyQ6/jT3zYZCywB4cg0Fh7um/1/Jo2ulJb0mp/BsrT8ZsAw9kpkoqJ3jJvKEz
   bVzFT7SWA5iEICvKEM8UKvl7/fafg2TuQWFa/g==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ004S67129200@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2a3YBNGoIyMcHLcXCpj5dgxFVq
 mhHvekpURQrndcf2fnnZqj6oc2Y885QIllvLsMygMunJwJrQr55UecCsqd8siJRrj9qg3xeyQ2Yqz
 7ruZkAoxPEeZj3SJGqD6eH3K0evNGqocBpSl94QJxBvvw6G23zx62OyypWvO4LEC5anKzurnpTGXC
 wgsXHwIA3ABU96ckRNHqNsjxqycXpYeBwAFAWoNO3AznC4aSXr8hpNnKsS2FxJMggphM98hNnv6Sp
 Ck68Yx2a8tqjfQL90f7JaAMijQoj01Fj/kFlQ9S9nDi3vu+AmYZH1JOlNbsJWQr7x1ewJYCNFlYRS
 uTyDA2jA==;
Date: Sun, 4 Sep 2022 22:55:29 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPUd6AoM4tRMuL@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-10-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-10-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=195
 lowpriorityscore=0 mlxlogscore=394 mlxscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 bulkscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=246 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 09/14] reiserfs: replace ll_rw_block()
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
X-Proofpoint-GUID: D_UFLoZiPv27WEaAgfmV1TPnwmmHhsou
X-Proofpoint-ORIG-GUID: D_UFLoZiPv27WEaAgfmV1TPnwmmHhsou
Reporting-Meta:
 AAGkcefqD/vkwsTgIr+uXhjU6tDM5TOhWwKGOcYfAbznBLGPGQWCB9lpkxXlvWVh
 FpnYMGakL8eRbW+vKnxfKjRmpwqtOUJANXajfZO/bUXf9xDSTQsyVd6uyYvxWbDW
 SQGZeu1puNfcR2Vt3rdkFSE1O3e2tzT+grS0yMH778TItql3AdmMxURgovRYB61r
 OliTjjDibROglO6gb87LqC6rd/iIOx7JJr3QsO4Kr/jwL0atiOihBWeSkPl3SviS
 qnrx3JmcsBdp4v9x2CJsjD3tTSNLrxMTu3xHrigWgcrticJrZDZZWfz25Gi9f8Q5
 eq1svaRFRYm2lC7oQBo0jzxnGXmZ97V7T8GadS2Txvyez48uzzD8+G7GAzE0Gdeh
 L/JGZ4SMNMoRs3ZbarSnatS+LquqaOmWNEWriJF5f6FBrOKUTEMdkKW3bW28ojax
 ZLkEQWtdxsfIr1RkJw3BUK66A74kOFahcm+4rSRPdXpDHyKkUmUZhPMgI6TMKCDi
 h3NRsRGG+BHjwxemsVDgxvunev5jnOmJzGZV2/CCBkU=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
