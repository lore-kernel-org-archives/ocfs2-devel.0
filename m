Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03339C61DA4
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Mar 2023 21:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ssG4akRVbg7wwISz0J9UX5lj12pxA3yOBvbmdft5Y+k=;
 b=yBe9EF8OBK+XcVm66UACUWHZNs9EgfimAyce8iyjkGcMlYzMW9pTqyAheJKu9p9/Ihm6olOIXQrm
   UcW3zIV/snkXCZ6ln0Rx18sJOccwu3AKTbiluQcvP1s0OlnRAyVIsKNLAZWkv+Z6WZKYMN1iNFcD
   1NhdedI5F3cx2BnHgNZ/s0Hl7jlAdKojbm5qFyKKqPpXSLM4e2ctaCrVDiLlHiBepK/QsS3YjOLc
   ERDKkXa35nZihy9+uz8A0cemzI+nr6vb2K//zfNkprZwORM8HS1FiHEUPD0sIqoB6XH7d9TwDgAd
   +Z9rT/lm6HxrmVR8TKsu4RCqWrwVjzNO5ou1pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ssG4akRVbg7wwISz0J9UX5lj12pxA3yOBvbmdft5Y+k=;
 b=biZuzgl3QPeTi76Zm12ojD1jTGwwy0ljq35TD8Zo3ChVDjJ/ksKAbUrxCrIpWV8rhOIiO6B8Qc7s
   JMw1/QHtWoCFIVFFAG0064bYU3YAqqGSMiwYyy7TZpZZ5+YH0byTNsPTybQUiiNNeqt856C5vScJ
   eaA+IF+sUc2F3V6rJJBfy/bT+pj0PQoIqQzGbfcPhD8wL22g06NacrDj3Tuhs/MZUIH/+VRCHYcc
   sRBOXllhmyzgKds2KQ+XrTicESicaXutP7+mEGhFv+PFyQ5e+hW2/lIAotWvd8Nk1OH3Ayl+PZrl
   vJLAweNa1PNCJLiL/hRbjrfSGE6qRqqJTR29Kg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR4000FVC8MTY80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Mar 2023 21:41:10 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=valentin-vidic.from.hr;
 s=2020; t=1678138835; bh=ewTUvlU7k2bqROk0NEQF0IJ8YvgQHO5czXij8ZfPp0g=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ucHhYU/omK/wPuhHNt4DAlMydq1ycVRvakyHR9FkTviGy3twJOZxnmHlQIKJPqLMj
 EcPLtbON3zRd8zH+i8BMKOnrZuf6mAiJ4/n3Pgp6EKurJ2Ph5LsIl9xiWqGhxuZqsJ
 MrkuuAciFCRNPGIvNm1hquo86SRubvWD4xyAQN5Fwz5+sQ3ttDLVGQV3VMH88WErAz
 q6EzZC7rB2Za/XQucmeY07nQuRGO/oA3XxuxGNDv52XZQEnatBt2J0MIuQifCDMZs+
 InK4aqZ4i6QkKB3LXU1P5+pocWki6MalIwG1RPmNTBSDxYq/KyeX5tmQj9cflHLCnu
 mmgGryASUKIz01vN3od/Y/SAbvPUJOgqOkliwYMRvy6PK3MWs+005yS2l4vi9llQX+
 fPZCy0m+d4BndbW00LC2l6tkG+4PrQGOi5NEAQSacufvGHIeyBs3KmtxnERoljkRiS
 iVrxfFpIZMHIVlzuxpmINd8Qz5EhUGjTcWHz7CcM5kCu3mDyFYv/U6U0XE56KbLJZO
 iSGViFtfkiO0yO56UnuYWHRPlgm45dOe4btv2mBoFTQ+TwFYIJbIF5J5rIGbQGWnnl
 jm4pJnv6MR+IGP8EmJaOVP/b+E/z2ao5VWLzGcPG3r2PPkGloxLHYZQiTkhNyWf1gh
 KJKYy3FCJPsH082MfO0aNy1s=
