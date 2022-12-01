Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 165CDC43217
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Dec 2022 10:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=f1sWk3oKMfxN3+v7/Oy21aA8oRNio2aigzXOnYnEWmw=;
 b=qQk6D05q86+ZCsR96lDOnDyz5+xewfMAcF0mUQgNiDXnOScdkdzkqLQA5G4bkCdjlhLNj1v/3Upj
   mR1LaXwDAU6V+FWFRqt2fesq0NWWL287JInHEgFDG8fE7wFbZ3rb/XSe/3m6NYXNc7nb9YcHNtZt
   92U2JPHJ9oVYXobVXD/RB+yGmQ0SnRXAzBLGs2iupD7aBfrvYyFw3lPNzHJyRFxSsZhWQXZsY25o
   ytSsqFZnNRBE5SNx4zOM09igFQZ3ZVc/rRzZ+KuEVRF9UeYpynBptzmxyOUf1r3A4fpa1vNX5MOT
   UnjkNCYEHZ4SvERh82M/vP0a9N10r3DIctLqZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=f1sWk3oKMfxN3+v7/Oy21aA8oRNio2aigzXOnYnEWmw=;
 b=o3oRi0olT7a0MviqxA9t+g788wVQKLdHo4UvmP1D6vvQG025MGmii80mFjEQz67y0uISeJAuBpEk
   wsFFh5UxOt/UVOmnlTnRLUIWqJIVKTMoJiE/GUQYA/21cC9cjuIiQdXj4/m7gPwMoOA28EUvfYsd
   bPhUv6H3dHrQbVmVrg06HYLrPnN6VVxWZVlxeyNpcC7dBSpb+im3Sxodcnv0Ekq150/Vpmte+lyp
   beeup3sqbEPuYEFJdnwccKPZcybTfKlHIGDLo0dJuexBFtrkunwuVXsG28tjyCak/YIFNGJNRVvk
   Vwwe9LWqwL/jwhC5w5XOC6Z0IrLkpwTCqtcOrw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM7002CJKFEGA40@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Dec 2022 10:42:50 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Thu,  1 Dec 2022 11:41:21 +0100
Message-id: <20221201104125.919483-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10547
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 suspectscore=0 impostorscore=0 spamscore=0 clxscore=31 priorityscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010076
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v7 2/6] ocfs2: Switch to
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
X-CM-TRANSID: LxC2BwCHcm_phIhjrxuvAA--.49496S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtw4kKF1UJw1rCrW5Aw1fZwb_yoW7Xr1Upa
 1ftFnxtr4rJFyUWryftr45ua1S9rWrGrZrGrs3G34DZFn8Cr1ftry0yr15ua45XrWDJFyk
 tr4Fkrsxuan8J37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
 A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
 Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
 Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
 6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI7V
 AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
 r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
 IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF
 04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
 CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUFa9-UUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgANBF1jj4IjiwAAsQ
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 0FlshW-U2s-ySQe-e7LS_OzdHHPNvd_M
X-Proofpoint-ORIG-GUID: 0FlshW-U2s-ySQe-e7LS_OzdHHPNvd_M
Reporting-Meta:
 AAGeVhv22GRvsUY2L7A0ICa+MpHXpC9jeq+0E2oZYhm4ouhosrtYpuOlL73ditRC
 xj4iuj2ZmY9dpEHEGl+9ykLiNdtNcLAiMurfk4WzJH6YOscPyNP3hNEq3eDpKZv4
 ZQfGU40LzT0BQZ4f2B+cshZD25IPgdQqEbmrtt+nf78i/EjXLU6bhP5Of6UIpFA8
 52IAIawrqz4sq3JU8synIkfCRz644EUl+0IlcO+W8A15Q2ZSorAVXPxmk+katP5V
 sAbOfnBUrOvGGfhv8TrXeGdzveTBiBGNkqNfGtw1RTUSyZ8J0FDdvyA1tsD8T40t
 Bk/MHGtHLrU0/L2q+wUrJUAimdKwy3tyh5k594F2roT5aFJW/7dKWWFdlQiGH9Gx
 rnnWyI+ODtAAEKMr1k6wRYQTFG5ULbtZAr6zkxVvrVtygSlWG9xjZSS8luU/yw8o
 4lC/JegN9/v82eNbGepN/ctHs6EQOUtwj6vlEXwImWdcjRC+wel0sxQWg8vCH+/D
 Z2AHY9oKPn5iGU05wHObXJeX3Fzgj/nf3mfjSigDeluY

From: Roberto Sassu <roberto.sassu@huawei.com>

In preparation for removing security_old_inode_init_security(), switch to
security_inode_init_security().

Extend the existing ocfs2_initxattrs() to take the
ocfs2_security_xattr_info structure from fs_info, and populate the
name/value/len triple with the first xattr provided by LSMs.

As fs_info was not used before, ocfs2_initxattrs() can now handle the case
of replicating the behavior of security_old_inode_init_security(), i.e.
just obtaining the xattr, in addition to setting all xattrs provided by
LSMs.

Supporting multiple xattrs is not currently supported where
security_old_inode_init_security() was called (mknod, symlink), as it
requires non-trivial changes that can be done at a later time. Like for
reiserfs, even if EVM is invoked, it will not provide an xattr (if it is
not the first to set it, its xattr will be discarded; if it is the first,
it does not have xattrs to calculate the HMAC on).

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
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
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
