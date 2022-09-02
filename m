Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C305ECAAD2
	for <ocfs2-devel@archiver.kernel.org>; Fri,  2 Sep 2022 00:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ppghsEhIgext2w9CpEXFpmcwEJ5QDmTNIMBrvpHgE4c=;
 b=MZYYv1qnVL6+yVu3VJIKaBwGp2TwraCwIGqaFEfCYgXcijADAb8tSQw1xBim+j7Y6blbwmQAkNVz
   1IdSO3MMLoRKer1k0tgcZoMp8dykkGZESRLBZwN/MOkTtUNk36UVmdhzAQX+DcEszSJb87FtQZxI
   nqVSRcs5Pq398BL4CBygunHna2GMcKys5yXAfDTfS/NqiDqne/OV8ZmYj3eY0JMeq+8BjNNr2slk
   zWUic24XxiUaXTxbgzQh5pBKvk1baMhgzx3Ju0CgLIW1AS3GQl65Z/499Hri88P7UqIWvF4OZ36o
   LXjBfYQGNtfDbj2h+Np4+rF3Pxv3tDwf/j0L3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ppghsEhIgext2w9CpEXFpmcwEJ5QDmTNIMBrvpHgE4c=;
 b=qGXXLX2wldr7fpo+5tz8INcLjMVmpGzByZeQe1zFf/RyShI6aQvtRvyBdsS0zqbyzZ2ctZty22T2
   3SXhN8hiGq+zbXVbP3M4S4dvxHfN4Nx+LyCbdFGqbxOypNEbE0GVzpLJA4BWC7vAuQYdK2t243Pr
   PPgK6goFTMXbsh2Ysu3Giw1fDQDgb6HaIJo5scRUNGD5nYnkdps88K0h/oW0V0QxJc2f81nNDyJo
   408/jw7LSFvwDtACLxYf3EM9enBRHEzlKwv0ud4hGwb2fJFppTkgJAxhZ8VXJOnqbSlEqctR4X+L
   0a9G3YnT9cLxOqjlWwQYuVieLJgU8MN67+F1nA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHK00GDY443O6A0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 02 Sep 2022 00:31:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=GX5ACSnHUYsKqlVKsOWkZfXxafThifKnGC34uwcAjqA=; b=DbYmmMXXFvXNfgDpO9j4482+k4
 Nz/X9ykWbPXR+tXPE74oUAJ0OHbE9QtvPBH0RB+KhOhadNfv/9vrgLGMZ9+wcWqW7VAXVhOOV75o3
 Lyp0DTiKeqdG5X5L/wcgq6AV2KQXb4YXndw/JP/Aa8QfHL/MY5TYTY5oBTXvdipUZI4bUozQSc62V
 G79pth6KqCUyuRd1yAmlYDzOefDPBD5+eWrkNtYFbHAmu/C5JyvgY4VkVrl2IKWqdL9t6r60x7975
 QXEarjETVKU4mXg3H7dYxd785+hlc7hbFdkioaIy61Ow0kOmryox7Ch1xu45qKOEIBiD7GapJh6M8
 S1/0C80A==;
Date: Fri, 2 Sep 2022 01:30:34 +0100
To: Zhang Yi <yi.zhang@huawei.com>
Message-id: <YxFOqimAyJNxuPM9@ZenIV>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
 <20220901133505.2510834-14-yi.zhang@huawei.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20220901133505.2510834-14-yi.zhang@huawei.com>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=721
 adultscore=0 lowpriorityscore=0 priorityscore=60 impostorscore=0
 malwarescore=0 clxscore=134 mlxscore=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209020000
Cc: axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
 ntfs3@lists.linux.dev, jack@suse.cz, agruenba@redhat.com, hch@infradead.org,
 chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 reiserfs-devel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 yukuai3@huawei.com, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
 linux-ext4@vger.kernel.org, dushistov@mail.ru, ocfs2-devel@oss.oracle.com
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Epl9i74pi3OXyaa98V9EpB16_9_GusB9
X-Proofpoint-GUID: Epl9i74pi3OXyaa98V9EpB16_9_GusB9
Reporting-Meta:
 AAHQWmdgKAMBmh7ui2gjBxjaZ2uZfzj0iTDi8MFX/hoUH/RLsJ/xzUuNYMuJcAIo
 22PnxS/kcHK8h3e6mThKNccP6U1IcpH8Deld8ssf0XSahSFDbdhEDkZRBYpQeL0L
 Xi6ZzB4qVSEmCNepjp5ebZ93XOrKhny013p+bp2T4xKIPOKV38UF/fT2Qr1JIv/9
 y/VWrGHt+jMqo4MetrzGOjX6qnoS+pGCQRvH0I0nVhV3z6MGtpo+mMsbhXKG1xBA
 2lPokAcOnszDdC/Hhbw0ILZl32AginVfViLgtvyYJy9qu6+UiKkY+/1DOFmV6oFX
 IO5m/vqBHxMoDVunKXTmXL5gmTu26tCekXeaFdI5Lkl+ibZDdYn6UIqP01ShRDww
 E4JHvVP3Oplfr69cSvwxkk1DbLwyOBjFSh0b+LvStjNIx1ta8bE9XlpB7lTVGlSa
 HhJBD7ukC92aCLuuxGAdV98SoK4A4+p/g9qWMVgvNb9M1WOBwOKfqL5y7TF5fdEI
 IjO7l6tLtaidNpqtT/F6xT5z2ywmO26Fan+qyik7i4Ku

On Thu, Sep 01, 2022 at 09:35:04PM +0800, Zhang Yi wrote:
> bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
> has been integrated in bh_read() helper, so switch to use it directly.

s/bh_read_locked/bh_read/ in the summary?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
