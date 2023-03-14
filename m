Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C767BC6FD1C
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i4sVm8cc7rtdbAw0gyOdgNR4ekpJwy0oBzbbmkAXshw=;
 b=2Nu8/rxIKeWK+KhaiLou3du87yoh2HRKT1YP7yMJuvHSCZtv//o1guMqZ3j9lv4mHwYqau4zuiZV
   hFMVPNUlGKQeVX58yqnoGYoDIGXzAJ+Mub1WaxLcI6cjuazZQ46bM4gi5Y2C+IaBunzevNGhG2Cf
   6/FXqNi9yGkszmFwmGAR/k/UKfu9wi3KFBH54zHqiMvwBJwVWq8ndQAAmLLORZ/JmsKitHKU3sHa
   LNUtEcn/jadIM6FEP9Lr33+syFvQLgClWpavKtBGW1cAv5UzfizidGuD2MhZHI6pWyjjJGoLJytG
   QIU2UUnebTcvIHQkCJLNYGgzMjZxc5mq4o6Axg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i4sVm8cc7rtdbAw0gyOdgNR4ekpJwy0oBzbbmkAXshw=;
 b=C4lUJdrXlP/IGDdiZ6Q4pn4FdujQIL24aaE165mk1SjXX+Uiy9p14HeSrRjjGykwtyIqCu5O97Fh
   OZqRzTwaODU+KtV9zzpKljs8mGiE3EuAZi42BCnLdMWJkp6N8KrZaeaS77UeSjwRRHMeUe4+vJda
   30n8CM6QRD65RL7AN5+6B7mO8BmKXEy9PrApuRP9HEnkaex+GM9+09PIruF34N9kD+5asJSQK5sw
   HJIYk03+r6gJfu9Ab5w7DarnqvCV40zuETBOB8SS/T/DUlzh2X06cTYIR965wGv0FbNMe7Ja+uFp
   L9Bi0qBmwxU1v6eEAHjWz4n2knKgwNJsBmtSBw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI00JTU4GM11B0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:19:34 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:17:19 +0100
Message-id: <20230314081720.4158676-6-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=62 bulkscore=0 priorityscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140070
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v8 5/6] evm: Align evm_inode_init_security()
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
X-CM-TRANSID: GxC2BwBnNl2zLRBkenSXAQ--.34127S7
X-Coremail-Antispam: 1UD129KBjvJXoWxXF43tw1DXry7Kry5AF45Awb_yoWrKryUpa
 y3ta4UCr1rJFyUWryFyF4xu3WSgFWrGr4Ut393GryjyF1Dtr1xtrySyr15Cry5X3y8GFnY
 qw42vr1rWwn8t3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4qHYwABsL
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 54Hqol6pPdH6H2ZJ7UBNUFpytI8NrPFy
X-Proofpoint-ORIG-GUID: 54Hqol6pPdH6H2ZJ7UBNUFpytI8NrPFy
Reporting-Meta:
 AAHbbExDFXmV4RwxxS1fO4jigmWgC8yRZE7VrhPaFuQcqzjdVJ5E0r+NhGoTE0g/
 4f6KYQ6J5OTAlQakj7xxbXCgxrfdVmUN3RuhJpgS7YG88p26T55ocnEVOpXDTMw3
 HLhMJBC77mottjUYQJ1U/Rls+scILmSrBPBUsW+2XrIbi/PFCrWuS4x5zq+e5VwM
 GLVz3LDxrcgCnfPyDOIImyEnufK6vBoYSYEKWftxyFEnyjDhG27cAqpdimrPmVw9
 7g0gWnH4jxSeln5kCxdtIulUrprmJ6TBCljFuH3+kkGlBMJOCA3wVwty7MWmfgz9
 R8J9IJtpW9nUp75pgqOEs/Xmzw0GqpACH5PCQk1e9yx/E4SnlW+8zEqAAPSFhIq2
 /zBV+2RR6p910YyqRAzfsPYvGHqZE6eNLE4r1WfsXY4vs5FjNrCw7VY3rU/fZtBn
 HTBn/o9/cvkbbkaEipZ16tSuzdsNfeCwKdPDbQI2xCX0IBWnRdnOZYn2ycWJNl7W
 YF4JsB5gD6n7O1qv3dM+gmWG8jc3bnYgqYqLOK9hZx+fOA==

From: Roberto Sassu <roberto.sassu@huawei.com>

Change the evm_inode_init_security() definition to align with the LSM
infrastructure. Keep the existing behavior of including in the HMAC
calculation only the first xattr provided by LSMs.

Changing the evm_inode_init_security() definition requires passing only the
xattr array allocated by security_inode_init_security(), instead of the
first LSM xattr and the place where the EVM xattr should be filled. In lieu
of passing the EVM xattr, EVM must position itself after the last filled
xattr (by checking the xattr name), since only the beginning of the xattr
array is given.

Finally, make evm_inode_init_security() return value compatible with the
inode_init_security hook conventions, i.e. return -EOPNOTSUPP if it is not
setting an xattr.

EVM is a bit tricky, because xattrs is both an input and an output. If it
was just output, EVM should have returned zero if xattrs is NULL. But,
since xattrs is also input, EVM is unable to do its calculations, so return
-EOPNOTSUPP and handle this error in security_inode_init_security().

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 include/linux/evm.h               | 12 ++++++------
 security/integrity/evm/evm_main.c | 25 ++++++++++++++++++-------
 security/security.c               |  5 ++---
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 7dc1ee74169..cc64cea354e 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -56,9 +56,9 @@ static inline void evm_inode_post_set_acl(struct dentry *dentry,
 {
 	return evm_inode_post_setxattr(dentry, acl_name, NULL, 0);
 }
-extern int evm_inode_init_security(struct inode *inode,
-				   const struct xattr *xattr_array,
-				   struct xattr *evm);
+extern int evm_inode_init_security(struct inode *inode, struct inode *dir,
+				   const struct qstr *qstr,
+				   struct xattr *xattrs);
 extern bool evm_revalidate_status(const char *xattr_name);
 extern int evm_protected_xattr_if_enabled(const char *req_xattr_name);
 extern int evm_read_protected_xattrs(struct dentry *dentry, u8 *buffer,
@@ -157,9 +157,9 @@ static inline void evm_inode_post_set_acl(struct dentry *dentry,
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
index cf24c525558..7d20ce83915 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -864,23 +864,34 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
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
+	/*
+	 * security_inode_init_security() makes sure that the xattrs array is
+	 * contiguous, there is enough space for security.evm, and that there is
+	 * a terminator at the end of the array.
+	 */
+	for (xattr = xattrs; xattr->name != NULL; xattr++)
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
index f1f5f62f7fa..d0e20b26b6c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1705,9 +1705,8 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
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
