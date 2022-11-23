Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52441C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 09:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rQv+8Ffl1Mo9/O0un7UGziWDfEhY2Sr1OM8vDAY34bI=;
 b=PTwX9xv3GXbxV8eaBHmRJYDXI8Xk7Lo+4WTLjPcECCkIo39gDeXBFiV0lXTh7ISQnuOMg/k7BGzS
   L/INSwCfNslx3FABdZ/7r5LEYxxB/kl/t0D/ZXU6X8tRUJbVf+vhIySrybEmRqa8HlQllvTl/nVU
   X8cwq3ughTDWiHPyhbqdXfCPTq+I5wQZDRrDvVwuBQe8uzxOQ9BAV2RLWPjUn8FJP0O6Pdn7fPFa
   umMVOyuOS3x0dVMKbA0X4/d8w/BlB83J8si99q4i05ntlZUv95kyycQtgbhoh0PRrPVEeYHbupWm
   bRII9GieYtAiE5TGJzzWenKwfuO2N8ipB7Gr8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rQv+8Ffl1Mo9/O0un7UGziWDfEhY2Sr1OM8vDAY34bI=;
 b=pJsaS5RE4LzoebnDgSDBVHGrR98uVQ/3szevDSFdqFaLuzj66TgSO7AsGf17Vic+3z8c8Lefqk+U
   xWRoUwC6/TOyFEsIFjLMQe0XuOAZBR2gMlR9xjqtCOISYAqmY2/fnRpvjCOqEUNHLARmXfiOctOA
   URRSAOpko3qNDsFOL4mU5yYMByDo0sbKQ8ya/eQ+BuuRcHLL2Pai13bMouEdi//nNl13OfyZuQHv
   YMc0Ezok1JFi9LqW60V78+2wt9S7Zz1IDmdHEusN/km8PyNkXxj0AwnWdAeSoIQ7xpQhnwPAZC8n
   QOfo3A1n7cZWl5Rw84Q2W5qlMCGaeKKmh0eYpQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00FEROTJS710@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 09:53:43 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 10:52:01 +0100
Message-id: <20221123095202.599252-6-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 adultscore=0 priorityscore=0 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=826 clxscore=90 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230074
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 5/6] evm: Align evm_inode_init_security()
	definition with LSM infrastructure
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
X-CM-TRANSID: LxC2BwAH829J7X1jzDqKAA--.13162S7
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw1UGF15uF43Zr43CFW3Jrb_yoW7GrW3pF
 43Ka4UCr1rJFyUWry0yF48u3WSgFWrGr4UKrZ3G34jyFnrtr1xtryFyr15ury5X3y8GF1v
 qw42vr1rWwn0y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
 Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
 rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
 AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
 14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrV
 C2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE
 7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262
 kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
 6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GF
 v_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvE
 c7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
 AFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZF
 pf9x07jIPfQUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAFBF1jj4HGaQAAsc
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: _l2xNlFEem-rROgAqwveuqdOPfFsXX_d
X-Proofpoint-ORIG-GUID: _l2xNlFEem-rROgAqwveuqdOPfFsXX_d
Reporting-Meta:
 AAEZWra6e4EIkNDMNHfCrBfEcl6Z0jQVWI+MV52IzipOS5QNb9wOBjUjVAgNewOF
 BtVR9V7NA2fpmpFONTYQDk++VCi7utMgIV7RO2IpTe1xpHRmod9kb7lQ1dnT7icI
 xhvN7aNRmYIp0vDVCkymhxuSNUcksGa08MXyWkD6rYSr465B0SFUAk8VQ1uNBG1J
 qWRXWSx5e2IAbB2Qql6l4as3z1m2Wwe6I3HQlHSXohwPxif5Ualh/elBHGzZpQTj
 gAhznuDYXQxGzwFNvPy8V2Vl4Iy2Tyjs5eQwTVVoHslT6vXJXi+8nSTDHyTgI29X
 535GBrGfy9XEhceVp/aBvzVMwYAD/15KXnWmlm0BmIE4FmxAL4clBvwdKcz5WhWY
 kVVaohBQk5kpxLD8NZiAmPWrqCptA9e9MqQZdfYR/yHvcmbonDEHDjP9d1sFOzNQ
 UpHpJ7MIkgAalaFvno9fJckSduxeQA6ZesO6E01WeY4uNAc/SuOpYszsmSY4sgDr
 KehaodV+ynohzUkHVrL5NE3977u3dIzyayjTgNGRspnD

From: Roberto Sassu <roberto.sassu@huawei.com>

Change the evm_inode_init_security() definition to align with the LSM
infrastructure, in preparation for moving IMA and EVM to that
infrastructure. Keep the existing behavior of including in the HMAC
calculation only the xattr the first LSM provides.

