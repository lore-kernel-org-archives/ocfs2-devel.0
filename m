Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613A2C636CC
	for <ocfs2-devel@archiver.kernel.org>; Sun, 19 Feb 2023 19:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BcKYAjfTpLEPoSR8vslLbkGUKBx5sJ+IPOnDzIPZYto=;
 b=m/d14t/0/HcMxCbuI654NjfcfG5x0nxOD50HvrWyg6wAWD4xd4lmVdG2vW5/dWNvD5GUryS4feZA
   i3yQGO/E/f8g3F5W/FN1l4RvcbLAN56cdrnW9YJ7kgYLst2+2FIcKF1fpCgCpp+5nxThgLAB5FA7
   PwiLxKCbm7WbggPOUfoHFhZdL5JWRqXTSpPtDAUim4XaW2xIW3SMWlzHme98eoTDrjtcT8NFcHhy
   N9yPemdpoKKWg/dO8nogLgtSomg5zQ/NfRrahxMyduHROR+z2eOanoPwzSAyeMQGvygSJPTT2208
   C3WN8a/IN1nMFAaQhEAWArswHdxdTqmGFNeQrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BcKYAjfTpLEPoSR8vslLbkGUKBx5sJ+IPOnDzIPZYto=;
 b=othxmtG9UnXSBAWS+TB2ByqCf7mz+dtrfDc/GaFDf6gZ13IMRuR1XGJkaSs/07rFVWvuDuQ/ys+a
   agsnzWf/SBoaOYo2M+u3udcYgfqelt3lbiXy/j+DiA+3/Oy0OUtTIxm3bnryrt7NFg88JmR6JgDT
   k+MhP2eyNvajuRGJB2i/WoYXG2xokeFgg9/a3bID7NZtPiET4lQg3Ytsy+C53vLzqvUjGAG0dTe2
   56mnkgubXAsYPtBN/BA3LcuD2aOu8TI5oO/3dc5EWNj/qQwOEUEpZJz7c6VkkTBUOPaAMlpPOQ/I
   SUl6oJW4ABwWFyZNFp9dy3u9VSghKmUmasZTyA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQC00I5QERQMH70@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 19 Feb 2023 19:43:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=CYJ3eVTHiOWV/HXfh9LoWzkEjLJj1zuaaERAokCGMZs=;
 b=bjvkbRBpdRlQYGx8F56LZ84vecCQkZCmXwUUKkStfqw17eZhU5SifB+n2Zi0Mg5Wj9sN
 qF96Ef4o2I+KpYf56z7dDs9QTSrIkIpr1/4kyD4kHcATim1bhy8CcQkJx62tSW4boqZZ
 Ues6C+peWWA9xHhZRSqFAIMoP5eQ4R/eg/4NaeojKtHgD5cvlGuGo2nXcnGU0NoHrTsW
 IX+f7mQr+qCWdlgjEO/7bqygXpVKD3guhiiFnhZwAsHBF4XyZONsk9pFkyhdHZH/Sal7
 Ag7nvl+ztC18vkJm4mOogFRItX/Wo0GYVuwgo9JTa+BvSrgvpmSm0yOLNpsxG/5fxB0g Hg==
Message-id: <1f252850086a39e3c15736f252600d388f6b9c24.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Sun, 19 Feb 2023 14:42:11 -0500
In-reply-to: <20221201104125.919483-7-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <20221201104125.919483-7-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-19_12,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302190186
X-Source-IP: 148.163.156.1
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10626
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=135
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=172
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302190188
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 6/6] evm: Support multiple LSMs	providing
 an xattr
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
X-Proofpoint-GUID: 7b-pCZGs1qZvFb8xE2CXrq4yIG5ubRZT
X-Proofpoint-ORIG-GUID: 7b-pCZGs1qZvFb8xE2CXrq4yIG5ubRZT
Reporting-Meta:
 AAF+v/BlI3r14m+z9LZlxPj80IBhaD3GQ8ap8wWwgbeiYw4kzkjpM2weIorheEom
 13qrWNo5H7FevIu9BucrcwuoTZoudj7c74/M/Tm44Mfa42nNgBVntb63qImu37mD
 DmHTa4ZF1SNUeXLUrYvZO45lZ/K3Gxjcgoq2+wp72EQOYwA/n4H6NbSGhnD4HQlz
 TJB7riR8B3FSaeKvUAjyBdzEtKRjAbR7jWWhng2tuAPqM93kvAOmfe6ssiubiPXh
 iuEb1ecpaqciO7hm69PXcu3ceoUHrJMfeAzNneFertjgI6mT7nn/Gsa2FYMquyJY
 GFxEIV5E/NqCma9avk1oGnv6JWw8jLqthY+ddW7Oz2/i7FIjxRC2v5erPl2G5BJz
 VD8YgYiy4onztBaYFDNfcYXrVb1eRhViRCgYuqwkcnhYJJXLj6jiV5yh8Gv71ySn
 TcY3J9H+5Q7Xw8zIviRwO8/Kd5O38Reu8VHx3ZBZW42m22npKnn2UDmx93Om4ewN
 jgibNw4Qi7TmPKwD4mXGmrz7TNqtWXXNgAjtl908A48=

On Thu, 2022-12-01 at 11:41 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Currently, evm_inode_init_security() processes a single LSM xattr from
> the array passed by security_inode_init_security(), and calculates the
> HMAC on it and other inode metadata.
> 
> Given that initxattrs() callbacks, called by
> security_inode_init_security(), expect that this array is terminated when
> the xattr name is set to NULL, reuse the same assumption to scan all xattrs
> and to calculate the HMAC on all of them.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>


Normally changing the contents of the EVM HMAC calculation would break
existing systems.  Assuming for the time being this is safe, at what
point will it affect backwards compatability?  Should it be documented
now or then?

-- 
thanks,

Mimi


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
