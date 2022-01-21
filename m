Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A669C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Jan 2022 07:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=meGsxWrgpLs3aSOXgd1J58bTGkdiinOR8aCKLqquW5o=;
 b=eOr+MjJiDPfvPw4vYVfRjIVxLr6KbWyMpZpDRZ1esJ3zhxXfv1H0aCeqTZ6cCrMaTZ9fmwVZFXbk
   +wsH+MTN3MeNsduMTZL9IUWAUFYSfm7dPjmoUWYlhI1ACiAsj2rd3QKRcqpM/NoE0Nrd77pwv1/i
   sIOUojqG53jFZ9DuYYQV5bnUkTqlfQCjwJ3WA2r8wAQe9Twm6imkWvQpO9m4wN/ZDl9JrVMXLxhf
   tSVRqQqEFc0EbAK47CJhqBAm1+CBmAkrTbDlIQJHRcGUCX5Vi/vXXtdSp6TSUhh1QR7uUqEluJFP
   Q/louOCPoD/r0ZSrMr+UfkvN0FsgAgEr69uuJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=meGsxWrgpLs3aSOXgd1J58bTGkdiinOR8aCKLqquW5o=;
 b=bdCmnXR4Jfe50uBB0XjRCzAOAz25oju93fIig3ithxFtXbCQvPanxF6n4crhRFUczEQY4DdKfTsU
   1xulb67+quhdRjQMYMVJw4Qq2HNEd4k//9w2z4AsW/hzEfM22pxPnXv5Zd5w4SAY8QvT8MiL4z9i
   gWnTKb5pLAvEoQNdYJW5U8Pzq8D2jJp+Td5FJ7QKg7ErJwmc5rPb35ll1p6imRPFPX94wrciQnwH
   xBnTBjM+UKhdHC3u/vVAqelz8YEbwRr/6eGCFVxjQJ2d/W6KOMTciL6VLx2aJNxdKExTUzjfE1ub
   nXuzRGXhqiUYmB+Sim1WdjnQVwyPMPwY9tnjkQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6100MF1TCOVK60@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Jan 2022 07:12:24 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: akpm@linux-foundation.org, tytso@mit.edu, adilger.kernel@dilger.ca
Date: Fri, 21 Jan 2022 15:12:03 +0800
Message-id: <20220121071205.100648-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-version: 1.0
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=261
 impostorscore=0 phishscore=0 priorityscore=95 mlxscore=0 mlxlogscore=993
 spamscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210046 domainage_hfrom=8317
Cc: linux-ext4@vger.kernel.org, gautham.ananthakrishna@oracle.com,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: fix a deadlock case
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0V2PmKif_1642749125;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: DE_wE61f59VSAPrW_QJq8UBUtJT8iFZy
X-Proofpoint-GUID: DE_wE61f59VSAPrW_QJq8UBUtJT8iFZy
Reporting-Meta:
 AAHGV7Mqn2yYakRUgY2J+Sks5HblLSZgJ6wgIuNV0cH/RQ41SibgOY+klwpcpa+B
 h6pJ0fE10RTkQ4V/NEV+2O60LrNHxSZcyY0d2UatKnFD2VdRCOYxzgQNIJNokDYG
 9ry5d7i7Vr+2x/16TWEmzdd6487MsvIn2nsgunJ0K+HL1CJUvT1qjR6BQp/o+7lH
 kwcWg/tU7eRJznIIdEPfdKkmC6dG80z3U/MR63u2PPqLZgw4N1yzSP0rPdORMvDN
 316Jjz70NRaN8clVnB9z79RKCuYFzF513D9vtmCoyhpSuts7v+/IdyCEtofxNcEu
 PkMHrz54Be7RjSL+/e2C8mG3mcESWVwaB6dPEGvoss/zLXkEemrrKRD/eWU7fqYR
 EqCt5amcovlNeTw2DvbCX2rNteL61n/OMP0L7uEue9bYxdf6CgMyp/ta635WsYiB
 qCIKPfjrEnT2F4tb1wkY/CPu+dk03I9YdzrskG+lyq3Tk12ULAvimdXT7YgpkSIQ
 wpmBcCwj5lrMlnEJUYjLiDQNfsh1aykjxH/0ywRlqfw=

This is trying to fix a deadlock case in ocfs2.
We firstly export jbd2 symbols jbd2_journal_[grab|put]_journal_head as
preparation and later use them in ocfs2 insread of
jbd_[lock|unlock]_bh_journal_head to fix the deadlock.

Joseph Qi (2):
  jbd2: export jbd2_journal_[grab|put]_journal_head
  ocfs2: fix a deadlock when commit trans

 fs/jbd2/journal.c   |  2 ++
 fs/ocfs2/suballoc.c | 25 +++++++++++--------------
 2 files changed, 13 insertions(+), 14 deletions(-)

-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
