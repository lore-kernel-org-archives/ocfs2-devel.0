Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15EFC6FA89
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=vBSuEXWq/BvPo67Owg2RcgjMlYXb/HaSmoJTKm1APzhqiUCNy8taSOltNLjIzdJLjRYE3s7lb7ln
   AtrdPqVU+hfECxN3yZuS9h740cWREFkpx1FXeJhs6dtkLaOZHTFQivyKLtpjjijIUAtRhCDLWO/e
   Y0DI9YkmIS/GlWBPM6Ih9hufsMBQFZ34mo0tNLjqPA0erEY9LlTTMNancoIyZvI9KCAxjFEXmoix
   u5tcCfn1QVEL/spuiXfBjSpvQRXm02w69v4p8JGhQqQxABcJsCZ+NjYa/iSRpfAnpKn5aEZ2D4dL
   /D1bc/jTI2rHGsh/LUJ5MiUirQxQpCWCduL5dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=kIF2mCzJ0usGT1uJNsakjxk0fKgfnaz9iz3pf4o21iX7hG0SZoKDBmnQxZC891FxH9jr9mKQHAVB
   YdGcZj6kKbGzyIL9K8fxAy3kfpDnEs5grFeEJmCrMsg1CVf26c6ya31MD9VLaDkkHDWD8L394kjS
   Adgy50Q0Xd7u71s4LRCg0Wz/0e4pO+NtN8LEAhA3ROvSQAquTdgGF9wdMex53zqGSTPHtX82Jce5
   ORZehi8ZNrwy8+ExG8CSLYBEgpXSU54EvvephAC3zvHGg63ACvuK11/OWPgiXE9l9uvfZgd4ngs6
   yophx0hRdo+eJUc2c9XI6G6ngdwoxTQRy2Yrpg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ007NH7121XB0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XpyaPPtSxTmWLeeRV6xTMEhi3Y
 54zGNsjW5Bl/8VMqHZVPihZdB2ooAzEMAPZt3xHGpW51TIDcchwwWnWlY4ZZ6Sy2akhZIKEqxV/Eu
 lJXM+1GxtVMhoSLO/TZ6uE7oPJOqyQ4YbDk9Hg8MSh3q3WFMkmlh6g6IRftaxy4mO9MlhuYcOlRmI
 BfGwJ9iDzID7OQY0cGhQauFprUKM6kxv32TmKliCFiP0NrXVoMs4HCkViOEVWNqJSN1PvtdgiH4W1
 JaSWyF2LFaVlkjUUtIQc/Q74TG4oLdQTMIpASPndLLaYWmfrL/vW7jD3XORGfrTDlVdAKgKYWIkzh
 KBm69LXQ==;
Date: Sun, 4 Sep 2022 22:55:14 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPQrhNkZd8dn0W@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-9-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-9-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=276 impostorscore=0 mlxlogscore=394 suspectscore=0 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=180 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 08/14] ocfs2: replace ll_rw_block()
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
X-Proofpoint-GUID: g6-gHjT3ycXCf7M9nzp9s8Mde8W2gPKp
X-Proofpoint-ORIG-GUID: g6-gHjT3ycXCf7M9nzp9s8Mde8W2gPKp
Reporting-Meta:
 AAEAI6wPPFKqRdylulbybf2KScZuIfrVDedqTWEYtgF6SlxYMQeRCXblhH2Q8m64
 aZ8a1sc2O6b0cJ4YHzK7royxdm3haOgck9qevp2zrB9qt4/CT+crU6SpLJsbIuFK
 n58crSzpryUFMAAmDBY3RmnD+2OUPke2pEueVgjPSyv32lzybHdIkNAoYgi+KTu/
 CB4Mb6simoTPYHt3uwlFCFhQRafM7ft9FYyZiiyVbEM5LV9A57DU6inAXn6+yK/J
 H5IpneDcltnCOPFIl61R1jGnkSPhlVSATs8406Hb9qtyZJ3tMzj3cwwRITFnyDd1
 lGFMsyCLjo3Mz4p3gGtpRU8loqTL6e1jb4QU9iYVuLHAfpHHTGbqG1FH0R8WQN4j
 wW4WhPCneDbyp0Hw/3jXcjCST6sfDl87BhldXf6OkzRbdJSUZ+8zXzDeiuGhudeV
 LhcIjFGvLWL7vyaZNqjn5cUXeySD7YuYs23YPP1cEcB+jv/I2LxRt0mAfMgfyP7E
 QW7M2RX6veMomnAnjQT8YqFJyK6pEglKGDsa6xK+2Rd6

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
