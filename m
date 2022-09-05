Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A62C6FA9A
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=0R4fvslNUWl91lpwCaWN4FLFg+h8zNYO6ORXvyy82bsFsWsxUSaZTe3CdmUF2D19t2yvNKuMa3ml
   HJPLed9DWzUZF79nYlE90JjT/BwE6sWlIuyonQ4OH4RuG5f9bCjjwWoVFnppFUeMzJ3v2bS1X3ZM
   LP7o/nfoA76yxF0ju/a9VZqWuTjSLzYqBVuw+Ahi0keE+6Uc+dUJOZxLWBWZdLX1zsYhRYm20sSo
   kScCCZ5ErPNPfm72qPglFxPf3ub9dsQWs3EOU+kTzAA7QgSls1ObgcI0SVsfRnjjb5iigPVZT3zg
   dqI1anTHvVeLsjk0G7wJ08qw7i5rtSP8b2VoUQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=bG7DjIS41oSNY6gmws+M1vx6uNT1GnJoZlFD/B+7NIH62dX0U/TfNRZYvibbhGKRuRejwt/U0EZz
   mfi6KQ73brIVOPGh05CEzFFmTCLg3fqRoyh8HC1l70iwKgBer9/Tbh4xiw5py1SmbjJytWEEma+Y
   GQwg09Z8SjwG5HmTp13kyzZZbNThYnrv8totSqCmMaJwZEWp1iMIcxLpHeN73yx1sSPpjDEDHhbO
   3RaRF/jCh24Q8QLho9LxYKBMERjKAkSW5Yn7J8O9CjaIkbOJk6lsMXt8VEl7L/7ANiBdvehWcV7v
   5iAU97dFv5i1We0jRtg8pb0xVJgSsN0e1sqUDQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00KPA70Z4L90@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=kQz5M7cactBBREqbBBZOBGfipP
 rcBfqUWCmw/z1So0qOCVWdhlBUK/BwYNH4TIS1Q1hO8Z2M9LlfWFJdlrvQZ2GQTaSCp4RFZD9/Z97
 UcScN5niOc8ie5WnDmNgcBfXwhTdZpriyqytaH7rTUeanTyXpoMzAwVo0jiOxCmVAKyqUBhUWEv2c
 O97kl3DsKD+gtO3bzsznQS9t9uj2jSVucdGpPvFLfEyUHGY5aijeEFhNMEhqC1YDm3ffpJFo/m5wj
 9rb35kWJHvaLBh4ppIUe3DNU0FINaz+KPXKcmiYwKfiEPisTdf8p/wrjW2YuZf/xyc15joyXW3nHh
 +R7plbeQ==;
Date: Sun, 4 Sep 2022 22:54:03 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWO+wTg/55C38Fg@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-5-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-5-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=177 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=394 spamscore=0 phishscore=0 adultscore=0 priorityscore=164
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 04/14] gfs2: replace ll_rw_block()
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
X-Proofpoint-GUID: 15fWTuiVuRoYJJJxV1y9C6a8Y1winPx5
X-Proofpoint-ORIG-GUID: 15fWTuiVuRoYJJJxV1y9C6a8Y1winPx5
Reporting-Meta:
 AAHfluhma9N1CXUfQEIxsIcBSzzaiCQXN1xLf87B6YaRnhePEOHuEnCvFjbUpHDv
 MRErtIs+mRLw/6iVF8JNzVGfKelgEqUr/5+TqJJXqYIM+vtm/gQNC/03E8ERNjez
 yusY4kxtF0rliHEcGAkEcVz6N18upYO2v75wtc11GU4pERsqMBl2vEYIswMna4Of
 hiqvA5nWkcRPyxewMPzg8FfY+LiVx6maTtW14YPNTPRPAHFH7S4/2Ozf5q8rjKXn
 mXrjsbnR5bCykXhShPonyEXXwp1OFm42qi3aAK0XlVVp12VrQkeR/TU1957LoLVR
 9EmXWeqxKp4W8eqoA5ybhQkkMFIeTZIzi3He1SNT5tVmmI1mJnfHbsEOfnkMmG7z
 Qbt/Rd0nUlQVmBYUaLrA6EHHVcWTWKNNFSkBdjSqCmofGK/2XOZq4vHhqFX9X2M0
 xIgqVaSYsig21svpXhAvxYopcJCgVSn99/2Pns6gd1w0xma2/I2oTbbWpJwv/soV
 B7XK4iHf1en9hO28dS+R41QVje00RoLaa0c1hAOj/BQ=

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
