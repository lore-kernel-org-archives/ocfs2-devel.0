Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C05C4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Nov 2022 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aCo8aTa5/ahDdvMOqkI8mxaZc0AKfDa21dEa9uWzL3g=;
 b=HlnkdMho1fX4w8Psv3pkLPBOGV0DjrRRTxCdbKb8B451kaIQhlhop3NcquJktVVKvftqbw5hCzoY
   E1CO1+TiEmbD7Ru0/cdiAhm1D+7kLawFD7IKZm4T2ZidpPlqf1XjMo9jNOu4dOL9Um+K8fNV/jRX
   VC3Bk8cruU6OuvldQTgTLbeFX9FZjyM/RJX4KZdk3AJU5K1Yoe4ahIpmnU5fdZJeexTRwk36ofJA
   9BBnlK7XvqjDVvipE3qr+eXgWpssfUyvrmI+2rXxiwurHxz/s/FOLtcfEj5pc/4NRcgCGfYwfGMK
   kBAwzqVkvCsm+ehs7vUWUCv3uJPlNJPFm6qagQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aCo8aTa5/ahDdvMOqkI8mxaZc0AKfDa21dEa9uWzL3g=;
 b=JkjHZRTOhiDRR+RcsUWSPcMKY33MGAU+KgnStBntcErptEP6DfThTtXmMxbMqMPtDurrwlmSnL9T
   8ji/qP15rmJAqHmE5Vwu3QtKlSgAKvM/FlcmK24HYOMWBPDuGIkokQb3znZEHC1IwnfrwdNlXa32
   XFgSXyBQrTVsNY5cqYPF3zpZ0yWWFb+KOv1B6odFkOZY9/qHAZMstqzKS6nS17a8fIEajYLA+iy1
   X9YJ2khbKEtJH2TAFTgeL4a2KxyJLrLnQnAN5SIKj7/WHe84kAz+WO9ZHl0WtKRKrDmR6HmN4HTV
   273F8GXKgSBOxGcf/xvjfZPhGUVObTET3qKF9A==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLO00D0UZDOGY80@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Nov 2022 09:51:24 +0000 (GMT)
Message-id: <aa5fa8c5f231115c58012352124df57d16a01e41.camel@huaweicloud.com>
To: Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Mon, 21 Nov 2022 10:45:19 +0100
In-reply-to: <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
 <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
 <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10537
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 suspectscore=0 mlxlogscore=973 clxscore=-27 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210076
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] security: Rewrite
 security_old_inode_init_security()
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
X-CM-TRANSID: LxC2BwCHcW65SHtjOoSBAA--.28097S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCry7Xw1UCFyUJr1ruFWDCFg_yoW5Kr1Dpr
 W3KF1UKrn8JF97CrWxJFnxWF4I93yfGFZrXrs5AryDAF1DCF1xtr10yry5u343JrWkJ34F
 qw4xZ3sxZrn8Z3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgADBF1jj4GngwACsT
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: kT00775X_W15N7a1dDVnHWKI8NdbaVrW
X-Proofpoint-GUID: kT00775X_W15N7a1dDVnHWKI8NdbaVrW
Reporting-Meta:
 AAHsdoqHYeTrY/fR0lOp3lXBFo+EwgElf44pZZ/gPZkNcacu+k7L9aqJpDAGusAw
 ly2aNzK00HKhY6N9AvAUqmZ+KYzGh8sgkmkOWfedOKrDy98aHm4RknxNS79xist7
 aukfFbzJtfs+YLEj1VNVrAd3aqhgu3jB/qd+CDhlAtvcHyQldK4URZlGptd891Qc
 sPwpKQG0e8hPKWZuv/n2XuELXgjGEeMqV/AbcwdB/sMMZZ+Q9oTwwCO3bO+SmmiM
 BjWxowmfBcOHSdUsmNKy9yofWebo78swESTGSrvjF1HfGKwhUPvXG4C7j7bCnw8T
 JIcnZ2XmM2/fWhORnvXfvHqc9KxjBCqpl7QWY3DTXKyxLuQZCoyU8/RfyEj2/eeJ
 xzIbtgjJgtuQCokode69+dq5377CmWB6u50G9fyN113knwNtYMRUHPaVLk6BEYwQ
 YPIAWq2TJgBg07M5jWe91olqV6xiJOiUzSyIaJkeI1NUakHmOqPYKfdfYPKIfxW3
 JN0G/W/WP9z1V6LJkzofiJjfau8Ks4x716u7j7sOUHWp

On Thu, 2022-11-17 at 08:03 -0500, Mimi Zohar wrote:
> Hi Roberto,
> 
> On Thu, 2022-11-10 at 10:46 +0100, Roberto Sassu wrote:
> > From: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > Rewrite security_old_inode_init_security() to call
> > security_inode_init_security() before making changes to support multiple
> > LSMs providing xattrs. Do it so that the required changes are done only in
> > one place.
> 
> Only security_inode_init_security() has support for EVM.   Making
> security_old_inode_init_security() a wrapper for
> security_inode_init_security() could result in security.evm extended
> attributes being created that previously weren't created.
> 
> In fact ocfs2 defines ocfs2_init_security_get() as a wrapper for both
> the old and new inode_init_security calls based on the caller's
> preference.   Only mknod and symlink seem to use the old function. 
> Wondering why do they differentiate between callers?  (Cc'ing the ocfs2
> mailing list as they're affected by this change.)
> 
> "[PATCH v4 1/5] reiserfs: Add missing calls to
> reiserfs_security_free()"  fixed a memory leak.  I couldn't tell if
> there was a similar memory leak in ocfs2, the only other user of
> security_old_inode_init_security().

From what I see, there is no memory leak there.

> As ocfs2 already defines initxattrs, that leaves only reiserfs missing
> initxattrs().  A better, cleaner solution would be to define one.

If I understood why security_old_inode_init_security() is called
instead of security_inode_init_security(), the reason seems that the
filesystem code uses the length of the obtained xattr to make some
calculations (e.g. reserve space). The xattr is written at a later
time.

Since for reiserfs there is a plan to deprecate it, it probably
wouldn't be worth to support the creation of multiple xattrs. I would
define a callback to take the first xattr and make a copy, so that
calling security_inode_init_security() + reiserfs_initxattrs() is
equivalent to calling security_old_inode_init_security().

But then, this is what anyway I was doing with the
security_initxattrs() callback, for all callers of security_old_inode_i
nit_security().

Also, security_old_inode_init_security() is exported to kernel modules.
Maybe, it is used somewhere. So, unless we plan to remove it
completely, it should be probably be fixed to avoid multiple LSMs
successfully setting an xattr, and losing the memory of all except the
last (which this patch fixes by calling security_inode_init_security())
.

If there is still the preference, I will implement the reiserfs
callback and make a fix for security_old_inode_init_security().

Thanks

Roberto

> thanks,
> 
> Mimi
> 
> > Define the security_initxattrs() callback and pass it to
> > security_inode_init_security() as argument, to obtain the first xattr
> > provided by LSMs.
> > 
> > This behavior is a bit different from the current one. Before this patch
> > calling call_int_hook() could cause multiple LSMs to provide an xattr,
> > since call_int_hook() does not stop when an LSM returns zero. The caller of
> > security_old_inode_init_security() receives the last xattr set. The pointer
> > of the xattr value of previous LSMs is lost, causing memory leaks.
> > 
> > However, in practice, this scenario does not happen as the only in-tree
> > LSMs providing an xattr at inode creation time are SELinux and Smack, which
> > are mutually exclusive.
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
