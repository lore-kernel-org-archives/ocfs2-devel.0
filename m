Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3591C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=am11MZKP4ZKm9VIkhJVJZbxPtJncNudMFbZSo2wxdJU=;
 b=RBvO/485Gk5bV7jEiFGXjWnTFKjL1cKiXJTwEsNHTbdVwIw5C4cvlYI/h0LGvJBLvw6amCDHNi9D
   QhYvvrr+kTfZm9b3opR9ktldWU45kk4gV+fbfx0dG0wpWZ293vXdUJ5bKl3tH/tbJhntkCZ0ozFG
   RL+TWIbuzxz4aTcTCO8N2YvxZZaOuHOat9YK9HbwLQv2xVJJMz2x3Gz4KNtz9WGO5hTfBKbO8U0T
   pDsOPjHj+Ul928SAuv9RM8UOzBz5s97MyhhNkphHNToCol1/qBg5Pwj3jPrr5WMUppRRFFg59WUj
   NNpqnsMNUUCkykYIzHavXq6rceiBYHp8UZUtFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=am11MZKP4ZKm9VIkhJVJZbxPtJncNudMFbZSo2wxdJU=;
 b=Nt2NVULD0+gVsvIQgozrmv6AjhkdvpVmHrG3Cn4rmcyLaeK25llg+J2CKw+eJ5H9qAGjTyFZpwxg
   sFw17ARIFya19UIhEISb8lEWhMYJlZs0iBL6c9ieWcdkch4lloIa6XyuyqvKhuHugbsjycyMK7BH
   AfPVibYFi6T3mXDGuEvqhwFmFIwWvzPSFrDGXMoSovyD3w6T11o5kdFWqZOu7wMM3yMGc2LZB2tl
   pNmqcyOXPAAASqJ1OOprTr2i2PSu1Mas0f78qCnGDZAqj+IBP6k7UlgMwuAi59huld7wukhNNOc7
   S8I5PhRppamsdXRJ4p4GDeYuefA+OblAJiRwWA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS005PFOSSSUB0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 09:53:16 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 10:51:58 +0100
Message-id: <20221123095202.599252-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=0 mlxlogscore=999 adultscore=0 clxscore=62 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230074
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 2/6] ocfs2: Switch to
	security_inode_init_security()
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
X-CM-TRANSID: LxC2BwAH829J7X1jzDqKAA--.13162S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4rKFyxCF1xJw4fAr4xZwb_yoWrKryrpa
 1rtFnxtr4fJFy8Wryftr4a9a1S9rWrGrZrGrs3G34DZFn8Cr1ftry0yr1Y9Fy5XrWDJFyk
 tr4Fkrsxuws8JwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
 A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
 6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
 WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
 bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x
 0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
 7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
 C0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY
 6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
 CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UC9aPUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAFBF1jj4HGZgAAsT
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: -9-FLPBejDXF0zygOp6beBvn6InYJTqb
X-Proofpoint-ORIG-GUID: -9-FLPBejDXF0zygOp6beBvn6InYJTqb
Reporting-Meta:
 AAGAiHaVcOwLwwuhy18cRIRN/qbyWAwrLGMdgmQr2NWC8C8DhMkMgtXbx6RPshgj
 b7sw/Lbe/PvH9TP4OduqrL4TEDPNIR0RImiEZqGvn283g47VAjfMJgGeajfcmYBg
 TOleTwvw/4g8WUB+dsZQ40E8wl8DzxzriWS38jkEArnWm3do6LUEtPhbGFo4NfkP
 xbqhRbxROyohKCWgbDvNimC9KKdn/g2zaFK7Gpqcr5jdEI12AFUaJ/xIybk/eSJW
 QGXnod94IzBeBi6qMO7WzczTlieuVnznY4+Li6yRUaFuwIfQILvDl4q5hylsJ24X
 UdgVoOTr0lrzKDa3O0+cFd1AeT1XTMBcSjgaCuYIyIRaKx+OUrldIhbwbZ1JmUol
 byuxL4slE3/+gbvD1gzkQHET+l3QrleX+imPArvSo2GJclaWurXiS/1U8anbTNbK
 swK5JdRbNIM7ShEUZCFIZzhkb/CpPOd6EnsmggFmPl0pUHTrLtUl+y6K8dSIRtdU
 DlagTNlDQQU4XsGBir4IpRkBUaJQC/2LzorDXlVyMHXp

