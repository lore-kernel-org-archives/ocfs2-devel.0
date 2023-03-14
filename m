Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19955C6FD1F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=23MAMuhAorHkfLjL5Xw18Z8Z6/EPcMfOL7PBKNkG5hs=;
 b=UXbGpthU3Hm+yi9dtdBphFCHM9qetFRI96e2fOU7QQ0JympDTk7iKMTByyM7JZi+SFhL0OQc3nud
   8tHOwBVwV/TNICkfoF7wcMNPGbp0CL0YmB8c72lGEtRJNoK5CbGgqfPxSJukTj9VlV6z5zV0T8qi
   pc6Vv+yg/1ciley5qtcdmhH7PgEgbF56dpjYM/tpGrkmwMgLWxJ8aySHR9IsbhMUhwAu/y42wWDC
   K5mAV/0jTQjCxFRpWF4hA9GOjnaOSVa5gcppeT3iGCxTMJ44PEhVMAr/WVchlGRnIqX5N3GTSVN4
   tI8H1AtMuXs4tDU2rpDwKHOeWMeg/5lvSRD2SQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=23MAMuhAorHkfLjL5Xw18Z8Z6/EPcMfOL7PBKNkG5hs=;
 b=rIvTvCzk0Iw8HUeX2t4RaxIy1E0zLMC3RQOk/LGLlsyJ4kBxKoij8BJ701CnE1mgqA9VqzM87t79
   0RWvyCU0dupvC+6Xk/nbNn8AQsUdbQLAW03onQPH5rnS8jGdhZGcdAHpKAwJTxGQ0Uary9c/owSh
   jSswGl9KlS73Zhss6fsExM9tqXHco68yYb3Mw3tWwfaf0TAOKxgRa2fPs+76rcvRgfZuas4II3Up
   jcuWsREbFp6qY8kYTsMs6RnB+clqK+cPzrGXlAwxm+7nZxJbNyesgWe3mlnrm2N23VqOtAYzTqT1
   43ufXr/fddWwYEX7JEcowYv/3zhMo154InpV7A==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI00C834GVSTA0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:19:43 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:17:20 +0100
Message-id: <20230314081720.4158676-7-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxscore=0 priorityscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 clxscore=72 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140070
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v8 6/6] evm: Support multiple LSMs providing	an
 xattr
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
X-CM-TRANSID: GxC2BwBnNl2zLRBkenSXAQ--.34127S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGryktFy8Jr45JrWUJFWfAFb_yoWrJFWkpa
 98ta9rCrn5GFyUur9ayF48ua4SgrWrKw4UKwsxCr1jyFnFqr1Iqryxtr1Uur98WryrJrna
 vw40vw15Cw15t3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
 Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
 rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
 AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
 14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrV
 C2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE
 7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20x
 vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
 3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIx
 AIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI
 42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z2
 80aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZo7tUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAQBF1jj4aJggAAsq
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: zZ6wwTPNjRo_2DWaEFXHCBSPkf0vlo9c
X-Proofpoint-ORIG-GUID: zZ6wwTPNjRo_2DWaEFXHCBSPkf0vlo9c
Reporting-Meta:
 AAH3HnWsoUXRvk8DhGZ/mheKa7MC6nWwy5xpf4rvdknePTLosHiw1nbkAKRJJjhb
 nAT64ol1BgHKeHK9Dt4z0g6xseaq87q8P0ym/zLf+4Ww4nk/OT1kl8KTfaPtbmvQ
 2+oRzXpbZVPmGVrDczh89KTA/OCmiEUIz4Xf1CIvF2DV9rRO/xHgJ6h67CmveN/X
 Z2SWshee4vkJcoStyu/IjPhr1Z4pMaOXCMRn8/cpiTMyjA1emm6F1oe5RDhdwoNW
 BUvuf2B+pQtPy7O7NQqz5cn/qOI0G1q5cIz/iTnkaYVfjnhsF6bTyPl5ljXTcWds
 s7pMTUh7ZINaMDgahznDWBZnB7HyNLa8JyKIrI8i/8EyhFlgt773TT0R8g4Y0xKv
 /nulisF+W/8KP1YcREpye8iFySZzSVpY6K2JmAe0oMQC91DL95Dyhh8TBtiY3j1Z
 +8fLyEgmHAPIxubb6YV+RoQ7CNVCC99iBFeEwdXB0mVZtpVaN05DyZXHqyixOiPu
 neOvekPLJ9L0Uy71dV7VYxtCrPV/ob4E/et+/adCazzf

