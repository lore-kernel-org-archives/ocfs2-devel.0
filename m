Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264CCEB64DC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5YPtL65j6ncxEtpohasLDkGrN/5X+RmvMqha7+H8Mfs=;
 b=yxOdMIek93xhrHLy89zJpFqNVc1+ucwiaLEUmpbLy22pUnl4kENyHvLTCYHJdJt/b/yCorq5qdzQ
   YPOFBYkcKxHY6Z5Qi+U15aunLgyUQGl/ONeVO4aDsli7Cm0jTSwX5VHnhQkSgwekmtoJsJOffp5f
   kcNE4d0pnU/lUWOPEcSlqNArrtk5qldecOEPtf9ToFDs4X2s4Ybvp5vEAzJnXR116eTIoLCxz/iV
   B1DVTLSfazVdyDkuyr5DtSqRbqp0LYWVzc3W2jF4Pj3JQ37nUNEXqZqvDI256XdjKzVy/71H2X20
   UMNU9EY3/ujmKPE3eVtGfPPrJZCPUU/TVldlbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5YPtL65j6ncxEtpohasLDkGrN/5X+RmvMqha7+H8Mfs=;
 b=B1MxuIqXsqWKSGcWF7rR5H58JnYI2uYaNK2lposUrDD/iVHNExAsPjuSDnsjQXhCE9mjOOGu3P+j
   RzIXmCeOmde/CygQ+EFByTug5TcZ4JWsfXJy76j1NimSYAi0MR44lZFCIIFVgzCU1LmrYatlogbK
   ewcRzXlJwM4S1iTFSg05oKnPrQws8h7rvi7m0sjMFgCO+/u3Cl88hl3XR423yOcFPVVMqTy8KUjl
   nqJMVDQJ4f/o4hMfVPoQAqngGjWorDc0f0+0cKCQk2DZdUOcTWIHnnX78RE3RQa8OdaTYmhEk9nJ
   LTvE5FBQefOEegigTyJiph4B2qmjBGTIefA3HA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU00FA0J4WWP30@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:55:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687758927; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=aQnuDz/XBuzSZ3LWUcwUNly1AAPclqlAlchZ+nfH2TQqNJkrRABXbXTPFtQwhvR8Dl
 36HRTcGjFtf0aItO7SO746s0Rp2AJ5Uv3lKfbRiGozGFYlt/Tx+BS5nxXsbvUVdyXhFk
 3B0TCaqosEfQ76zGA5HFGZpwg4y4slq5c5U379aspbk/w5FCQQz66AP2ErfAmyZlhnQh
 7X25h+X4WvcsD9gbmwD7al7YYbrxq4m6tyAlJ5uM40dh7MTbgDyNbzGwAi5x9W1i7Oa0
 JQuXu9ZnRDlSF/fz11B3CBcmSxSujDGFBGxy2XrCJ18SeeY25hs27t+XECNbsjrrFZCT WUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758927;
 s=strato-dkim-0002; d=strato.com;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=uGLdz3S1xYOcf7/Hp5FiA7LT6elpVU7X4yht5ubS848=;
 b=Et28lcPwyiozhcpks+fxVKJIGR8B/Y5urmyCB1k9VkluIY9qtrgvBVt0R8ffdbv/z3
 O+4bnKdVOuBfaeCoM84ZDgpspBSIyaVdibShhnV2lbiJyNsW1liBFyQrGmt5dTYUvRrB
 mubLw/wsF4Yo6FbFFHrelOGMA7W5hmdWHsc2ngGZD3paZuTOFPaXXBosinJw6IvZ87CI
 qPDcYwARKDiufHzvcUEMQZTz6RwQAoxNuDoKE2Zqasd4COWM3G63jxPIf4haWs3eETLb
 4MNjGNhw/BR7rQvwxRu9luczVX+EWPSYqm3FiH6yBfQIWbsnjJfibd66bfFc/pokRPVB l3+w==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758927;
 s=strato-dkim-0002; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=uGLdz3S1xYOcf7/Hp5FiA7LT6elpVU7X4yht5ubS848=;
 b=FHio1GDrW3lWX1xVIMoYFB5eF+8yuHoMFyHQzgBeBtfGtXDzU7rrakxD+BcbcdeQgx
 EuHdnYpiLoxDAmDdis66Kkcln+PAuY0R6/vFWhOHpObjx05nYkbD53wnJvwunEYysGIB
 vBfcTloI045nLO6VswtSOKOZQsFiju+jOJdFEv7hdRCgmsNZxyQ1YkTE6uaaAGmeGAZI
 pCDFzTJQtknCztHYCl6ogsghjjj/Ngc36bP9z4cc9Zb3L7DnhfQzOaEPbI/mmMIEaTGT
 Y8XOAxGsqLb3Y2MkB4ruQA35ZxYtUtDc9G1javxjvueTRneOlnMW1fgh7J1uZwqVgSPQ LrdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687758927;
 s=strato-dkim-0003; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=uGLdz3S1xYOcf7/Hp5FiA7LT6elpVU7X4yht5ubS848=;
 b=EvMfs2CATMuB7t0GopD93Ats62L8e4gJ7IhZOs+sBP+lGaJLfoH8waE21HbYVEE6sc
 okUDGs5b450223rUf+BQ==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:55:16 +0200