From: Roberto Sassu <roberto.sassu@huawei.com>

In preparation for removing security_old_inode_init_security(), switch to
security_inode_init_security().

Extend the existing ocfs2_initxattrs() to take the
ocfs2_security_xattr_info structure from fs_info, and populate the
name/value/len triple with the first xattr provided by LSMs. Supporting
multiple xattrs is not currently supported, as it requires non-trivial
changes that can be done at a later time.

As fs_info was not used before, ocfs2_initxattrs() can now handle the case
of replicating the behavior of security_old_inode_init_security(), i.e.
just obtaining the xattr, in addition to setting all xattrs provided by
LSMs.

Finally, modify the handling of the return value from
ocfs2_init_security_get(). As security_inode_init_security() does not
return -EOPNOTSUPP, remove this case and directly handle the error if the
return value is not zero.

However, the previous case of receiving -EOPNOTSUPP should be still
taken into account, as security_inode_init_security() could return zero
without setting xattrs and ocfs2 would consider it as if the xattr was set.

Instead, if security_inode_init_security() returned zero, look at the xattr
if it was set, and behave accordingly, i.e. set si->enable to zero to
notify to the functions following ocfs2_init_security_get() that the xattr
is not available (same as if security_old_inode_init_security() returned
-EOPNOTSUPP).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/ocfs2/namei.c | 18 ++++++------------
 fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 05f32989bad6..55fba81cd2d1 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -242,6 +242,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 	int want_meta = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
+		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota_inode = 0;
@@ -315,12 +316,8 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 	/* get security xattr */
 	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
 	if (status) {
-		if (status == -EOPNOTSUPP)
-			si.enable = 0;
-		else {
-			mlog_errno(status);
-			goto leave;
-		}
+		mlog_errno(status);
+		goto leave;
 	}
 
 	/* calculate meta data/clusters for setting security and acl xattr */
@@ -1805,6 +1802,7 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 	int want_clusters = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
+		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota = 0, did_quota_inode = 0;
@@ -1875,12 +1873,8 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 	/* get security xattr */
 	status = ocfs2_init_security_get(inode, dir, &dentry->d_name, &si);
 	if (status) {
-		if (status == -EOPNOTSUPP)
-			si.enable = 0;
-		else {
-			mlog_errno(status);
-			goto bail;
-		}
+		mlog_errno(status);
+		goto bail;
 	}
 
 	/* calculate meta data/clusters for setting security xattr */
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 95d0611c5fc7..55699c573541 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7259,9 +7259,21 @@ static int ocfs2_xattr_security_set(const struct xattr_handler *handler,
 static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		     void *fs_info)
 {
+	struct ocfs2_security_xattr_info *si = fs_info;
 	const struct xattr *xattr;
 	int err = 0;
 
+	if (si) {
+		si->value = kmemdup(xattr_array->value, xattr_array->value_len,
+				    GFP_KERNEL);
+		if (!si->value)
+			return -ENOMEM;
+
+		si->name = xattr_array->name;
+		si->value_len = xattr_array->value_len;
+		return 0;
+	}
+
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
 				      xattr->name, xattr->value,
@@ -7277,13 +7289,23 @@ int ocfs2_init_security_get(struct inode *inode,
 			    const struct qstr *qstr,
 			    struct ocfs2_security_xattr_info *si)
 {
+	int ret;
+
 	/* check whether ocfs2 support feature xattr */
 	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
 		return -EOPNOTSUPP;
-	if (si)
-		return security_old_inode_init_security(inode, dir, qstr,
-							&si->name, &si->value,
-							&si->value_len);
+	if (si) {
+		ret = security_inode_init_security(inode, dir, qstr,
+						   &ocfs2_initxattrs, si);
+		/*
+		 * security_inode_init_security() does not return -EOPNOTSUPP,
+		 * we have to check the xattr ourselves.
+		 */
+		if (!ret && !si->name)
+			si->enable = 0;
+
+		return ret;
+	}
 
 	return security_inode_init_security(inode, dir, qstr,
 					    &ocfs2_initxattrs, NULL);
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
