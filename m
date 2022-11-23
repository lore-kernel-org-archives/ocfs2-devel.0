Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9346C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8huClSYiMxa5qL8aR2ekon3lIwCp7TrOWI8YNJJ8sts=;
 b=ZxI2gv4hcjAI83USVS0v4ENVxnknhl9KAffBLvseCGXfvlB712SmUHvLc6NduMjVpo54grCSgTyS
   /DCEmSN+q3InXX5iKEfmyWYVD/RHxYe88kI63EF8lAeeFq9pS2u6LsU6Ygt1meNHmDoot2l5HatI
   7+pAvmY+cKa+0+lwm4J/01P8rW7nzYrDQivMm25jcx6oyRtR+JjvRKUR5pmMAaGCFu+p/hepxvc7
   CcujWHGUuLXPRLoeTzCJSTVcm05H8MqQF3ei/4LCne96Kdj9gfeADtwazuaiqnWCc/BPDgOBhrTq
   VxvPFH4pqV2+jcmS0QfugnNkOjZkXATBKfK35g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8huClSYiMxa5qL8aR2ekon3lIwCp7TrOWI8YNJJ8sts=;
 b=Fx9aLVod4InvRtX2AUwGRR0LrzJPbA6id1JxQkfy46LWxp39pHVxMJ/kcRXzK+cjVJny67+P4QUS
   WJtWoIyMsHaW7o5XMspVXtJMd/23BROMbn9IwWCMQQNay+CYvzO5NsJED97nVUM9D7DBgavdaBgH
   Wv4hi4SnGG0S8CGBYeX8/0v9f4JmMkdENcfn7eSLTL6djY08FiK1l0aYMDXkdG8tlFiN8IBdX5QJ
   i+WCBbp0nlk5mj8wKD8flf3vMaqlGNLkm18n31SUJ1dyp76MqZUgCyVHzhLPG8hwBUl77KCu3wIu
   Rf++rCn/VvfBSrOnNuzn0aMQ633sxACUE4z8cw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00E7SWSUHJB0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 12:46:06 +0000 (GMT)
Message-id: <22f47b9d2cade322f9037133b0940640423f9590.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 13:44:57 +0100
In-reply-to: <ccf1937cfdcc5bb28dcc7a58785dd0c65d974597.camel@linux.ibm.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
 <ccf1937cfdcc5bb28dcc7a58785dd0c65d974597.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=552
 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=118 priorityscore=90 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230095
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: GxC2BwAnDvrOFX5ju+aJAA--.57342S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KrWkAFyrZr18Zw1rAr4xJFb_yoW8tr48pF
 WfKa4YqFs5tF1xJ3s7Ar4xZ3yUC3yfGw4UKa4DCrykZ3Z0grySgryS9FWFva4kWrsYga1q
 qF4jv34kJws8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
 7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
 Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
 6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
 AIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv
 6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU13rcDUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAFBF1jj4HJfQABsG
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: aoq_MUvq_4gPDvc1MGtTluwLdPciVaAK
X-Proofpoint-GUID: aoq_MUvq_4gPDvc1MGtTluwLdPciVaAK
Reporting-Meta:
 AAH3buQ/5JfAkjJxVgl7pqek32sCvX8Ld/qGISiQQOIPOL5nQLPgnScqparyeKlo
 W471rJriG2V27Fw5Ttv0NEd0JFLSNx/YUbPJWioHVdRtCSPyDTnUB+CkkZ+EKVdU
 cQ6KWLnP5QMCA1jLtSo/FZv9+lGu63fHvKYtlUVI8FMBaBMMQ3BkXBIPZl+fNokQ
 5IYi3EbgaaEJlwohxKi4Wt1lAI3T/NOClTIblh61Ibvx3+MudbTKi3wtngfFFoQs
 npIvCWAVc/Ka1aHCg7I+a8eZfiP0BvgHmR0di42QNMKOR4+OfrB7i6J9/DWm/+Cq
 q8Bxys9hysit0UhH2SgfOwnndgAjajsBr+bOam5uXE0PKPLYzWfQJXPXZmY0/kS0
 EWN+l4HRGbFjHMgIA3Dkj31UMqNv6gnVwsYVbf0ajvU4EFxN97gJ2CzlD4I72DlZ
 18AFAJmdK6R3t+ytewVhz5tFnUg83ROggN4ljZt9r6uf8bu98wXpTj0MPMn9B/Jk
 V/fIELolzX51TM/Eog5csKW0xdnakwpyP6YtcLGbtzia

On Wed, 2022-11-23 at 07:28 -0500, Mimi Zohar wrote:
> Hi Roberto,
> 
> On Wed, 2022-11-23 at 10:51 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > One of the challenges that must be tackled to move IMA and EVM to the LSM
> > infrastructure is to ensure that EVM is capable to correctly handle
> > multiple stacked LSMs providing an xattr at file creation. At the moment,
> > there are few issues that would prevent a correct integration. This patch
> > set aims at solving them.
> 
> Let's take a step back and understand the purpose of this patch set. 
> Regardless of whether IMA and EVM are moved to the "LSM
> infrastructure", EVM needs to support per LSM xattrs.  A side affect is
> the removal of the security_old_inode_init_security hook.  This patch
> set cover letter and patch descriptions should be limited to EVM
> support for per LSM (multiple) xattrs.  The motivation, concerns, and
> problems of making IMA and EVM LSMs will be documented in the patch set
> that actual makes them LSMs.  Please remove all references to "move IMA
> and EVM to the LSM infrastructure".

Hi Mimi

ok, will do.

> When EVM was upstreamed, there were filesystem limitations on the
> number and size of the extended attributes.  In addition there were
> performance concerns, which resulted in staging the LSM, IMA and EVM
> xattrs, before calling initxattrs to write them at the same time.  With
> this patch set, not only are per LSM xattrs supported, but multiple per
> LSM xattrs are supported as well.  Have the size limitation concerns
> been addressed by the different filesystems?   If not, then at minimum
> this patch set needs to at least mention it and the possible
> ramifications.

With your patch, 9d8f13ba3f483 ("security: new
security_inode_init_security API adds function callback") you made it
possible to set multiple xattrs at inode creation time.

This patch set pushes further to the limits, as there could be more
xattrs to be added to the inode. I will mention that.

If there are too many xattrs, I guess the only solution would be to use
less LSMs, or a different filesystem. The per filesystem limit could be
increased separately case by case.

Thanks

Roberto


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
