Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E53E9EB64D8
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l6W85W44x8mi6+lRaN1aZz6ejDvCFTYZRa/1VZUS8G8=;
 b=frhD306OXO4I6/tMuoDcow/8ZolqMOQehV3yeQve4HIuExFTe31t+MnyQvsXeryN1A9dIiCo6nfK
   FO28lqiWLTba1w5ZrxcCzvxAbPLqYMYBk2WMNB2E5pFwTC43Emzw1f0qz+HbUmItKiBXu1dFiKIf
   qUo8Kbo/0P6HNwdIBU2SL5i7QdY1gCq4FIOxkJvcCLfdFq5cwAidvqBhjXy7InzmBxXcs9iVzjnm
   sOF8WnhPM45WDmfSDOYkfx8zAGim4+ah8ZcOvuBt9L22lMHlbOyccOqwDQw5Nn54uPyaJg32znwD
   /Dkxm6KA4rljGBo3Z7JxFWFYjeE2u0YE8ESNwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=l6W85W44x8mi6+lRaN1aZz6ejDvCFTYZRa/1VZUS8G8=;
 b=Ne5GcUx86Ltd1dQlNI9JIg/YRbR/ED0TUEZFqq/jm6xb6ls/RvCdZCFii7X4mzyaFr4wxt2QbFBC
   DrFar6RM7yW9IHehjV4yDEQ1BXi37q8kv3RyEr2nKppcfmx8SPcL3PbuEdpnngnzVLWf3Az8wGir
   imQL9VG8dGIzk2H2eAMGnaiffwT2EagpXFnUv/p9mmKZIxlq0Ub1pI64nuJ4YUjIBPFjbNN331Qs
   z3UkJG7n4v1kqxqtrfWunnzRONq/eXVcJ7ivqwpXU9IoG7nNSL3xYH9yGFJfmDOvRcDFdEBKdqVQ
   k0QPeAW/Uy3NBJBNX8mtBAIo01N1WoPuUxw8DQ==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00ANF45X5W50@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687123982; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=EUvxIJsXeq/+3VNu36tGkHV2ixv0BVbNgN5kkxLYSJre3M5QOx/vRRAtehK4/uRs+7
 pdVVIdp1onJ7yQXDqlpH+WIMQcRHvk3PJT2cN7eA7NTSqL6anxiqzWVdaJiv6FmtZbYN
 cs8y0SEZ/F5pLfMMJ6F3blMkSavzPnajdai9slDgAndml04w4/iu2I6accGYqj0xNHW0
 14QuVRvufbU4r+rcCr3N/GJgQ9X9reAI1vGzOaMfvOabrstuRDcrjph6FrOYcC0WsJVN
 eIom3JRxc7pSYm3BT+os9PX4z/d5gEadrgOuGJLIAW3VvkTAARY6M5gDa3J7YPmcUafT qgGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123982;
 s=strato-dkim-0002; d=strato.com;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=oqCKd+CNjdzbLYFDJSrbVFBUX2kYJx0eW04RCZgiOf4=;
 b=RQF9P9gJ17Ki6/4vOtmSpTWd47fA2+itNvDhalgwjMJ1ky3tid/kNUQzPavDpQH0br
 QT+vJZO+yhRf3V3q6um3TPgUXQRZ5tk4um3tJN1jDgiFOvYCNqIkCb4vrTzfIzsrA/4N
 krulaMKVwue+xBzqEg5CiWdDYDhNvKwuSJohc2G05aegt/UHBQfQ2Ocsma5qt4ERq66c
 Viwvvd6ErIwDGaoT2v7cJV+Mkg0lQKteWxB0zp+Z6JgMbYo9I3TUT3ji6HeXjiLpnRB7
 5IIGUjYl59c6WusVocNH/f3f8S/PUpMaeVzYPLXHXZ3Lxy7sGHy38rqQULbAwLmxGPmm P/mw==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123982;
 s=strato-dkim-0002; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=oqCKd+CNjdzbLYFDJSrbVFBUX2kYJx0eW04RCZgiOf4=;
 b=SynOk+PpYuDNqLDoeQwxQPc4vsJAXAgVBd+7b/a8CziL205VAhRmSRD/sdLbUkcMpS
 M+4tmpvng/YlcZyJjMr3E65swgDv23gduW+EcKjeZbcbhJ93xdqEim01XBlu9I/AGlJM
 yeze88ReWHTqTIGTIBR6Glm/8gbvhGocPyw2ljfPWcrKAO24+YrTcYOyj8zi8belbVNd
 HDshJlGvCW9EZXuN0uOYQikANPGFp9Ute3MQy2NixS/dc/3eg0FztlTNKFdShNumrRaS
 od98ttTrZCBKdAX5UD53JVVfMWD11WM1nfT50T4hIm+aqyaDfb1u6GFyiWYgl3g24V2o w5TQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687123982;
 s=strato-dkim-0003; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=oqCKd+CNjdzbLYFDJSrbVFBUX2kYJx0eW04RCZgiOf4=;
 b=imtXATNJCZgF2HR552RAsHOy451el7nsNuByG4+Cv1D0rWKwKHPRTXoyWLciYtOULd
 y6F9bSYQOrbQ9mmSQkCA==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sun, 18 Jun 2023 23:32:45 +0200
