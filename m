Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FBDC61DB3
	for <ocfs2-devel@archiver.kernel.org>; Thu, 12 Jan 2023 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3mTj6FD83WJdKzltKGjBqisTQUVQ5sSYy2ynhCo8cX0=;
 b=YhM5bwzzgvzeci6a4qNLl6Mq0mZ+pl9jQmDouJK2TZwapX+tdvCK079MESAg6+lIPM+t6v3twtpK
   FtMvy5lSZDR1bK2UQ8SI+9To3ETyPcmUD825nTKwR+3D+Z6dclcIlp0uoNTUHUKLNmara2uINMgP
   6r97FAsnQSJBuG6ML5tySTxs6FDftGZKKFJypLv2O7RnU7nl90J6H0yLAFMhAFY570IIr4B8fxwG
   pp8XLLztOdEIVGB26IgaYF+YpBx8Nlk3bpn7FI2uR7FilnI/I4nw8iprMLHnAYpR6ND/uQYSr6e+
   o0XDoxA8NL1GaM+p4akW8/Qys79r72mXpz1CSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3mTj6FD83WJdKzltKGjBqisTQUVQ5sSYy2ynhCo8cX0=;
 b=JL00cqKGx5DUfoD+eC3DjfdkmDWsh8Yrb6Kj2JFAQzulk+jC7r8fIn5YaWc/977+fdRnPEJumxCZ
   td0t0aB7fTmG+sQd6IgTLX+qhVABRzcjiMUBCtOCWZTtGmPxqv4/8s+DLxjbYuUYDi5pu/+eev/O
   53SzTNoz5BtPoYaObd7b9zGq+PeMpRbv4udu/TpEkEo44qQRIoDrLAcHlsNyM+MkIqBsUKPubvax
   r5N46GM0iWLKVs0K0yTrEQ7T8H+bbfGQe18zt+arYEO7LsiowoUEaTkh8+DiUS7XCR0eBZOkZAag
   EzdwVbKPY/TOCtfEF0Zn3wwM+iPmTHl2K8SKiQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROD00KEUUXETC80@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 12 Jan 2023 17:22:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=0xDr4QknDNxPi2cT8FrUuwNvsQNO379ZboIpi4mwvIk=;
 b=Fiy522RNvvYxq4nWHpNZeEHiH1/P9P8SLmCZIIqj2T5uix0e9SLinDtq8qjCWr3RvO
 M++tjLHwR63OcuftzaEi1ChHQB/nAHWAlphG1r3019blrCX5ANTv/XcoJVZFBBzi6aUe
 MvLJxuqoSKKFHXXwDx19ZDLhPn5pfMZSOuEkIskLBENuvcoYcn3D/7ZnF+V0JdJj2ozl
 w3ZMpd9CGXnSWHPtu6A4IicaLCensH+4iBwQSp85GIynWT/+gTgkDRA2xQ+ry9YEolgp
 /TFO++DWjtppIUWlzcQtHMiWEruGd66Jn+076IgtMtnBQOtWeZNPvs9hxtIGRLFYmktV Etnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id :reply-to;
 bh=0xDr4QknDNxPi2cT8FrUuwNvsQNO379ZboIpi4mwvIk=;
 b=RAm8f0OR1Om5SD/Au8xwh7F6vaHqjkgRHMGOm2YshxsZZa9YvHxsNjjx/0GILEcj/2
 5X6JTL+ka1Pm4XNLhhtPyf945mCH5z/WR/ODHVE4ooeFvJeU/kBgjnh0dB/73RqzA72V
 OC9s0q3Pow0oHz8iiDwsk9Sn5M+lmeleJ8kqECLrskaLeigKDeieSo4acbg4Rahs7+4c
 i07yPm0x2iWkldFiBHGkpEydoq+8mcRWHgiWCJywpzHwWKbMyTtQbIdc2Mzj531rvJdD
 guRAdArdZ6uibKG4s8h05d4BjGT/GceLZ0ZdcJ39Uo7b/Sv51pSwfv9kAoDZ+CRvP/Fg 3VXQ==
