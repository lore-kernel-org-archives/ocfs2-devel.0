Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41938EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wUstWELgZVpy49tKdkgIVEH+/L5A6Ck1mG0+8BYUO+Q=;
 b=sOZFbZEBOkN++upUq7QXfAhTRHlgoDPycPHHExeMPe52GZ3BKbmQCTVGKnFBUfFcblspWzTfnlj1
   dhGtSuGKrSi6bjTNTb8U59nt4JD0rKYfrUBzvHm9y27hpUeiIAMwGPODhOyrtqZ+6ghAPyBd7/2H
   EDQkJtPIAFBBz404CG5SD+kdZSDhLYlnr1xwtIPUazZhhnJliyawk3pmq+ni/d4Bax8/pyWpW79/
   Jgm4i3RieDmmjclnJgBTFm6uqHzcxEF7KvKuhKGbdr3+s9DCtVYaic2HuqFybdxRBBzpOjqFFK1e
   mrfBS7uKjX/yaeCE1uaAtnthrvbmrQpS7KZEmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wUstWELgZVpy49tKdkgIVEH+/L5A6Ck1mG0+8BYUO+Q=;
 b=kGudDvbCL+6f6pf4lSahFXCjyC1+OuIzbr3aJn0pQtteCPnQfbPlToTLcTDiUjTmo1iyK9gYwyCy
   /KU1yHuHxHcuPdRnpvqjHeoelEB9jfIRbHyJTy1hgMBAvIDA2no0K0swa8M+Uezf3hnCdRvf8KYy
   vh0DmDwSSyZIjxGo9OuPJaYYI7s7/V+wFAdwEFu/bEYlJAB4WiOWVCkzcOhu1ojW3u+Qy2GvjVzT
   pUtBBRnk+B7Rs0tSR2DmKXH5YGkjbtRCe2OIE9ZuHElj3zlmjef1c/S5XUgD0rO74r+ZwUMwkb0j
   lb/11ZJKp8zS/MS2Bgq5zlzPPB+jxtKtufutcA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU003EKIJ7L660@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:42:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687758122; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=UmdVEWQo0uezW3gzYI8AGYJNrAzST0w0p1m2K4Gy2/HaL3YMKh7dU9JGWY34mJWvao
 tVZGMtToJJXaBr+FtXfc2Hp+9Q0eTwxER7h4Cirqz6zVdFMLDqc3bq4xy3k4sdcYiGol
 AYUsMDSdsXz3JeRWShwCtvAzSY7BxUappx0oLIikg5lZFDjhjL5wtEqnDFWQ44xCYbH+
 F/pbaWPKcsAtGFuT4cDtpqgAIlLq5FL6YD505NS0hQ1I5pjQfEf5rShD8oqXBbc3sAI3
 M8l0oKQxsYvPvT3V5bSQn2FNYdNaY4ew1RaA7FyZPWCui//6DW4knLYasqq5q7uB5SGs TOCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758122;
 s=strato-dkim-0002; d=strato.com;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=u84PcML5e480sTa8HkZqNl0cQA2NFsZSaC6NnQ5PLFk=;
 b=VOecyVDzGmcEar+tZSwaVZyvYyR8xoGyhAQnnqiMsg6OtOOCDfe8UpiXNOB804DSAl
 EQhcGlisbAy39RKUfSMEQXPk9m34sJNPGbyvwasodeICCBFmfUvkvsylcCCnqu+0veSO
 llB312bnL9vrAvk0bsxykpgs90VcaiUBEYVStDWAJ1SrJgkL7eZhuQaWKc+2vzaHh9sw
 7X1GG2IJlMrQNydAsFY8We50jGKdGNWFs9MUDaAk/BDQxrlyhpON/uDpOLSSN7xFCJsh
 +/oivfnz9nJ3EiS2ojGy4bm2LWKqUTa3w7sD2l2pmvogEEx/WoTDL25qXuuVF03PB07f QRvQ==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758122;
 s=strato-dkim-0002; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=u84PcML5e480sTa8HkZqNl0cQA2NFsZSaC6NnQ5PLFk=;
 b=VWyoD7aBvrrl7+S6R0ytC2ezlnhivupTe/tkyi9bL53i2l0PfntXr5aRcliYRAZHAC
 C/u1YtTTPFjGTnRllVi98JpknXUgKYkl6D3iWd9nWORos8Jr8UeVafDS2Am4o2rIdH2M
 UfQX5T7QqKOVF4nAJ8f1y0j0Tzf32cTBu4ALeO0JWZgKxYLZit+/SmR6qn/LmRIBxkg6
 ZteTTqpM+OOat1t+EKkFO3Reu5u8Nm5RIzAZBIPIVipRGUR3oZ6XCoZQluIImECgTZp6
 JwHybKNru2Iqz5FepNKxaR3jqFN3EQ44UTzGkaymgAbZf6DluhUJarGI47bxKbt4xYq4 Sm6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687758122;
 s=strato-dkim-0003; d=iokpp.de;
 h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
 bh=u84PcML5e480sTa8HkZqNl0cQA2NFsZSaC6NnQ5PLFk=;
 b=4uursAC7+f1zlisTJ7H6N9A601ItGoeMxAgnDzNgxvc7m1glMB5P017maCLOAHDQTA
 HuKG8Jw+3DqAcCVw8LDw==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:41:51 +0200
Message-id: <20230626054153.839672-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
MIME-version: 1.0
X-Source-IP: 81.169.146.166
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 unknownsenderscore=20 mlxlogscore=632 bulkscore=0 adultscore=0 clxscore=117
 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260051
Cc: linux-kernel@vger.kernel.org, Bean Huo <beanhuo@iokpp.de>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v3 0/2] clean up block_commit_write
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
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1RrW5o+P9bSFaHg+gZu+uCjL2b+VQTRnVQrIOQ=="
X-ServerName: mo4-p01-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: AK70LopIQo37kwDad2knMNX8Nh4OVCAd
X-Proofpoint-GUID: AK70LopIQo37kwDad2knMNX8Nh4OVCAd
Reporting-Meta:
 AAFZsrzNBSQQpTeUG8CK9kjs28KQG7YE/OBcpDT+9qluwLgTn0rDYxrZGWbVvwv/
 kMAaTBEH3Ouv4QrI+7l0kkpTYmftOj1jijD65FENXSsqAUcMMKNZ/VcPeqIvUqcq
 iB2jZ0KopK5DfH/XAL+zFLL1hXtcPdtAQUl7Jg38ZbKawFmuHKvQclWUfY1ynFUO
 /cvFE//9NTzje/iCbsnVvw6gYdnfPGyXvS+4Zrw2R/zpwm1v1EM48nuLsnV8DPHa
 R8bwVB3I4hu9hNWJSbhByuSCzAdG1oVzBihpblEOBBgQLsDeeIUoFrna7VB60vbJ
 pOWTkU7OTK3G+0R9RDtwCrhJfMJAddd+eUzIeOnRq40fEq+ODPvp/GeLIzIk0Tb5
 ASctzyMSTX/79hwDsuVK/AgvZj3TacKkpcV3w9Zio2Ox8cIA5AyN9xmFK1tfodSO
 WBVKgj/eAUOHF8hEQ3JYTbZTUZiJKCN/AIGSfUIToayr55neAgRUz2X/mGtajixa
 ZyY6De1FulzTkpZYErOIqNX8V/W/j+cosXSrEvyUGjo=

change log:
    v1--v2:
        1. reordered patches
    v2-v3:
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
