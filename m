Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E263FEB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 04:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=pOnnVK2pcCCTCfxSqcFloocyKUZ2RTX30e6krtXifSq/7Ud6PzfaoE7O/MYe99MPEgPi/WHisW1O
   J7geEbiWtKNyTutnOV/ZajR5HUAQToicAQxeSHxYng+BSi2WY4Igkpn0p1j32+unxWasAoEutDMc
   uuT47ImP8p38sqCYKVs8JOuBhQRV0JAg5yry5OoBU1b7fN9c37fVVva8MmdvydApyVp1ntYuN+Jd
   AIHcw17BxZ0bLOZzAwuqcvGHOuGeHdSwqUKv+StaSxlqj4J9veu6Qnlo5gDce6CFeQmt6iMR7lRq
   fVokFeEDYe37NKS0f0oGiAloaJhRxBCZJxmUbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=Y02NG9hiErN/c2MrfaSdrP3dnCbasa6/AJiG2Aho8bTtvaWFprP5muLY1JNKtOPCabqU6CbTXUUh
   idaHNiCDVBZT6jjALAxD2EqlM4Om0x862SPSTzhyz5PP2XYh69tZMZG6ieZ5NeVKvxw0+WP/o34c
   0tLmljROko8LEjsh2VupMA56e19/DUlV0juGI2eO6WDwzzH5DGcYQEDS+XhZyhuVZeajYaxE9ALm
   ufbWJjcs0Q5MMd2fI62D7c7IrB1GAF9b7jKzk0p0FhHgHhyn94H3tyLNCVvhTyU7xDVoTcN2MGVy
   kLsEtOJzq98Fl4QUxe7g/aAGsA+8O4ChIjjh3Q==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWJ00OTMBZZICE0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 04:47:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QeiChVQT7tf/l7Q1r7WXDXzuDc
 TUlhW2KdJXT9248CtsyQTjKq+l52rQWzR5Xz/uDubkihDnIMkUIRceZXMDDMMkpojDdqnjPkoCd99
 lU3070zo3zB/bo0FtUjgrKJL1VdZHp7A5Ccs75otFSejpC2zp3b1r8Jeij/2+oy1c/crzCoUsk5Lp
 xDeim6QG6dfaAgLHxCtuMBGC5voKWbIuUnJQ6LQfPk40wKBK3lRAL1qmPj44rMJbbZDzDbJKMyjvE
 ptf9lH/2i2JuzSRnRXWmifvnt7K+1fSokzjd0Lw1CZBNfZWal94utyqLlc8r5iqmprb2r6nm+4mXA
 gTh8vzVw==;
Date: Mon, 19 Jun 2023 21:47:20 -0700
To: Bean Huo <beanhuo@iokpp.de>
Message-id: <ZJEvWNvZyjyEI4lJ@infradead.org>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-2-beanhuo@iokpp.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230619211827.707054-2-beanhuo@iokpp.de>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=111 phishscore=0 adultscore=0 mlxlogscore=375 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=204 impostorscore=0 spamscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200043 domainage_hfrom=8757
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] fs/buffer: clean up	block_commit_write
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
X-Proofpoint-GUID: wz9zUGlKpCH6WUsJe9gDzbbyRGJl2jgC
X-Proofpoint-ORIG-GUID: wz9zUGlKpCH6WUsJe9gDzbbyRGJl2jgC
Reporting-Meta:
 AAEHnih7P1xOK9J1w6m/VWyxjhaV4F8r8U6JDVm0AqL/jNF6kCVB6f+PJV4dObj1
 fY5TC7RXqH9QZe04erBrCnd0brYt6MSkjw9q5n2S7g5kX/bj/9d5iz4KLE1I2JRa
 r14RsBSMRHq8vQSE0WOxv8I2tTbEgmt8Gmydsb/pPb6GmUrICdiCpYDhaDHyLr1D
 uyWq1No8++obiqw+TXyS+ZoR57pHDlekCEzEYuW4KIMmS+GWXuQByVfPHAINMsMH
 827gQYnnNwc0l1Gj9uSWEPxMoWcj5jIkYiS38fC1Gs2ki3dlSeMDarCQTTuykd6u
 OkL6gg0H7uZDnXDZyBfxidsTlS1utZNvyn2ezxXoY6JRpgHMXLvnkQRuOJR7g4sU
 z5VwB0YTetHSDUOXI/KiVxDGNh6GmCPa/3xuUwK8HasZNkf6ni81Tatabc2TY8Wd
 mU2yCek6Li0IvNEhk9zdrTG64+WPl6Joye+h4MRG32jNi0fnNaUtNQrrblU1EBV0
 bVhc+bI/xpg0ehVue0FODNhCxsUfrIoaKeLtqij8cOIB

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
