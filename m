Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D0DC433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 28 Nov 2022 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nWW+9gSxaarBwnjaYEz/b1TvfVHYJgcHO10/s/x0uBs=;
 b=AsGr/9M24jA/Dfi57S1iI31yBchNpe8WhsSu7V8MCBeS0kCv6r4XkvOIz1b8Bg39OtqUIl6z2Cta
   XKCZZEAZCOZGVfZS2OUDLhYv2F3c/sjXBT3VGxgpFNRSA9TiDnEVBVMimkZir2OQi8+t7N6Gw4q7
   Ehd9f48uaRIOKJ3LcfIoSR2Xa9npFhIb28fpHcZtMLb+zxNfg8fjSTTooVBA+Lo+MbfdOKiZmeR1
   iCT0ApRUCyuPGLHFADuzkmcuun9DLPYqpwBxxKXkj2ZYqW1FH4boxZRplwFbOR8ysmq6DQj7Vj8l
   LcPr1Gpn3mliEXncZCf7i2yj9PYBXx9VnvCwlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nWW+9gSxaarBwnjaYEz/b1TvfVHYJgcHO10/s/x0uBs=;
 b=RdPCe6yD9HbGFqyCuSe11hOthYTgEODrF8Rt5AyibrmKrEcwOhkr2K87Gp7wfEbQEo2Hw2Aq3z+J
   E3+Z6tQfe16DLJ7MG6/i9m3VSt6ijYEq3e3GOrUZk4NGq5w06stjTdDvlVQ6/Op3R2m2MGT8Ao3k
   QAT5tcOt7DY2sa8tMS7W1aToy+Wi51VLdISKihe4Nk9IhxliUSLK8CqAWV81RUa7g4EEJkBL0IHc
   7XTTYGevvpS3ErADIfIw59eyhLcOMouljPe6EGiKRA1Pxm7TrWUT0XWjvi4fyvTEDZcCHw5fOqZz
   00d390+13ZdCaKAsL4L7JLWOhpqDRvjVnQYTPA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM2009HIAF9C400@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 28 Nov 2022 14:18:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alex-at.net; s=default;
 t=1669531599; bh=t3cXeyCmjj8A7UsNbX9yUyHeFAVNO2CWUaA/Oa6rGgc=;
 h=Date:To:From:Subject;
 b=gpIcys0VYYTHa/Avu82GSS0z7ypTTusGifxbb1PGfQfNJkVzioxho1jqI1N6/3NTa
 1AjmDV/YkQz7XkWM4TZxZrpVd0ZpOGISxiTrGOCzhPRL/T5Q7spT9B5T0H3JftuBMw
 6Jgrtufq1SbbNfchDcDSFk2Qt2EexDJyNZorYoqI=
Message-id: <cbfca02b-b39f-89de-e1a8-904a6c60407e@alex-at.net>
Date: Sun, 27 Nov 2022 09:46:38 +0300
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-language: en-US
To: ocfs2-devel@oss.oracle.com, Joseph Qi <joseph.qi@linux.alibaba.com>
X-Source-IP: 51.195.137.138
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10543
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 unknownsenderscore=20 suspectscore=0 phishscore=0 adultscore=0 clxscore=38
 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211270056
Subject: [Ocfs2-devel] [PATCH] ocfs2: always read both high and low parts of
 dinode link count
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
From: "Alexey Asemov \(Alex/AT\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Alexey Asemov \(Alex/AT\)" <alex@alex-at.net>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: mail.alex-at.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 a mx a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net a:home.alex-at.net a:sphynx.alex-at.net
 a:mail.alex-at.net a:mx.alex-at.net ~all
X-Spam: Clean
X-Proofpoint-GUID: n4WnBikQcq2702bqxt8JOSNQVoQXFB-B
X-Proofpoint-ORIG-GUID: n4WnBikQcq2702bqxt8JOSNQVoQXFB-B
X-Mailman-Approved-At: Mon, 28 Nov 2022 14:18:44 +0000
Reporting-Meta:
 AAFjUFavJz31EBF4eG+0UPOESwB5VD9ik2XewXAUM1fGPIGsRhY2H98zmKITur/N
 AWnkOr0cGwOowPVLuhsxwc96TshjzIp2mDm2BjNYO+c6O9yteaxOWVZ8Gix0M1C5
 mBWwl02rXRmqqGVe8dM8+qB0ZtVa1Sh2MAJ7F2OlP1NqG2HlX1JqjoSHlBUldkjN
 ofuSc0d+FIywOxxvA072r5Z6uNqRA7SY+pt093jhOVwholaxSE2DexBLqMKBaLT2
 jUL7QKExMd9qGApkXtv2KySbM1caOaGcoGP/mHZbMDweJqTtApo7z3VsnI6d5OtH
 tohEp5VfH6GPqeWVLC+dvsqJLgOvyXegkINY1Q7w5O6gYyixrYkn7RfuIXmDnXVn
 CgLFDNChrxym/CyyYug+gLqzODhafhNobsnzwI8nymrsyvAdVyV58ouYzeniXgi8
 MDwveICzicF/nocxN5aYOpj3m0zjBTRpRDzBNUW/vvIP8skmiwvIeO5uTPqEVhYT
 zhoEPBZn/WEpMIlLfDZo5ry6XG3HWol9L62uglBbUiA=

When filesystem is using indexed-dirs feature, maximum link count values
can spill over to i_links_count_hi, up to OCFS2_DX_LINK_MAX links.
ocfs2_read_links_count() checks for OCFS2_INDEXED_DIR_FL flag in dinode,
but this flag is only valid for directories so for files the check
causes high part of the link count not being read back from file
dinodes resulting in wrong link count value when file has >65535 links.

As ocfs2_set_links_count() always writes both high and low parts of link
count, the flag check on reading may be removed.

Signed-off-by: Alexey Asemov <alex@alex-at.net>
---

  fs/ocfs2/ocfs2.h | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 740b64238312..a503c553bab2 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -560,8 +560,7 @@ static inline unsigned int 
ocfs2_read_links_count(struct ocfs2_dinode *di)
         u32 nlink = le16_to_cpu(di->i_links_count);
         u32 hi = le16_to_cpu(di->i_links_count_hi);

-       if (di->i_dyn_features & cpu_to_le16(OCFS2_INDEXED_DIR_FL))
-               nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
+       nlink |= (hi << OCFS2_LINKS_HI_SHIFT);

         return nlink;
  }

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