Message-id: <20230626055518.842392-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 85.215.255.102
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=632
 malwarescore=0 adultscore=0 lowpriorityscore=0 priorityscore=60 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 impostorscore=0 clxscore=141
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260053
Cc: linux-kernel@vger.kernel.org, Bean Huo <beanhuo@iokpp.de>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [RESEND PATCH v3 0/2] clean up block_commit_write
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
X-RZG-CLASS-ID: mo03
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1RrW5o+P9bSFaHg+gZu+uCjL2b+VQTRnVQrIOQ=="
X-ServerName: mo4-p03-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: OimOuUH6QFR7VtSTP5L5L3r4syWRebvZ
X-Proofpoint-ORIG-GUID: OimOuUH6QFR7VtSTP5L5L3r4syWRebvZ
Reporting-Meta:
 AAHf2FasuItfan6QUd/5hRVnIgAVWEw+/2155bvcaKhx0hspZoCIqbyKXkB3nC04
 TEehRQvXD6oTx17iNkJ5oGyRr7dIKIhZP8/FXbx6BJnygs+H7EKPlHvkNx5HsEh3
 er8QVwDWec832oLgR6Lq3DXd7cQBeersbyfQaNZZUnlsdTiOmvs00MabopKmRekO
 RGAyzn3qF3fpkSzpR+qWXE+l/wFHyQxlBi11ZxtGINCY9qEtIRPkK23wGTdsTlN3
 WWaoHE7iWF/Lfs0pVsaMWq0BUZ5N9K4NIqgl8Zdak8Y1KjsYSQmMWind7Pvlk4f3
 CSUFAL2wKNUtov0W/TYwkPrkK56FpmLcYyR/jPFTBm1vx8VXPOGHU3pY+EqizNJJ
 o9i1qlLrIIlps0QWuq7ytSLzt9xHTtgNoUGaG4Fd3swALfkK+TiUrBSj3u6qt+Zh
 IAXGo24zuU+QTR+iacFqEb80XyhnbOv5CxRi9f2AxpZNqxZZsCPgd096UAT/hrY7
 ic/rqh68JrOeilMSMk8XKXqpmbULuYJWRK1lLygzmrS8

change log:
    v1--v2:
        1. reordered patches

    v2--v3:
        1. rebased patches to git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next

Bean Huo (2):
  fs/buffer: clean up block_commit_write
  fs: convert block_commit_write to return void

 fs/buffer.c                 | 20 ++++++++------------
 fs/ext4/move_extent.c       |  7 ++-----
 fs/ocfs2/file.c             |  7 +------
 fs/udf/file.c               |  6 +++---
 include/linux/buffer_head.h |  2 +-
 5 files changed, 15 insertions(+), 27 deletions(-)

-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
