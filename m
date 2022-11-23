Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF42C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pmGYnPBApMtjb1rPI4ay1if9TaTlgCK7grr3QKhjuWg=;
 b=v9dfmsVN5xL+WBowKEb5Dccpag6Lol3NgXfjqQkHFwKTyN0yi73sX2H/oZqvn/kaT3leSzzUcRGg
   EGCEqnoKRynGgusZqQvhxYyNUNfkYNuFgZU/2GhYcz1nRUHD5Eiet6tI69dMSPqlutpKM6WorIOX
   FN27Nh+YTztEP84fPRZMPgiqHwKrORdYiYpYs6Ijb9Ocm36XGcHD1q1/ikSTQqOHATQuuQB0bsYd
   NcBF9pwT6nFkEoY1KNudZRmwEoj/N9jCIoQBD66d+xChsjcI71fRKm5KeqmYTSI9lMWSZcwDw71I
   7Da4w7CKFTwgelDEqQVYyzH8w5DSmJdRdmj6ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pmGYnPBApMtjb1rPI4ay1if9TaTlgCK7grr3QKhjuWg=;
 b=Z3iOHni9qRk0fKdHAqjAbZJkp4LEgjusVMAe/GAlv3WwvqVgTCi8CNMUlpDeV7si8ZDlHQSUOQpY
   D3n+6SIXbYMbR2GcGBhwOHVd8Q66DslLXpWFrnvtwABUvkBeaao4ZyAYvM3xIuqPm69dVV/YoZFK
   HfCLNqH4Ykbsf6q+4s94aISgzEYvzh9/SFQlVFbAb1N55QAR6dMT7JXQ8lAUguyjtGSuD0119coB
   R7Xqr/oXPe8WFU3b0iq5e0AWoOzLPa3TPpv2J5+j22nNj1qN/WhlDkbRcqDyRH3/Rj4tOphbV+Ov
   25ySWzR7my4r6r3pGTB3hIo1ZlKStH2cBy5+eQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00E30W0MDU00@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 12:29:10 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=z6Z//LUT0fOyn/j0x1lDLd1Mhd5eIGzmBSNnRr9ZuF8=;
 b=IqzRD4WR9jzHU0/inl9phbRdTIC68a/YMhn4PsPPnZjzrTYotc7UiHLU8znqVJO8yY8D
 QtmKtjYlGfrmqztS42seEwgmCxBbf5NVKXHnH0yLlOYg01btx/1d8lf+NWrT+kk+IEdz
 2rsnkXf3tf5qnMVDqft8/EXkLSjU4Qdrt2IDzqtz6VGi4WnaVW+u+IPOIbZqZya5h7l0
 EYl1pJ/5iYKpT12tX7krp+LgQdB8bJXfTIiPTBYIHGcy4f64BPGkC7QsshT5tvK23G25
 Ax6iaLX/lrtfmbd9QSfYGaufkDHF7SWqtnxuE46abOXjKzMwLz86iD8XRFhz9zDmS6vC pg==
Message-id: <ccf1937cfdcc5bb28dcc7a58785dd0c65d974597.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 07:28:19 -0500
In-reply-to: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=703 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230090
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=235 mlxlogscore=682 adultscore=0 clxscore=160 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230092 domainage_hfrom=13398
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 0/6] evm: Prepare for moving to the LSM
	infrastructure
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
From: Mimi Zohar via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mimi Zohar <zohar@linux.ibm.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-TM-AS-GCONF: 00
X-ServerName: mx0a-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: GLrj0QatM2xDgvbICyPxzjU3EwmqtVo2
X-Proofpoint-ORIG-GUID: GLrj0QatM2xDgvbICyPxzjU3EwmqtVo2
Reporting-Meta:
 AAEjfNfxmAyO/DtV5vI9gPVeibIxXI/WgDi11VmaHesMNropXIvvs6wSOerP1PvC
 Em9WkQfXiHtjm8qEV6JMvDQmUb5CPOriODoFWgEau5gTJRt/Aw8asy6U+gzez+7Z
 hKmAf8mbGNCXwOGPax6juBXy7/0tnVGzAnWmtBHKOpZoas1l8U4ySq5weQbFFMpI
 Li9zKrMnx0xmaiLwkOywxLEXFuhfcuyHc54uodrh/x8w4X62ub+Q4wbvNff/I6PR
 oaTWIspbsyJAFuYdExCYqLxurm7U8b5prKLKScyWHUtI5HIkTQlh0ENFuiQxpTt7
 a+mx+ANjOawSXHGFeYzWcbMrA0/KC9ilSPTYSRW6osY9jtpjKqmqieDWdtfkzAuh
 ikgmASEGys7vkA2M180bfQaWIjLPw9qTD2+bv87aiNIpaPtINj98BhQ60jSGlwEO
 y0V+1/iUpgT76j2sgwLyAUKH2OUgB3gxTvCKE0ZTRx2uEF7IlIgcsNLBRyvM/hWM
 gkDcAw6weObQR8vgwgRez9CL53fFKR2Oi222cGhAvcyG

Hi Roberto,

On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> One of the challenges that must be tackled to move IMA and EVM to the LSM
> infrastructure is to ensure that EVM is capable to correctly handle
> multiple stacked LSMs providing an xattr at file creation. At the moment,
> there are few issues that would prevent a correct integration. This patch
> set aims at solving them.

Let's take a step back and understand the purpose of this patch set. 
Regardless of whether IMA and EVM are moved to the "LSM
infrastructure", EVM needs to support per LSM xattrs.  A side affect is
the removal of the security_old_inode_init_security hook.  This patch
set cover letter and patch descriptions should be limited to EVM
support for per LSM (multiple) xattrs.  The motivation, concerns, and
problems of making IMA and EVM LSMs will be documented in the patch set
that actual makes them LSMs.  Please remove all references to "move IMA
and EVM to the LSM infrastructure".

When EVM was upstreamed, there were filesystem limitations on the
number and size of the extended attributes.  In addition there were
performance concerns, which resulted in staging the LSM, IMA and EVM
xattrs, before calling initxattrs to write them at the same time.  With
this patch set, not only are per LSM xattrs supported, but multiple per
LSM xattrs are supported as well.  Have the size limitation concerns
been addressed by the different filesystems?   If not, then at minimum
this patch set needs to at least mention it and the possible
ramifications.

-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
