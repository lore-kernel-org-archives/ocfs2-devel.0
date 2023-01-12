Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71723C63797
	for <ocfs2-devel@archiver.kernel.org>; Thu, 12 Jan 2023 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=44r5wixVxLTkx5hCuOfgS8ha+v8wk3uBPrvUAI3om2c=;
 b=lewBYy3QvbWdDWFtqIzx1TFGyfsYPPxipmGnX2g66paWVe8ltkDq0iIyXGHVDS2K4cKts7GmW8ko
   312tZ0GBS3SIQtWFJz3EzjXyKdtDgqYnBkV7bx7ENCnweCYo/OJwxz+tq8mh+/nq3lYR5sQ7S23n
   SHSFybYq1Tt7LgTZ5tnRj9J8rnahLCcbCprue69+7WBaxCR5HweuskdgVhCn+0MDIQIH89AXu66o
   VdfHGqFb5F3ESzS1g/iX1+EDdu6tNGWhDszmvsA0GDCAoYCqj9at4fp7A+UJrN27btzRfF+kqb7d
   OwPzstOA6M2jPW6bC1Ye64kjfebMfaobpB9lPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=44r5wixVxLTkx5hCuOfgS8ha+v8wk3uBPrvUAI3om2c=;
 b=jivxM+vG4YmLd58NBZA1xevBFb7zvPYbamyiGtUp9z3BVo6Sn3RbF/TaKXBw6Vsqjq9JrYcX15LO
   AdTALluS4YDka0J5LDXK3Mi/xytTDrQaxQBppgVWbO50gy0D0PD2CfeN/LTZYVrD3DEMydYhiiyU
   5wbn2uHznVQX4C8BAEr4cKHscwDmdE1NbIwfTawxN8gWpA2qfMIbxMu7xRJU8zG1ZY57oA9NSsJG
   YHrbBHNx/gHUWdERG0b9zY04mVMVjjdpjgzlzwLSyyuFe5krtnLcSZ62yIzk9/M3nkPsL7wePwLh
   N6/WJIrga72cBqRkz7LipqGf2V2tdYXGoeLw9A==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROD003FBUN6SDE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 12 Jan 2023 17:16:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paul-moore.com;
 s=google; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=nzSuljwXCaXyiAVCXAx1oRKKeIjSI3nJRRGJJx1quUQ=;
 b=MFOcCfEZ7Cjmr3WB5GH4eeEn0165eiypBPdejoqXwokek49v/AySoZEAZw9j2oDcmq
 y4J6DEeYf3KOdxex0i3awGU/lJNKOesgPify/ePlg8mxB+jk23/SKGnDkwfjKWs723G+
 5fTI4dD97IJHbv3KYFmaYeEhLvdEO5RWppT7C9xSdlKh60iFFNFBADUu4kCkp7oLBgpM
 RQWj59jEMMtexCUU92taNzVkPyGJ6EsQ4nGL8WFfh1sHrh7w0DJkEzpsadnRGZ+k5KlX
 9RKXsLyYhkqNOIn6C//zs9Slur/qUqHuCKIuWKiASSuuMe2SyhJoPMmQAvRwAOR8UYA5 lbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id :reply-to;
 bh=nzSuljwXCaXyiAVCXAx1oRKKeIjSI3nJRRGJJx1quUQ=;
 b=m+ZDobPXKDOgJENbp/4tVKt/t7aMvSiYYTvscHITO2P+Skjlgx5O0bNxZU82pDSMY+
 e53DjfvLJbiCVUD1cqpm4lt6AseazCOA15TbVsSQpqSp1hfZy+02txyJb0DAyLBuieCW
 /jLLxSLPPXDAnyzUn//Pi+fr7wUERWAsG558jvI4jYUqtz8ns7kjQJaEcfE47wiGK4mX
 VpRJuxHBWoTTYkaWA5lnmIDlwp5tBaaXFHpA4rAlhK7H5ZKYuQudYgt24EbiJWLFcuPn
 dZzELqO+gtZjVqRVyndQGn6NoOMhOklvgox3/k8xSLHMWNPJ7mfTD76RGqLn4YueyyBA /0Aw==
