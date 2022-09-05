Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D57C6FA90
	for <ocfs2-devel@archiver.kernel.org>; Mon,  5 Sep 2022 07:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=B1Cg0kmyMFvNNwBGf4kBT+NmyIUioAFSzHJXd0oX2s6j9WLANyfZao5G5M3FGmhTVdpfaiJteTz/
   keYoySznu2ii7UYPtladC3anQAkwgkVY5AIxORxHUvvfPm42/xhS2Dko0SWO1RHyURQhDFXVlzOM
   DztSm4KoYtovC3WW+Yg8o98+N2a6Eb5jfmqGiFd/5p9voTtgPhZo+gu1rdb1osaRB9KIP/12xut6
   E69bL1HC9wgzgIKcRkJxPAqyAoPcKmfwzt2eYCimjE2buDLgt7MnmeUmhrj+0V7jImxs0e2drrV1
   esKQ994duGzXZbG/Pu6N1XIAQ4b0PIoEI/HzHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nVAvFcskCAzPBU84JfSYasgwAD57+ShK8EWu9QgQp0s=;
 b=um9GehPtvZw+4Tq7CRNSNdb3Dqs1eHNNcdoY5Yflk1zKggofe250sf8pmabRDRbo9PmKaJLQ/geA
   px66zKaYhuc+u4khiFTlmZ7MuCgZ9XbcedhatiZmabaAcryy3ONuAz1wMK/F5TNrfMPYA6B7FbMk
   ChYUBg73iZ5FB3Fpo1WUxpphGuIEIDSxOwhYNthTw0bVanyIsAmsv9l5xTxveG3MbmOHjK8gv9+v
   uPTJErjTHY5+l+DUOgFM9aSJAlPYUnfVy0hhdRtP2wj8v7jKY3ahL0zi5d/vqYDtEw8a4SD8nQeX
   odluOY9C/vMzloELyglhPMpYCALh2+8H8J+BnA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHQ00GQW7155600@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 05 Sep 2022 07:19:53 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
 :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PWjOWhcVdk5GPM4TapFAteunhK
 eigd0LPkWok89dICZQFJs+4E3wm8Cu3clJwH6WY8C1BKz/+eQgaHoM2Vf8Ns7ayihDsR7mEGTnkDI
 xs1r0aXMF5Xc8yUpw0H+teCBqpkiBmgoK8XHiChbQzPOPBemUlu16JpnydxxohrR72C51Htxw9W4F
 1IMlYX3nbDbcp7Ts1Eb7RmZESCmUyaScjROEpxEcmPM08+cWUb8JAE+1Xne/z4DBoFYBTFTrRUB6k
 DoSP4yf0t2NAlRNjSIMiS0g7t0O0i3WeNbuwIxeZrLx9NHgmvqjdbw2Ewsg99MqTSzeue+S0RjCvE
 cEIYH5Og==;
Date: Sun, 4 Sep 2022 22:56:57 -0700
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxWPqd+Wnpg+wQuf@infradead.org>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-14-yi.zhang@huawei.com>
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10460
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=184 suspectscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=346 spamscore=0 phishscore=0 adultscore=0 priorityscore=265
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209050028
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, linux-ext4@vger.kernel.org, dushistov@mail.ru,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 13/14] ext2: replace bh_submit_read()
 helper with bh_read_locked()
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
X-Proofpoint-ORIG-GUID: 5JqrKu3r62M4yQEO-zlI6ghOeglLaCgm
X-Proofpoint-GUID: 5JqrKu3r62M4yQEO-zlI6ghOeglLaCgm
Reporting-Meta:
 AAEAI6wPPFKqRdylulbybf2KScZuIfrVDedqTWEYtgF6SlxYMQeRCXblhH2Q8m64
 aZ8a1sc2O6b0cJ4YHzLFroyxdm3haOgck9rkpVzYV6wdQusKHio7mCWUJ61CKbdG
 FFd9qJqX9Mw+4x5KAMdZloAmce56Hy422iZrA94o+DdgKeY2bwMB+bRo6fcYx9zY
 DzB6YeT4UCQsoAmO8q4ePg9kxukGXyJCYTWqU9a8UcTWsGQ2VzDVkG8bdPkh516/
 8/AJaW554hG75ev3astD89VEB0OJoypAr3Z+c1C/ilcLJd3RLF799C/XXb/y1WzF
 0HAqnMQUIbhLTLYywJnOba+gCggWT6d/I0yMYM+Zl7VVIkuCkKu5EPPcayB7oTVY
 pO6JIABDlYPf2mKyBgNjaVRClJP1A4oZed+KYY2MHqcOVXEbas6XkFxYh0HErmtm
 BWTHf3uou3HHUkUtaoDwFJ6wmPWjKhRKnXl+rr4TFPOOOI8ohkkxvX1jgRivkpPW
 5ZvQxesNeL9yd/0n/OpzvAo3JrxX/1Ql+BzeYyTfRIvu

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