From: Roberto Sassu <roberto.sassu@huawei.com>

Currently, evm_inode_init_security() processes a single LSM xattr from
the array passed by security_inode_init_security(), and calculates the
HMAC on it and other inode metadata.

Given that initxattrs() callbacks, called by
security_inode_init_security(), expect that this array is terminated when
the xattr name is set to NULL, reuse the same assumption to scan all xattrs
and to calculate the HMAC on all of them.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/evm/evm.h        |  2 ++
 security/integrity/evm/evm_crypto.c |  9 ++++++++-
 security/integrity/evm/evm_main.c   | 16 +++++++++++-----
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index f8b8c5004fc..f799d72a59f 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -46,6 +46,8 @@ struct evm_digest {
 	char digest[IMA_MAX_DIGEST_SIZE];
 } __packed;
 
+int evm_protected_xattr(const char *req_xattr_name);
+
 int evm_init_key(void);
 int evm_update_evmxattr(struct dentry *dentry,
 			const char *req_xattr_name,
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 033804f5a5f..5d8b5ecf594 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -389,6 +389,7 @@ int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
 		  char *hmac_val)
 {
 	struct shash_desc *desc;
+	const struct xattr *xattr;
 
 	desc = init_desc(EVM_XATTR_HMAC, HASH_ALGO_SHA1);
 	if (IS_ERR(desc)) {
@@ -396,7 +397,13 @@ int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
 		return PTR_ERR(desc);
 	}
 
-	crypto_shash_update(desc, lsm_xattr->value, lsm_xattr->value_len);
+	for (xattr = lsm_xattr; xattr->name != NULL; xattr++) {
+		if (!evm_protected_xattr(xattr->name))
+			continue;
+
+		crypto_shash_update(desc, xattr->value, xattr->value_len);
+	}
+
 	hmac_add_misc(desc, inode, EVM_XATTR_HMAC, hmac_val);
 	kfree(desc);
 	return 0;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 7d20ce83915..013eb220cc5 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -305,7 +305,7 @@ static int evm_protected_xattr_common(const char *req_xattr_name,
 	return found;
 }
 
-static int evm_protected_xattr(const char *req_xattr_name)
+int evm_protected_xattr(const char *req_xattr_name)
 {
 	return evm_protected_xattr_common(req_xattr_name, false);
 }
@@ -870,10 +870,10 @@ int evm_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	struct evm_xattr *xattr_data;
 	struct xattr *xattr, *evm_xattr;
+	bool evm_protected_xattrs = false;
 	int rc;
 
-	if (!(evm_initialized & EVM_INIT_HMAC) || !xattrs ||
-	    !evm_protected_xattr(xattrs->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) || !xattrs)
 		return -EOPNOTSUPP;
 
 	/*
@@ -881,8 +881,14 @@ int evm_inode_init_security(struct inode *inode, struct inode *dir,
 	 * contiguous, there is enough space for security.evm, and that there is
 	 * a terminator at the end of the array.
 	 */
-	for (xattr = xattrs; xattr->name != NULL; xattr++)
-		;
+	for (xattr = xattrs; xattr->name != NULL; xattr++) {
+		if (evm_protected_xattr(xattr->name))
+			evm_protected_xattrs = true;
+	}
+
+	/* EVM xattr not needed. */
+	if (!evm_protected_xattrs)
+		return -EOPNOTSUPP;
 
 	evm_xattr = xattr;
 
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