X-Gm-Message-State: AFqh2kqk4yGQBdTaBggvqkNmr9uIxfSD9mYv+trtEbjBV2yMq0WXH0zZ
 IetmhCUt79bPESo0nMb8s8pzFvAA514/KoOYwXK7
X-Received: by 2002:a62:158f:0:b0:588:e66e:4f05 with SMTP id
 137-20020a62158f000000b00588e66e4f05mr1300557pfv.23.1673543763211; Thu,
 12 Jan 2023 09:16:03 -0800 (PST)
MIME-version: 1.0
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
In-reply-to: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
Date: Thu, 12 Jan 2023 12:15:51 -0500
Message-id: <CAHC9VhS0SnEb46-FBpn2JpC2dJ7OnkeJ2EtLBvVvkOLdfFmcbg@mail.gmail.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
X-Source-IP: 209.85.215.174
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10588
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 priorityscore=0 clxscore=93 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=728
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120126
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v7 0/6] evm: Do HMAC of multiple per LSM
	xattrs for new inodes
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
 AMrXdXsG96vnEjEW68HlbBwvUb9qhZbhASlzXqBntMWFBx7pNvLRL/YHEGdI0X89G0/fteFLqA6mf93dh22GLZtjV5o=
X-ServerName: mail-pg1-f174.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: c_Ld0ZGVNUaWNoqjQfim52Wzxl2cEctZ
X-Proofpoint-ORIG-GUID: c_Ld0ZGVNUaWNoqjQfim52Wzxl2cEctZ
Reporting-Meta:
 AAFBecm0mrq6GmgYlV6cdEpx7vCmUoqW4+rQ1+TFFF0noXU1VX/VtXcNSTL4JhBr
 fm29t5v8ODYoh1TRisynIL+3s5ROOj4mzyVC2wJcAKMSzc5fjWsGdJrMDeN8qOKv
 bW4ZjzSmtOwTu9kNg4ZBZ3b3hk8tl3xQQwdJQwOijTV12DALr3MIbl8b6ir6Drcm
 +Z6UQf3KLfqmOrzV1BVpCYjHr5TAYwz9hHwTeHfx2Gc0q5N9xENICQAc/wcUTJYt
 Rb3mSk6QBL3Nt8CKM4379dM/OzG62drO68UCOR2IValF8EPQ4Qv2IR9Swab0/tCX
 ZZWZJKh2QgL5j0O8r6/hxUQk7zuRUBrDKgR/OPntaaD/hO6fdjYHLX5EUkmfMKId
 A9SlFB71naiKBwgx+pKy3m5x6BUr3mMmfouthbvv2xI9v1+CG71HYC/ysTEN/L5c
 R8iU1sxZdS1miURD4xWgWNbaKzCEUofl0KGBfn3D/D6boJYXsuaV3okGvOQ22TNJ
 /9HQYS7vuONMQa7zVvLkwUheogKpgQo1kX7Je7LGUC0=

On Thu, Dec 1, 2022 at 5:42 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> One of the major goals of LSM stacking is to run multiple LSMs side by side
> without interfering with each other. The ultimate decision will depend on
> individual LSM decision.
>
> Several changes need to be made to the LSM infrastructure to be able to
> support that. This patch set tackles one of them: gives to each LSM the
> ability to specify one or multiple xattrs to be set at inode creation
> time and, at the same time, gives to EVM the ability to access all those
> xattrs and calculate the HMAC on them.

...

> The patch set has been tested with both the SElinux and Smack test suites.
> Below, there is the summary of the test results:
>
> SELinux Test Suite result (without patches):
> Files=73, Tests=1346, 225 wallclock secs ( 0.43 usr  0.23 sys +  6.11 cusr 58.70 csys = 65.47 CPU)
> Result: FAIL
> Failed 4/73 test programs. 13/1346 subtests failed.
>
> SELinux Test Suite result (with patches):
> Files=73, Tests=1346, 225 wallclock secs ( 0.44 usr  0.22 sys +  6.15 cusr 59.94 csys = 66.75 CPU)
> Result: FAIL
> Failed 4/73 test programs. 13/1346 subtests failed.

Can you provide some more information on which of the
selinux-testsuite tests failed?  That shouldn't be happening and I'm a
little concerned that these test failures, even if unrelated to your
work here, could be masking failures which are related.

-- 
paul-moore.com

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
