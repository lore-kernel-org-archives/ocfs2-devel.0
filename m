Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C0D2C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rx2ewcg3zlozYYDNS3p/8JMJrq0LWdIphjCAoY+BZNc=;
 b=f7aw2a4s2o75eAk+4eZipLnrujbdzo1ZAFjgh0bL6qk2dugKfk0TBBZzPHghItWNt+d4mnaHVjVn
   0OjHaBtgjRt8A38Ok3FyiC0ENAm9wxlxAO/b4bUDQcF36jH9KRhSDKJ2K83vEG67eNXroRkq5bFP
   yoAsijldxc7bo6cDxw7XqhJSROi8VHYBcTqR556gYrWfW0Iofg2NWtyJiNUKiyopL2mM5ebhNKEs
   hHjTlJrZS4ne3RgQeX3x2T07xqZku+D49yYjHTCRCggar+BQwRazuDgTe7y0byEyHB5eCEf7Vk7Q
   t5WvS/9wfjDGKRwNQz/kKb6AEP21/IOAt3A59w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rx2ewcg3zlozYYDNS3p/8JMJrq0LWdIphjCAoY+BZNc=;
 b=GEJ2ztMf/3wIzKz/AGeAl/OXS47K6IJY12rx/ichcPyeQOpkdrjwh5CK9U9KbBj9SzQ6HfgAGBlN
   g9Q8xwmhr0a2O5ci9yJV2awBAzSfCpAd2HifBIXF+yZ5swpHHBdJ+ru7Kjbr09Y0w1m9Nm9PdKwk
   RFUBF5drB3rK5Q03VRH00YHL5qV8hQfpwgecGE2R4eC32YL22Tw88QzzggJU6uSnYYEbeE34XZ8V
   WFD9SeMAk7mkBx40bqA+vrUq9OPz/OozO1EoIqyrKsKJHTEoC5LvzzU2AK0+t3g455urTs8W9hFY
   23ugEazGUw309c2zPczJZVpxzEcx6xjHkU1T4g==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS004JKOTSE760@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 09:53:52 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 10:52:02 +0100
Message-id: <20221123095202.599252-7-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 adultscore=0 priorityscore=0 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 clxscore=77 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230074
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 6/6] evm: Support multiple LSMs providing	an
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
X-CM-TRANSID: LxC2BwAH829J7X1jzDqKAA--.13162S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGryktFy8Jr45JrykAF15CFg_yoW5try5pa
 n8ta9rCrn5AFyUWr9IyF18ua4SgrWrGw4UKwsxCryjyFnrWrn2qryxtr15ur98Wr95Jrna
 yw40vw15Aw15t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
 Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
 rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
 AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
 14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrV
 C2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE
 7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
 kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
 6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
 v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvE
 c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
 AFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
 pf9x07jIPfQUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAFBF1jj4XF4gAAsT
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: S-rbyASZ1_6S4tJa1jq2FAUPF1SRBH0H
X-Proofpoint-ORIG-GUID: S-rbyASZ1_6S4tJa1jq2FAUPF1SRBH0H
Reporting-Meta:
 AAEZWra6e4EIkNDMNHfCrBfEcl6Z0jQVWI+MV52IzipOS5QNb9wOBjUjVAgNewOF
 BtVR9V7NA2fpmpFONTYgDk++VCi7utMgIV6wVZfbntgzvkYsTbE3f/Efn0x28x0+
 eYQor/LZ5HrUhLC6+xOvVs0kg96TIuL9DxIN3w4+dQyhv/DFigdqWjGWs2PCf96K
 1EFdrDWVlE0aXI70mU97+yj/FfJHNRrw7PTxUZB2ZD5WbO01wbR0CuFVHVwDimCE
 5bp4WJrouH5cR+GrvSxQJw6IeRdoqCFFca826q9PV4Pid3Ez0mJd1ivTYdtjNHZd
 m5vaL+SOCGU4/jRkOGPAhV4+mfinAu7HNIzZQS1Lc5wPU79YNR3NZqyxsUd7h9ty
 yRXOip+XDxlfMNB1uc3J8DFRnAsVVinTrS0Sv4lSSVtWGGrnmXVmIniXCW5x3i7X
 AcxW/r+mUbollL3giye5GbQGjILXv0hoYLWgq9fyyiATnqgcOykJT2Kr21WdgePZ
 AYLphi6Ku4V1/CC66fTg4WzmWjLw7qDetKxxEY4OpQs=

From: Roberto Sassu <roberto.sassu@huawei.com>

Currently, evm_inode_init_security() processes a single LSM xattr from
the array passed by security_inode_init_security(), and calculates the
HMAC on it and other inode metadata.

Given that initxattrs() callbacks, called by
security_inode_init_security(), expect that this array is terminated when
the xattr name is set to NULL, reuse the same assumption to scan all xattrs
and to calculate the HMAC on all of them.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/evm/evm.h        |  2 ++
 security/integrity/evm/evm_crypto.c |  9 ++++++++-
 security/integrity/evm/evm_main.c   | 16 +++++++++++-----
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index f8b8c5004fc7..f799d72a59fa 100644
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
index 708de9656bbd..68f99faac316 100644
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
index 0a312cafb7de..1cf6871a0019 100644
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
@@ -851,14 +851,20 @@ int evm_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	struct evm_xattr *xattr_data;
 	struct xattr *xattr, *evm_xattr;
+	bool evm_protected_xattrs = false;
 	int rc;
 
-	if (!(evm_initialized & EVM_INIT_HMAC) || !xattrs ||
-	    !evm_protected_xattr(xattrs->name))
+	if (!(evm_initialized & EVM_INIT_HMAC) || !xattrs)
 		return -EOPNOTSUPP;
 
-	for (xattr = xattrs; xattr->value != NULL; xattr++)
-		;
+	for (xattr = xattrs; xattr->value != NULL; xattr++) {
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
