Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D3EC6FD1F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3+FzQam2/LkENdzD/2kTIUdDEENT2RwDI29nO5cJPhE=;
 b=ZIMaV0XD86550ByiUu8l23daKBli1cchadCwEqrMYOsWO3yWJvaNWo6R57HYZ+OtzeK2ZAlsY/BQ
   x+rkzrJD60lB+2hMRkcYP899jqku3nj/ua6igGt3v8uvltk6sFi5pmlLENplvqAY+zWEkt3tMXS1
   HMwZTv0xlbzl8XOxN84tmZbcwxO3miXAtzw4gzDdgAtNQothTv6oBz+fg5JPVEBMTquBDo9LNh1L
   AE/dZgxwyt1/Y/EjI/AOezO84G+TCTUezTWIqLs5xlqohFC+5roO3gDfATkZ9kchBrkSwfh3hoDr
   y4Ej6L5ML5H0RM3aYyDH1rgKB97Kvt9PIvgfug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3+FzQam2/LkENdzD/2kTIUdDEENT2RwDI29nO5cJPhE=;
 b=S7yzw8H8BUYRBI23EAl5ZyNgIsdD8vZBRJ0fWvM/pLLCDkD6hXHdr6ANtUSTxp4XAcdHU+xp5N3p
   nkht3aVNDJ03LT5rf2xO9jPou1/wTG6fo4QfETDMHZiAXRXJj0NWbZ1P8VCHbVRjOTOWniJdYxaX
   ydyBPuZj9tq9SEU71eNsb1EINxzRXZqkEHwJG/kj7qu5u90IX1DOldCyh3ooPkamCnVZu9AvdhmL
   9JcgTPwe0SZyntIRXtD96THGUdH5+7MBo8y0PBizYOVd9Jza+A2GJSKfI1KLmcOfZH4/pNHCx3rm
   wCQ0yKkBfWpFFITFrRggeCR7GnWu7vRvafP+tw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI00ESO4G5DA20@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:19:18 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:17:16 +0100
Message-id: <20230314081720.4158676-3-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 clxscore=50 bulkscore=0 priorityscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140070
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v8 2/6] ocfs2: Switch to
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
X-CM-TRANSID: GxC2BwBnNl2zLRBkenSXAQ--.34127S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCw4rKFyxJrWkZFy8Gr17ZFb_yoWrWr15pa
 n8K3W5tr1fJFy8WrWrJr4rua1SgrWfGrsrJr93GryDZFs8Cr1ftryFyr1UCas8XrZ8JFyk
 tF4Ykrn3Cwn8Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
 A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
 Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
 Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
 Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
 vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
 jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
 x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
 w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
 0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1sa9DUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAQBF1jj4aJfgAAsW
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: lY8cX5MvT2IRQ-TxIaMOsP_zeu6QNQmF
X-Proofpoint-ORIG-GUID: lY8cX5MvT2IRQ-TxIaMOsP_zeu6QNQmF
Reporting-Meta:
 AAGax+zOIWwdglihKGrcKQZUghj6EP6eMArOLrjvkrZ7lM2jzu7UPj758YO/ODVH
 NgslivHQy8vumd9QlwyNDjOdODxdDTKQH9DagAQw87A0TQcszuvvmt45i6kzEBlr
 ZqXl/Gy6fF4R0j2YWZ97pzbLHoCNW4fro3Ygd+07gFENfF8HH13DltNQXY2y/xr/
 eKsraoHQwfhrEB5W0PtyOmAh12RmmfJYqtjo9WfEgnei7b9nsHsgvuOQL2JehvZD
 pwBtDq+dOkc+TphPMnG8yDDrU5RcGZYQIv7NEdI44Lhw+H2RhE5Ajl30YQEH0ZdN
 fDNZPiaudf1NuHf8/mvvqf/ZBhu6weoAXu9ChxFe0bxOmMux6WhjWye0+1aDBPpX
 SVLrhLDxaOHdgOzKEkfhV38P5+apL7iGza75Uzhl4qJbgS7IRenX7KCvxX4vozSp
 H0Ba7pWV+75rYSeUI+0KXuXtmxoCoGdoi2E1WLlyeVneoyrZYfsi3y3iSRRgpcJI
 V4igoyBX9MsGtOuqQQQ/93ueSyA8epfPGONv9ERFtDlvAw==

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

Finally, since security_inode_init_security(), unlike
security_old_inode_init_security(), returns zero instead of -EOPNOTSUPP if
no xattrs were provided by LSMs or if inodes are private, additionally
check in ocfs2_init_security_get() if the xattr name is set.

If not, act as if security_old_inode_init_security() returned -EOPNOTSUPP,
and set si->enable to zero to notify to the functions following
ocfs2_init_security_get() that no xattrs are available.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/namei.c |  2 ++
 fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9175dbc4720..17c52225b87 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -242,6 +242,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
 	int want_meta = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
+		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota_inode = 0;
@@ -1805,6 +1806,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
 	int want_clusters = 0;
 	int xattr_credits = 0;
 	struct ocfs2_security_xattr_info si = {
+		.name = NULL,
 		.enable = 1,
 	};
 	int did_quota = 0, did_quota_inode = 0;
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 389308efe85..469ec45baee 100644
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