Date: Mon, 6 Mar 2023 22:40:35 +0100
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-id: <ZAZd0yMvJTV/h/DM@valentin-vidic.from.hr>
References: <ZASjOpsoM+nEx/o8@valentin-vidic.from.hr>
 <afce1ae289a52db2b210065a63a73fdcb7f3175e.camel@huaweicloud.com>
 <ZAXEVL8BZb96cxFX@valentin-vidic.from.hr>
 <e804e6881e96680107a4db3d4b81e5e898f5fbde.camel@huaweicloud.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <e804e6881e96680107a4db3d4b81e5e898f5fbde.camel@huaweicloud.com>
X-Source-IP: 169.150.239.92
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10641
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 clxscore=109 phishscore=0 spamscore=0
 lowpriorityscore=0 unknownsenderscore=20 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303060188
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] ocfs2 xattr
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
From: Valentin =?utf-8?B?VmlkacSH?= via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: valentin-vidic.from.hr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx -all
X-Spam: Clean
X-Proofpoint-GUID: 5xNGm6oywENhrfS8SZknn2eZdaopHUeP
X-Proofpoint-ORIG-GUID: 5xNGm6oywENhrfS8SZknn2eZdaopHUeP
Reporting-Meta:
 AAFQHusfr81XzsbQ/JK4aX2XmkqASTDNB6FpMDpRarL8SiCMrZCmaMAmsk+CCX/Q
 snOUhE2yX5tFwGeyTblgxGUEKwPMhOmjcrMNdcfWxjJ0vgyEZclcJPhonhuzJ1n0
 4RZU/d1zsFnuVmXqDc+QwmkPKuegat2p2OisMk0upFyBPNarElpTkj9lI28Db37j
 k7QhNOy11Wo1O9rm9e34GFPi1PkSPV8d5KOi4BX57WU/MxA3Hd43gfogbwEIKDO+
 sUwze/Ht0halVlFY2YgwNYhB3h+Qj/ncDRGJ6OKRpCuErfaC/OZ47REr+cIckmeY
 BryxHdZTLsPCtag1h9ypEk4TomZcK1p92WqXFyFeccK7IC8V+pJBuuv7VX8MdWfy
 ZGcfpXfxYc6meFCvhXUTWerfEIXZ6n4GXjSzgyz4JCD45MIkgP9nX2Ji4qKrq2ni
 +h8Wl/0WyA7hGNPRC4Yv+f+dMT3CBF17bqCLgMFv6729ndjOvv97eBNsTmea41pG
 tOnW7NcoNjX6k3s5Tv9Dz64hVE5Rk8ddui3CSoAS8+QM

On Mon, Mar 06, 2023 at 05:58:30PM +0100, Roberto Sassu wrote:
> If there is no hook registering to inode_init_security, theoretically
> the LSM infrastructure should return -EOPNOTSUPP, which causes ocfs2 to
> set si->enable to zero, and not execute the line that causes the kernel
> to panic.
> 
> The problem would arise if somehow the LSM infrastructure returns zero,
> without setting the xattr. That would explain the panic.
> 
> Not sure, I will think more.

Seems you are right. First of all, there is more than one LSM active:

[    0.048241] LSM: initializing lsm=lockdown,capability,landlock,yama,integrity,apparmor,tomoyo,bpf
[    0.048250] landlock: Up and running.
[    0.048250] Yama: becoming mindful.
[    0.048293] AppArmor: AppArmor initialized
[    0.048295] TOMOYO Linux initialized
[    0.048300] LSM support for eBPF active

But from the source it seems that eBPF creates all hooks and returns the
default value of 0 for inode_init_security:

include/linux/lsm_hook_defs.h:LSM_HOOK(int, 0, inode_init_security, struct inode *inode,

kernel/bpf/bpf_lsm.c:#define LSM_HOOK(RET, DEFAULT, NAME, ...)  \
kernel/bpf/bpf_lsm.c:noinline RET bpf_lsm_##NAME(__VA_ARGS__)   \
kernel/bpf/bpf_lsm.c:{                                          \
kernel/bpf/bpf_lsm.c:   return DEFAULT;                         \
kernel/bpf/bpf_lsm.c:}

I suppose the fix would be to change the default value to -EOPNOTSUPP?

-- 
Valentin

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