Changing the evm_inode_init_security() definition requires passing only the
xattr array allocated by security_inode_init_security(), instead of the
first LSM xattr and the place where the EVM xattr should be filled. In lieu
of passing the EVM xattr, EVM must position itself after the last filled
xattr (by checking the xattr name), since only the beginning of the xattr
array is given.

Currently, the LSM infrastructure makes sure that there is space for the
EVM xattr in the xattr array. If EVM is moved to the LSM infrastructure,
it will use the xattr reservation mechanism to achieve the same, as the
other LSMs.

Finally, make evm_inode_init_security() return value compatible with the
inode_init_security hook conventions, i.e. return -EOPNOTSUPP if it is not
setting an xattr.

EVM is a bit tricky, because xattrs is both an input and an output. If it
was just output, EVM should have returned zero if xattrs is NULL. But,
since xattrs is also input, EVM is unable to do its calculations, so return
-EOPNOTSUPP and handle this error in security_inode_init_security().

Don't change the return value in the inline function
evm_inode_init_security() in include/linux/evm.h, as the function will be
removed if EVM is moved to the LSM infrastructure.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/evm.h               | 12 ++++++------
 security/integrity/evm/evm_main.c | 20 +++++++++++++-------
 security/security.c               |  5 ++---
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index aa63e0b3c0a2..3bb2ae9fe098 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -35,9 +35,9 @@ extern int evm_inode_removexattr(struct user_namespace *mnt_userns,
 				 struct dentry *dentry, const char *xattr_name);
 extern void evm_inode_post_removexattr(struct dentry *dentry,
 				       const char *xattr_name);
-extern int evm_inode_init_security(struct inode *inode,
-				   const struct xattr *xattr_array,
-				   struct xattr *evm);
+extern int evm_inode_init_security(struct inode *inode, struct inode *dir,
+				   const struct qstr *qstr,
+				   struct xattr *xattrs);
 extern bool evm_revalidate_status(const char *xattr_name);
 extern int evm_protected_xattr_if_enabled(const char *req_xattr_name);
 extern int evm_read_protected_xattrs(struct dentry *dentry, u8 *buffer,
@@ -108,9 +108,9 @@ static inline void evm_inode_post_removexattr(struct dentry *dentry,
 	return;
 }
 
-static inline int evm_inode_init_security(struct inode *inode,
-					  const struct xattr *xattr_array,
-					  struct xattr *evm)
+static inline int evm_inode_init_security(struct inode *inode, struct inode *dir,
+					  const struct qstr *qstr,
+					  struct xattr *xattrs)
 {
 	return 0;
 }
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 23d484e05e6f..0a312cafb7de 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -845,23 +845,29 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 /*
  * evm_inode_init_security - initializes security.evm HMAC value
  */
-int evm_inode_init_security(struct inode *inode,
-				 const struct xattr *lsm_xattr,
-				 struct xattr *evm_xattr)
+int evm_inode_init_security(struct inode *inode, struct inode *dir,
+			    const struct qstr *qstr,
+			    struct xattr *xattrs)
 {
 	struct evm_xattr *xattr_data;
+	struct xattr *xattr, *evm_xattr;
 	int rc;
 
-	if (!(evm_initialized & EVM_INIT_HMAC) ||
-	    !evm_protected_xattr(lsm_xattr->name))
-		return 0;
+	if (!(evm_initialized & EVM_INIT_HMAC) || !xattrs ||
+	    !evm_protected_xattr(xattrs->name))
+		return -EOPNOTSUPP;
+
+	for (xattr = xattrs; xattr->value != NULL; xattr++)
+		;
+
+	evm_xattr = xattr;
 
 	xattr_data = kzalloc(sizeof(*xattr_data), GFP_NOFS);
 	if (!xattr_data)
 		return -ENOMEM;
 
 	xattr_data->data.type = EVM_XATTR_HMAC;
-	rc = evm_init_hmac(inode, lsm_xattr, xattr_data->digest);
+	rc = evm_init_hmac(inode, xattrs, xattr_data->digest);
 	if (rc < 0)
 		goto out;
 
diff --git a/security/security.c b/security/security.c
index 26aaa5850867..d256bd223ef4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1184,9 +1184,8 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
 	if (!num_filled_xattrs)
 		goto out;
 
-	ret = evm_inode_init_security(inode, new_xattrs,
-				      new_xattrs + num_filled_xattrs);
-	if (ret)
+	ret = evm_inode_init_security(inode, dir, qstr, new_xattrs);
+	if (ret && ret != -EOPNOTSUPP)
 		goto out;
 	ret = initxattrs(inode, new_xattrs, fs_data);
 out:
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
