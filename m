Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270ADC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 08:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YWf39lq2thBpB8AKsSIjZFG8FyEDX5IeC2Rt7PX6ssI=;
 b=dsDPtnTwZMVavaYZv8YNXlfgo2PgiNfxKgb3ZNpaj6xeqvyGd08gtPsT2nKfuFW0Wr0liwd8qUJ3
   vtAZAioNkZ8hLmHO43wzYUSb1hAR9N8zPetNEWF2tDXmux/XEPUlrLVEfD0MyypZr7mvMs1UIvSS
   d5861tmUNO+kt/722TqZBrrquBh1oEcvV5/4i2zSr8rvzoV1pxKpqCNP5SlTWBiWAO0gpJXW/45j
   SPO2qEJMFkOMZKdToilgAV+DoKrG+Y9kYX3itC3P+rfr8ehCWnICvygKXbo8br/JVzznyv4BJ1YO
   IvgCyECrS454xxS+deR1pSnuzktVGLjoG2kH2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YWf39lq2thBpB8AKsSIjZFG8FyEDX5IeC2Rt7PX6ssI=;
 b=kLjlaZ7RZ8Y7PWApav5ZNSElhIUppI7G2YhrrBy2gn0vK1NKieb2OCLntxOkii0zGfzn60UzgQKO
   zf3u8VrGE2dW05a8ELe92MYmqC2x4MaixadtLvIHT2ZIRFW7AUwf66OtO/LHNqPT5M1isnXB8DOz
   WDGTcC9x9FqTU+IDCh+lbM0KWvoKjN0dRBgifD09Ybss66TdzFjbecPODJLGIhTB11Y4PTSXeyVO
   RjuzAuj6nnKFxl+aXIDjW+8DOqphrE23Evyy3F+7UfmeuFhHZdvpPwIg4w4Hoc9ceJoUntE09RXg
   qgsCJz2Efvoyrso6361/oN5b8BskIiXF0I9YvQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500IV0GGLE360@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 08:19:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=WeN0C3DdlZFELzEbLwkwOePH1x8klG/LHokEE+8tpD8=; b=wsH9uiJgejXz47LPZei+oWZJ8A
 IZnlV7edXHL4ha1oTvUSLDvPACCVildTVD97JYH+YvS9NQD9RErL2PLvTzmcgr4cEZ8aBBtU7ZwCY
 aHPMjH7G+wdRRxpAX/QKY6yOL0jhQ2PN0eLeui9tcc/n9UU64j1idJz8iDtPo/1JxWLSpPRJL94f5
 NWFciD5tp8SfpISOi+rfKNtyER4G/F9X18tK/5bl3JEm66RhJ8d/wiXf7827VEZC+s/qMucFL87VG
 yj+VOb/XYsvobGBH3310knK3mTGpH5ks9wfGuRdLMe9BXnPKMkPuVQyYjxoDqSve7J4GXAN4+E9b2
 URgJZjTA==;
Date: Wed, 8 Jun 2022 01:19:15 -0700
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Message-id: <YqBbg4zoiHg8z5Jj@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-10-willy@infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220606204050.2625949-10-willy@infradead.org>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=120 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxlogscore=323 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=129 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 09/20] mm/migrate: Add	filemap_migrate_folio()
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
X-Proofpoint-GUID: iWt8aNmXoxf9SdLomqJYeyXqN0MIxQaL
X-Proofpoint-ORIG-GUID: iWt8aNmXoxf9SdLomqJYeyXqN0MIxQaL
Reporting-Meta:
 AAH4Z+nMtmC7p4rtwUfBcvuQvHqCkndrzA/n0+m5uq6aXaaRD0G14sRQjdA/NxRL
 ZhnwzFlyrWuKvP+UIXV9lr+BnP6ukB4TYZpYoOdZGPK9VL9pqn6CZ+cqezBH/73Y
 ALxEgR8WRhaYeVWlDeFkNonMXqaNyclyAwQwrvghyLg1LeonWg4ZOLoReDKLFBi6
 ml9ZfZJPEJ+lzPFIIQMbh8Wc4J9STOv9mOmj+ZeiJ7OoL5ymTOGu490jDmHEeZWz
 bN4XkUyyZXsPHKNUCvDLVYMk272kgMwnxoFI0GkdvBOEXBMzm6s9UOAYlpBo7g9j
 Z7F5w39oX8lPO964WNnieHe4jb6/lfF2k8htrNiNmTJwkHKf0xcsvRz4PEKf7d4f
 E1Hb5KOS8pjicSOxAD8aDn/piPxWRdWF5tMQyfT0xyqJ7WLmALZ+A3EZ7tLIv3OJ
 AdLqA4Xlva+RsyZQXsjm1ojAazQgey9Ur7ifxF9T9/VjKDaThZBq3h9DDrBdV7DP
 b4WdHcVJ1IZFEuqlXUgTG1j6hjL9DFqKUdpa6g4ipw==

On Mon, Jun 06, 2022 at 09:40:39PM +0100, Matthew Wilcox (Oracle) wrote:
> There is nothing iomap-specific about iomap_migratepage(), and it fits
> a pattern used by several other filesystems, so move it to mm/migrate.c,
> convert it to be filemap_migrate_folio() and convert the iomap filesystems
> to use it.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