Message-id: <20230618213250.694110-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 81.169.146.165
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 unknownsenderscore=20 spamscore=0
 impostorscore=0 mlxlogscore=630 suspectscore=0 phishscore=0 bulkscore=0
 clxscore=95 priorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306180205
Cc: linux-kernel@vger.kernel.org, Bean Huo <beanhuo@iokpp.de>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v1 0/5] clean up block_commit_write
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
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq5ARfEwes1hW/CxwfjqKzP/cKnUXGNs35zouFQhI="
X-ServerName: mo4-p01-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: jV-eUIXktoDGgbcGyZ-Q42zQZoQLM9iH
X-Proofpoint-ORIG-GUID: jV-eUIXktoDGgbcGyZ-Q42zQZoQLM9iH
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAEoght2UwhadxlETK3kS1Yr7ths3QF2HaiK3BQRFRfrh68jIYpqPSG6XuSLO0Gv
 uDmxgIJuPEdcPKr0WTrDlBcIz0ivlgVhpc+RBb8Z/9I9FUj/mUl4fo5lMHYtIgV7
 DeTZvxLSi5uQ2ZXav1ov0Gsac/K4J8dYKuFYwKvd6k2X9Lj8bH6G2lIs0KMmEx+j
 b3gPp9f60hL99AJJnUF5dheUNpe2sUQmGucD18SZGjCXXDCSUlL9+RvLJd/EV1k1
 5aGLWYKiKWsLJuLqIo2BDAB0enpLW3lodwYDc5GA44OLomcUwF4J5S+78z6clG3R
 ptGEOhnV02QeaR2rY8ZHEv3UpLA+SnLhNaNRiH7ioGWKRajiP55HzK+bQFnjtIBg
 Sl8v6BLC/cMFiKcMiRAyF+g6rx0nHkb3V9Bx8NAF0S8V5DpRmRGwiuZlI0VEGvGy
 3Yk5nhvlHKztG/yQGpnZDgySEuOiQdS8zervL/IXHd8SL8obZhCH+LA9YDnv+yce
 1gkh/qYYrhcKI4v2t1CS9iKeRONrUh124P8GXCK9XaHV

*** BLURB HERE ***

Bean Huo (5):
  fs/buffer: clean up block_commit_write
  fs/buffer.c: convert block_commit_write to return void
  ext4: No need to check return value of block_commit_write()
  fs/ocfs2: No need to check return value of block_commit_write()
  udf: No need to check return value of block_commit_write()

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
