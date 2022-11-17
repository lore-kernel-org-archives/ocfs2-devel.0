Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50863C4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 17 Nov 2022 19:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZbirO1zLa80XbJmS+xaZKQRIlfh3W+cHzwWpaGfeexg=;
 b=3Z0C6kE4OYTmG86LYRAlXMZBtdj9DZx2iMExAyy/0D1+vh9BBcynwDiKE6t47ZJVK3USLiOYQUG4
   j0DEPHHhCvAv7k5W9cMAm6pvoVeXWRFSfML2PTO36OWME4jotX/lt2QzX0nlPyEB1LkffUx0dTC0
   ppoDRab1v8Ono+tNpkTi7U3/AmkCBno/uW9zU0N89F5yw8aw8Na9N2f1ae0N2hsBu7T5Lu2P4Xpm
   Zt3xleDd76kJyUfEkbwAki4v9ykaJn3IPA7HFbUi7rV2WoPsL+FKcsP1ZhZQZRJ+qhxZZjsmV2A7
   boi0UrZkppaYDxKP/jMhE+ANx4HhbMxcM0qozQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZbirO1zLa80XbJmS+xaZKQRIlfh3W+cHzwWpaGfeexg=;
 b=e2/yMkd0lT47bRNMDq8CZsO8TAm0mEX3prQAIZRI01Qa6sdDvw1SG7Nxn8h0O44M0ng6/C72ToJ1
   r+V0mNeKZnVtsMmDQnWzvMog7Hx99ipwCoNGcBICla4QeE16megWeaQNsf5DOpWMJd1ZyUH691Hs
   hv1EGVrLGYu2h3s5+wiusitV3k0ZXmmFeQf//nKhP5ZvTsiR6ce9QdIGGd72sm9fXoJ+UJeRmSk3
   7kTRacLCE/Sz5zUvaju6zlmYQgNtGrBfyTCo/hc/rm3i9TfMwj2hgBZjhfo8LHd+bC1K7VcBeBZG
   qdN3IZYhYDkrafwBxUKz1A0/bY+oRS7wNdK38Q==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLI008V4CKGTKB0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 17 Nov 2022 19:53:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id :
 subject : from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=cjadO755ktE+yKQ9dqvEyND9KuoTueb/HI0lzO/4C98=;
 b=YvHMKRCrogST5xyWZfYmlYwkwLW6HQs/viZTSN08nBx2m82E2YquWuJwq9pgWx+/4R6u
 TBjMNPTSafdvsijI0SG41foyzEzF5cw0qoEpR/7XU76HJ+AGGbEIhQeBlqI89yBFniEx
 sgRQxyPA7ipIonISh6ZbmR8LgcIMPHanioK+NnLkbFUmOkJd9kTl58Pd1V+thq7d6RZ0
 T2q7vwXZgaImkqCpt3yAWUrh47sYev/YXFfvDnhKyURB6tYnPeYbzw3MeRa2GiWP4Tew
 z+HwHnVVGonTYxXhKYqV9sC+CTmxBnTs4vonUfENrUGXTCJX3o3vdiGBZcPT/ESSrDis bA==
Message-id: <3dc4f389ead98972cb7d09ef285a0065decb0ad0.camel@linux.ibm.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, dmitry.kasatkin@gmail.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
 stephen.smalley.work@gmail.com, eparis@parisplace.org, casey@schaufler-ca.com
Date: Thu, 17 Nov 2022 08:03:23 -0500
In-reply-to: <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
References: <20221110094639.3086409-1-roberto.sassu@huaweicloud.com>
 <20221110094639.3086409-3-roberto.sassu@huaweicloud.com>
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8)
MIME-version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=776 impostorscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211170099
X-Source-IP: 148.163.158.5
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10533
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=754 priorityscore=206
 adultscore=0 mlxscore=0 clxscore=150 malwarescore=0 impostorscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170099 domainage_hfrom=13392
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
From: Mimi Zohar via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Mimi Zohar <zohar@linux.ibm.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-TM-AS-GCONF: 00
X-ServerName: mx0b-001b2d01.pphosted.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:148.163.158.5 ip4:148.163.156.1 ~all
X-Spam: Clean
X-Proofpoint-GUID: f3YZteNQvhX-jfbGDQzrrawWk6jbSpIX
X-Proofpoint-ORIG-GUID: f3YZteNQvhX-jfbGDQzrrawWk6jbSpIX
X-Mailman-Approved-At: Thu, 17 Nov 2022 19:53:02 +0000
Reporting-Meta:
 AAGkThYknW0cwLBleZhrOdw0PGzKGqOpF1g+L8LHpERwqP0kxMIjv12fCM9RIZdu
 RpK/39OXA2MFj13djEEg1qIcIDlUXAsKv7bMdqXVBoUnR6SiCNSInYfldxFpUuoO
 LlxGJdC0mN/DTp0xvCHdecfTMl3zY9tm4oJ1nIhEc5FduHUhCwJbVS0P2e8x5y3A
 gmfq1GRoPiHJCwtg0cRb+wUGcznZORz4IYU7Jpan03NXR7Ursyp6+g2ScKqWjnaN
 uWSTMZ4fBHT21sI/mmUK0ufGf991wypeNXxYGxut7qaizWMLp21rh2MwyqBGSRcb
 a5Ox6xGSHy5bLRlMcmP1Jo9OdPUVSu2Hm7+toLj8Zm22CvhSA3i7v51Aajayc72+
 0jAoO5n/40e3k+hgIj7ODOvHdb+Or6S/sL17MJy8mg6QFc7HmwvkvLQlTP/wj4qT
 3bqJLbcJnPNQyehGmtLycMrp/tI8aWwbdZh329UvUiFh2p60bcHqPRm0uOgjV/gr
 cnSwLnKcRZBZNxKCRDnAuIuB7OZT5/EVj2S0OiF2UhiG

Hi Roberto,

On Thu, 2022-11-10 at 10:46 +0100, Roberto Sassu wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> Rewrite security_old_inode_init_security() to call
> security_inode_init_security() before making changes to support multiple
> LSMs providing xattrs. Do it so that the required changes are done only in
> one place.

Only security_inode_init_security() has support for EVM.   Making
security_old_inode_init_security() a wrapper for
security_inode_init_security() could result in security.evm extended
attributes being created that previously weren't created.

In fact ocfs2 defines ocfs2_init_security_get() as a wrapper for both
the old and new inode_init_security calls based on the caller's
preference.   Only mknod and symlink seem to use the old function. 
Wondering why do they differentiate between callers?  (Cc'ing the ocfs2
mailing list as they're affected by this change.)

"[PATCH v4 1/5] reiserfs: Add missing calls to
reiserfs_security_free()"  fixed a memory leak.  I couldn't tell if
there was a similar memory leak in ocfs2, the only other user of
security_old_inode_init_security().

As ocfs2 already defines initxattrs, that leaves only reiserfs missing
initxattrs().  A better, cleaner solution would be to define one.

thanks,

Mimi

> 
> Define the security_initxattrs() callback and pass it to
> security_inode_init_security() as argument, to obtain the first xattr
> provided by LSMs.
> 
> This behavior is a bit different from the current one. Before this patch
> calling call_int_hook() could cause multiple LSMs to provide an xattr,
> since call_int_hook() does not stop when an LSM returns zero. The caller of
> security_old_inode_init_security() receives the last xattr set. The pointer
> of the xattr value of previous LSMs is lost, causing memory leaks.
> 
> However, in practice, this scenario does not happen as the only in-tree
> LSMs providing an xattr at inode creation time are SELinux and Smack, which
> are mutually exclusive.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
