Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6437CC001DD
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JNpAqvubqdmj5TLfFYb0chKWVb2PtgniDyNdkSLWN+U=;
 b=oIB1586NNHECzQ8gPDKcDdn2qh202JTg0iZsF3evkQ5aw5aofm/9cOfgmwg5OkRLc7fqSkZcTx4I
   TSnVI7B+qd8jRCjVl8httkQabkRxX7p0rtaSizOx7t51kxc31kX4y8Ub9Xtk5cSCY/IF8b+aU5XA
   HOkFa39CipbxaEWm3BmP52Klcc8jLWKTtnmu4bjrT1Bgz6r4341Z/9e/OTTOivJZPzys459ujqmy
   +rvOauWRtkCl/bHxFzw3BlXX/uNow6BVeUDpKaCc8/5OkL6ciIymB8M0PNeTM0OOu7Mys95NWBlr
   tk6fS5kPbtUBgQxBLrW4jj2VlS0LvuF6u3uagg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JNpAqvubqdmj5TLfFYb0chKWVb2PtgniDyNdkSLWN+U=;
 b=ASmV9vSdCd8IxJ0Ao/mDoNjdmuo/HYAb4Y8JrMDwHGYj5zwPVQghkoR0kexnyyeaR6zUDEogMId/
   LzVzK47qLsMmSpL3wJJM+6r9iFdLTYe41au0PBsWyKNhlvtyQiUBlTt4hc1mHLQuOZeE1pzrbhWP
   rWBtMVkSYwYQStHnEp+VQsOMfuqf5GB/f7JQsvd1HEcmHSz8/GaXO8wWpCpCNVnhGbfB1OP+G+4Y
   TAf3DwAqXuzsq1hz0gzaf9vtnbath4wz9fLkp1GbeP8lmRLfqIjZz1HZtd5KEpfO+GkuQAnpvn83
   6U9ik6ZEZoufjtOECfpXCrHKJ3yio7RY8Ef9Dw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK0032W45YUH60@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687209521; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=qpjhPsoZtT3zx6c1qT4HP38r7NJBMDykzaZw9Kph+ZvXbQN/u7gnWbk0e6ePlaSplK
 fOADWya9FACkoKWMqp9CXjFhwc8vo/jISH2wVv9d7mi+QcGU114HfutvgLNoEZ6W6+3O
 zsNIR/yoP24XSmw7B83+nDrtBRINwdRKUaBX0MayRKA6NeQA4b3GksyrwNcl6uW1Yslp
 ily+E/v+kQFGheC06p5NfMy9/NQZrQ890/7T67de9xhqtBElKcM/RMb7yDZ+bqsJ/6O6
 TQVvIElGMXGUA5bpP6OQV2u1H1Mkxmgja9ZQzuizp89bv5amlZ70zGaPXCldPZMLmPJ3 zAsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209521;
 s=strato-dkim-0002; d=strato.com;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=nj2Y7Ri4R0W6QZ4x2JuvJ33FXiLCKwjJhdChI0lOxtU=;
 b=gCyV3+OIWY0sFKCFHhcS2Ax3BYVApgKCV2t/uDD6qMGHAP7R2ZzgAS5GGIYo8X9hwW
 kD5KYYl+s1nJ23xqyznIFVztEFJ/SlZVvzTriwAWrbXtd/GisRWipk56sGbrjMuXiHav
 2U2NYXaPsrNRI0pz6ETjkYlqmgOWAyONzdorNO1P2fVURvPJ5rnpbUSUYnKn+4RF2GDI
 hezjbDQpmvj34Yuy/51ijZ5WfLK4UogAVl3B7fx4jlWu7QXQGlZBhKvIWRr+OnAm0I6Q
 QE9cnJgfQX5SQ/YGXI3RvUer6cBs4oQWyoHh3V8jriEc559vcbSWWgCMcPzcL2vqLFmI E4GQ==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209521;
 s=strato-dkim-0002; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=nj2Y7Ri4R0W6QZ4x2JuvJ33FXiLCKwjJhdChI0lOxtU=;
 b=EmOMBLh84jYGENmMw3FiyMU8uDlEPBla7puVnJ3lV0SsuxVVd2zrF623gfUbjdMCed
 1xQ0x8T17uQHeljRKoMLetbLd2J16qvOaUzCQa+hXk1gSPq3lj39wGfXxCN4cDmP0dhh
 Pk+SgkznnufrzX0+ZTvd7IW5IyJP7hd2oPK6R9Jj2vrwCxY8Own4wVRFoLJvJLQAPZbg
 +DZd5lNuo9dL9ucE2XIfBYag6o/xMIqKcIexf4kyB7Au9ibE9exxXxPQPmgCZOHNcONv
 XEBEmcc+6LXF2izjII8i0BXKmx0YTlUfqRBnYIqj5mivUILmo8MUkQXXsKvxHcSQQfGj Zu6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687209521;
 s=strato-dkim-0003; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=nj2Y7Ri4R0W6QZ4x2JuvJ33FXiLCKwjJhdChI0lOxtU=;
 b=grxmVO2oXqYiWN0i48AewPi5wFOOtkL09drX1sgR8KqfkktewI0o0eR9KLCe3gO6OV
 1yAtzccL2EdNXHC01wCA==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 19 Jun 2023 23:18:22 +0200