X-Gm-Message-State: AFqh2koe2T1asgiDPuYNOAj6SUcIz+gIy6ZB1tHZklqTCdMQCtM2n/9T
 1MTkFWiUilqGuLOCDVCcyFKh4bbxHTbA3Yk1hABK
X-Received: by 2002:a17:902:cec8:b0:192:6675:8636 with SMTP id
 d8-20020a170902cec800b0019266758636mr4530544plg.15.1673544128229; Thu,
 12 Jan 2023 09:22:08 -0800 (PST)
MIME-version: 1.0
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
 <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
In-reply-to: <6905166125130c22c244ebf234723d1587a01ae8.camel@huaweicloud.com>
Date: Thu, 12 Jan 2023 12:21:57 -0500
Message-id: <CAHC9VhRu_pdEur4XDkwMETAQEd-8=13k+qvpMEgW=hiYMCKw2A@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.216.52
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10588
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 priorityscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 adultscore=0 clxscore=5 malwarescore=0 impostorscore=0 mlxlogscore=974
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120126
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v7 2/6] ocfs2: Switch to
	security_inode_init_security()
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
From: Paul Moore via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paul Moore <paul@paul-moore.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 AMrXdXu2M2VDaYhrvTSfy4I4j0IQ3Wj0M50ON3uTCXgABm7WK5YXNWc5b+Li6BFUEvojgI035C9WkWYZx2mqYyqriPo=
X-ServerName: mail-pj1-f52.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: JHULYAP4GIGYAXZTGDKSBFPpNCnWhopO
X-Proofpoint-ORIG-GUID: JHULYAP4GIGYAXZTGDKSBFPpNCnWhopO
Reporting-Meta:
 AAE6ausRfgEW/mljeFnT5EDMdiSmllsd4BRG79sEGDUcaxAulBZxPnTrpi0JTnik
 tYbzwF20pjDKfa/m3J5voC1jJCkHWKNHdyyiwPQLmEdA9v7I3jdBb+iOEVa4BCW1
 Po9/8ncLrZhbVE59crUh4nOORxDGX8jPRpD7Wn1RDEaRybEiqUWQQ3GvhP7pX6Lc
 UlOKVbFrQ+x3uoeyo0czdGBa3TsmXKj9NaiC30fBNQWuFI21paXR4Xt8UZoB14VI
 Kag0l/ASn4nQpIvaF2+ia0rorPtgNZaPbDelw2OyHqD4CODLkoOWlYbAjkeoRg8G
 iVWhGeNZtRdYNV/eXYu9EXQUhY5xRWg9+k7vL2GUI/K2PxVF+FuOy+U8tA/E2xhg
 fdnY4gBMmjr7PZhx4xIR6uHXe/CW4otqLNGhzfc5rEO4n2NLJpcVRMpyZEUcLM/F
 /KluwXIqbwj+j31FFRK3/sP+L2qKzw/hUCVM0bMBa+FUzl8kypbKiUHaG+XseB7I
 EWzotM9/3M/Wg8dyhmFqsd+Vzzk3Geobkpz6jKsHGgg=

On Tue, Jan 10, 2023 at 3:56 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
> On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> >
> > In preparation for removing security_old_inode_init_security(), switch to
> > security_inode_init_security().
> >
> > Extend the existing ocfs2_initxattrs() to take the
> > ocfs2_security_xattr_info structure from fs_info, and populate the
> > name/value/len triple with the first xattr provided by LSMs.
>
> Hi Mark, Joel, Joseph
>
> some time ago I sent this patch set to switch to the newer
> function security_inode_init_security(). Almost all the other parts of
> this patch set have been reviewed, and the patch set itself should be
> ready to be merged.
>
> I kindly ask if you could have a look at this patch and give your
> Reviewed-by, so that Paul could take the patch set.

I've been pushing to clean up some of the LSM interfaces to try and
simplify things and remove as many special cases as possible,
Roberto's work in this patchset is part of that.  I would really
appreciate it if the vfs/ocfs2 folks could give patch 2/6 a quick look
to make sure you are okay with the changes.

I realize that the various end-of-year holidays tend to slow things
down a bit, but this patchset has been on the lists for over a month
now; if I don't hear anything in the next week or two I'll assume you
folks are okay with these patches ...

-- 
paul-moore.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
