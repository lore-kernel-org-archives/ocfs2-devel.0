Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9243C4321E
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Dec 2022 10:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9BXA0C/aUQ9V+1D27gSfjGTAmuedVsldT0idfugarCM=;
 b=0EYb70o5aewu6nsK2YtdcQOX26Hj5Cgq4jwskkdgS/ALz9AXyx9tULyDH4asUPioLh/2VBoiAHqN
   K5TM4WHF7trmdQybGvxsweQBiAV3A0H80JZoNQYpbc/UoOA6nZLzNYvepymgCmkOaxgF0fKPMrVB
   GGYg3wvKNMs0RZWhiRulGaYt78xG94+Pe2pZ2Sz4V1iJzS8RH7DVpSCpKY1VSeYQvFxcrizk92Cz
   51GS/3crGgDiezW2ZJOHcwr2Tg/6A4xK5e+6B+lVYbWBUkX0bGcRZQpC7zC0rpokio6KxO8uvlcX
   IWh1SCqXkPo3uKXEZKAcHC3ds6V9Rain/XPlfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9BXA0C/aUQ9V+1D27gSfjGTAmuedVsldT0idfugarCM=;
 b=AOkrCy/zq6PzTXLV07jxPopqcsIxOp/+hxcQ18yNFu/WTvzxVpDq85VEFpieP0Eur6QZOcnzYSu+
   DWfGts3bbNvp8jibV9QFp4z/5ke7lv13xaMjMwnEFOleh5hrWBV6Y02GKYhcSb7jEqE5uMLIUufD
   K+9Bpce2IbwkkElOVFWcAI2JdI6WP2OCrhoGaB3XA62ApJyKtB7rEqwqwVB0CkwdthHHS0kxOsSh
   BA3A2PpE6SId+qYzRSF5bXf7eKXICiRJkdvpM0YUNPTjcK6OAeji0BLvbETOnZXfK5CprGu5VWtM
   2a/jYDjlunV8jH7XP4Va/YOFhCA1i0M8pbrFEg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM700I05KFN24A0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Dec 2022 10:42:59 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Thu,  1 Dec 2022 11:41:22 +0100
Message-id: <20221201104125.919483-4-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10547
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 mlxscore=0
 malwarescore=0 priorityscore=0 clxscore=172 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010076
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v7 3/6] security: Remove
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
X-CM-TRANSID: LxC2BwCHcm_phIhjrxuvAA--.49496S5
X-Coremail-Antispam: 1UD129KBjvJXoWxGrWUJw1UXryDJr1kuF48JFb_yoW5Gr4rpF
 43t3WUGr1rJFyjgF10yF47u3WfKFWrKrZrJrZak3sxAFn3Zr1rtF1Fyr17CFyrJrW8Ww1I
 qw4a9r43Gr4DtrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
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
 CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUFYFCUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgANBF1jj4IjiwABsR
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: YqTTnQJpfir1Qe3izwaDivRWS8qFRMCy
X-Proofpoint-ORIG-GUID: YqTTnQJpfir1Qe3izwaDivRWS8qFRMCy
Reporting-Meta:
 AAEFKluOwBba55mbdipVjHJb+ZwKq2xUEpmBiEPa6wLHZqaZV1nIBBoxIjL0b8JS
 ItAV0Sx40+Oo+neDPaHHhOmlwc0TpItXioOnOo2aFctC2lzDy8tY5Wwwmvb9EkLz
 oC0YJQCTMo38EqR3WhC8dj0kVNHSDZpAu29dd4gGHcx76L8iJUTKCHcLi8yJnhq0
 YEKU713QOfQyvofuSkGeL+5aayvsUGoueK2FfEVXbfbPhSmom8j6pXeSZtjm99WQ
 PuYjLI6xHzaKPc4aGSTXcABQCx20I7TzRPPlquEnSOA7ozf5vOEANtWaxRvmkYfx
 OIOZeSdPl/u4lbn52LnWD4Go7Unpg5+f/i/wzv7zDreY34GjAQ9FpiTDAWjAXLss
 FPup7RfjwsEfzu/4z0Pg3dmd1czIo+hol+4zzjbezTqzsbHilSnedEmQ/V8KK5gK
 PcPi65LM8r8E0dxseyl3uqHNWJwjya5zgFSZUhJF9mCMUNMPuZ3dZ0Rvgvh6/uOQ
 sSQjj3CcFO+qnTLI6r8NCQuouOu0XY20+HzCoVqaGauuPA==

From: Roberto Sassu <roberto.sassu@huawei.com>

As the remaining two users reiserfs and ocfs2 switched to
security_inode_init_security(), security_old_inode_init_security() can be
now removed.

Out-of-tree kernel modules should switch to security_inode_init_security()
too.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/security.h | 12 ------------
 security/security.c      | 11 -----------
 2 files changed, 23 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ca1b7109c0db..c682fc96ed61 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -336,9 +336,6 @@ int security_inode_init_security(struct inode *inode, struct inode *dir,
 int security_inode_init_security_anon(struct inode *inode,
 				      const struct qstr *name,
 				      const struct inode *context_inode);
-int security_old_inode_init_security(struct inode *inode, struct inode *dir,
-				     const struct qstr *qstr, const char **name,
-				     void **value, size_t *len);
 int security_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
@@ -771,15 +768,6 @@ static inline int security_inode_init_security_anon(struct inode *inode,
 	return 0;
 }
 
-static inline int security_old_inode_init_security(struct inode *inode,
-						   struct inode *dir,
-						   const struct qstr *qstr,
-						   const char **name,
-						   void **value, size_t *len)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int security_inode_create(struct inode *dir,
 					 struct dentry *dentry,
 					 umode_t mode)
diff --git a/security/security.c b/security/security.c
index 79d82cb6e469..e2857446fd32 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1132,17 +1132,6 @@ int security_inode_init_security_anon(struct inode *inode,
 			     context_inode);
 }
 
-int security_old_inode_init_security(struct inode *inode, struct inode *dir,
-				     const struct qstr *qstr, const char **name,
-				     void **value, size_t *len)
-{
-	if (unlikely(IS_PRIVATE(inode)))
-		return -EOPNOTSUPP;
-	return call_int_hook(inode_init_security, -EOPNOTSUPP, inode, dir,
-			     qstr, name, value, len);
-}
-EXPORT_SYMBOL(security_old_inode_init_security);
-
 #ifdef CONFIG_SECURITY_PATH
 int security_path_mknod(const struct path *dir, struct dentry *dentry, umode_t mode,
 			unsigned int dev)
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