Message-id: <20230619211827.707054-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 81.169.146.166
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 spamscore=0 priorityscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=575 clxscore=135 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 unknownsenderscore=20 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306190196
Cc: linux-kernel@vger.kernel.org, Bean Huo <beanhuo@iokpp.de>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v2 0/5] clean up block_commit_write
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo01
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq7ABeEwyjghc0WGLJ+05px4XK4px0+bSzE8qij5Q="
X-ServerName: mo4-p01-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: YEqGITmUSF14kL40cRgHx8lz3_2KZb2H
X-Proofpoint-ORIG-GUID: YEqGITmUSF14kL40cRgHx8lz3_2KZb2H
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAEtKoQGSYBOzMAK2uARuwy0/FV1ZyEby3HygU0LM2MNchh84fKQwO+oLAdJGHTq
 8ymuFS8JvtPpu9CWfwEEH3JYMYlwjWSWDmAyS9lipNktcovgdqa7n0k1EvfVjsKa
 NFwUq3hau0qiPdSML3/qMvtJh/fYialGNbg+qwqSYnHh9mNtwxhtWP/+8KRLsCqS
 9s8f9x7snA59pZkQK9liz9WoUWMmZCp1u1d7bYPwPajXjah6Lsb8kMbixlCyp0Qg
 5nlwd/rMEe2cLNoZBvwBnjcEb4Cpj4O1Yaw7RTu8sELXPees4O9JOqZJaX5xvnMJ
 TzIjDLcNZAXijZXdVJCvVwX+WpbDV/ktDdJsCscNPRL+anMmPK+7vnY4Xd7c/OsF
 iJcs+78DtyiXWbGvWQSV4bmkrcPQ8SmesrcC37LHSzSXg5yjhnldSwc97+6GiNT4
 015yR1pOrkBPSuzT646jsUjQFYLUS2xKLfD23xi0XDs8Gg7kZvkdeaM1NEh7/xMn
 q7qA8X6Q9Kl88inesxbbtYXguTKPAZzbGJloaBwj2AV4

Changelog:

    v1--v2:
        1. Re-order patches to avoid breaking compilation.

Bean Huo (5):
  fs/buffer: clean up block_commit_write
  ext4: No need to check return value of block_commit_write()
  fs/ocfs2: No need to check return value of block_commit_write()
  udf: No need to check return value of block_commit_write()
  fs/buffer.c: convert block_commit_write to return void

 fs/buffer.c                 | 24 +++++++-----------------
 fs/ext4/move_extent.c       |  7 ++-----
 fs/ocfs2/file.c             |  7 +------
 fs/udf/file.c               |  6 +++---
 include/linux/buffer_head.h |  2 +-
 5 files changed, 14 insertions(+), 32 deletions(-)

-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
