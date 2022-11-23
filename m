Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C628C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 09:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8aFL98yOtofbyG5ZvUP+s7YlLoSEeiVNzfWRShfxkPM=;
 b=s8/5M2+Xh8GfCMF0i+hn9g4D6NQmSa4l9G0W6f0xQfkFF92VBAe5tE1ROnybqvY0FLLVbp5PibOJ
   3nWEZtSrscmpbZ8EPl0rbNwz0Dz+wL9HX4YkEamA0pF76B4NARt7COYUvHl0t8rOyu567cuieTwo
   jXxnG4nU3ApWiCJzJB1PLQIBuGjCIcWpAaTl0lxiR0EwTlpTOPpVp5YgvXrravhz4AMg2vsN5dMZ
   pXcUP6j/bRMdaYQxrx7CJsQOpgISbhPo6NXjJ/2816aBAQ/jid1Kgq5xLikmfyPE65AX1mD31GUj
   dIbzQfjhF71fchQQEUvKiNTw7doK6TlpJybpNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8aFL98yOtofbyG5ZvUP+s7YlLoSEeiVNzfWRShfxkPM=;
 b=G7d/oZp1af4tlrNO2cNL0sminea961GERjV4kMitQfJLKo0mjNnxeOQqvDd2tYEFwb52TflEc7py
   7MunGuUCf6p1qHXj59iAMbLpRDb7aMzw5MsnubBSJUn8uF2DrHkb38Ys/Gq90feEYxj4y42vB/r/
   OqUypc/yUuPIEKF6k9GPTdbpB/7GxCg9uRouo6OyjvAtSjyFxivYb/IYY0yj3PxkH+Itw3DYAzDl
   HHXUEfSIFKbdRtewaDVXxGiR8LHc6scm/g8L82o003K3eFGvEY5p1ATDttgNSFz9LHqzQ7pkzCBy
   82iBdOKWDzPgqlVyyPa1xTn9eqARDJgQ0wH1UQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00FDJOT0S710@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 09:53:24 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 10:51:59 +0100
Message-id: <20221123095202.599252-4-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 priorityscore=0 clxscore=6
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230074
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 3/6] security: Remove
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
X-CM-TRANSID: LxC2BwAH829J7X1jzDqKAA--.13162S5
X-Coremail-Antispam: 1UD129KBjvJXoW7urWftw1rZw4rtr4rJrW5KFg_yoW5JFyrpF
 47t3WUGr1rJFyjgF10yF47u3WfKFWrGrZrJrs3C3sxJFn3Ar18tF1Fyr17CFyrJrW8Ww1I
 qw4a9r43Gr4DtrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
 A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
 6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
 WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
 bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
 AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
 F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
 ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
 0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x
 07jxCztUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAFBF1jj4HGZgABsS
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: HKdV-RLDtqWbghNwdC4eA6PFp-iyaH4L
X-Proofpoint-ORIG-GUID: HKdV-RLDtqWbghNwdC4eA6PFp-iyaH4L
Reporting-Meta:
 AAHbEXGb6TB0v/MjlQa113Nsk/wQ+DE+DrrcDMfTYd/0PsSVfJcxmJzd6RelZZWU
 O5WnELROQv9jrnWIMScrclZrTyXgE33EcHe4dT4XZ3n9lJt1FbTSHmlbk6HojqJs
 bN0WDNADZnKCqQPqPf97BXQY+RH0noQT/SbPRNqwVKEASjAhFeuoMnjSUoA3kU6q
 FcQ4G7fzrYjE0IhFXMPB5u72aPUDltmISF4sSosRKeOJzIB3zuOtHL8QESSEv8zK
 wlzBohOS0ck8hyrzO3sEY12LSuZuphpVJman5TeRDc3sx/GAxpQRP6/AqM108jTd
 KjMPClnOTHkGa3TF+bCs08mD7USTU4LbzGMO1W0Ed8zf0b+dxkN+y06HCnXIFII5
 +s4vgZlBY1vWYUxh9fJmC4OfRe2jk3v2wpfNqaGHHtxIZVD6ZUOhnHYoG07wjXvE
 skTzAuuCH2IcjXyolYquGtBFqJxvSLZFSnpCPntQur4B8ptVoYgORTK2NOHy/wa8
 OBfOotcV44a7f4KZ1EagRZsqT9yBMqlQ2up8RyRvrrwx

From: Roberto Sassu <roberto.sassu@huawei.com>

As the remaining two users reiserfs and ocfs2 switched to
security_inode_init_security(), security_old_inode_init_security() can be
now removed.

Out-of-tree kernel modules should switch to security_inode_init_security()
too.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
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
