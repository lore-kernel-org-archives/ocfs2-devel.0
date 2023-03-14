Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 200CAC6FD1F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=89yJYzSGd288FmXNmuZW5B3u+CcA64sGvuKTaO6eOT8=;
 b=1eoXtljUw0Cem4dmZlvKnOejxhxmIocX3m6Vp1VYfuBz1U197l9qh2BDHV3qCd3FZz7Hc/xuHVfU
   ZJs3x/UVLhCgvFi1UsWePWl+DdDbW73gqZPjOILLUON0C/RW5WhAak8/1TJgYGo+eEDGYAm0ywr/
   wefwYG3J3mM3psK4Y9S1GjN1OlE/to83p6tumIG11NrCxmLmW1KvFn8TUP1y5PeGjF18BwhA9WlZ
   EU+zMaguLyQyggqr96qyIeWXU3AdazAAUMr+DpCGt7Hayb/cIscrljNFvHr6wUqxlDpWZSbp1Lro
   OI52ScCVc4ane+Amb2bftqt0cCF2nsK3BQV1lQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=89yJYzSGd288FmXNmuZW5B3u+CcA64sGvuKTaO6eOT8=;
 b=gpxB+EsAUQflvJkRBd1zEg4FTnF0clUKDxBv/0KH0znh1LATNFmUXH/piCmNk9W0AWpp/20Sy+I7
   sp2dV8WrH3orFIHV8Z5sNeA1RwXS4V6Lpd4wQqdi2dBOdWXDbaKgl5Zl+40ibCnmrZw3GnQ8mWLp
   Y5UG63EYuFu5W0hqIKoC/iPiA5GuwdqgutrJEQ4Sh207mmRXXC3QYrKD16Vl7L526P/5xOihbDMH
   hl+7ctdoJBlTd/lq4yS3CXbJYuR13b1JmJyezZpnpQ3xL9sryO+1OITjLmjdvIvZxtnae70nUPjd
   gVTn+VtYEaBYTNZoBL9jkdFZfPrOJzmMUwnFBQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI004ZJ4FYN060@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:19:10 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:17:17 +0100
Message-id: <20230314081720.4158676-4-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.154
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=51
 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxscore=0 priorityscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140070
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v8 3/6] security: Remove
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
X-CM-TRANSID: GxC2BwBnNl2zLRBkenSXAQ--.34127S5
X-Coremail-Antispam: 1UD129KBjvJXoWxGryDZrW7Xw18WryDZry7ZFb_yoW5GryrpF
 43t3WUGr1rJFyUWr1vyF17uF1SgFWrKrsrJrsakwnrJFnxZr1rtF1Fyr17CFyrJrW8Ww1I
 qw4a9r43Gr4DJrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
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
 0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1c4S7UUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAQBF1jj4aJfgABsX
X-CFilter-Loop: Reflected
X-ServerName: frasgout12.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 7lmv4nEhbDt_AALX9NSQ7-lQbTPw6R9l
X-Proofpoint-ORIG-GUID: 7lmv4nEhbDt_AALX9NSQ7-lQbTPw6R9l
Reporting-Meta:
 AAHP6rdkZDLuDR/qCxiDXam7DUmd5OayeRN06d8k9d2oTQMgeBMxLOXUCsoYw4OL
 j0ZspfLG1Ult2qdFG3E53pu5WB7dOyx57nHov6jW/QGGRxjPCPHkCVxIufWOv1TB
 BG3i/f4adal5pStqASSCT61FHtO4wY8j4JzAWKQSNGQqXc30EahUfqOEMyoGExwj
 SsTg1ixbuQLM4uVOOaGL35D2j87Ns68uB7iwccJ9dabNlRKxIv5IUgsEHJlJvW0Q
 6U05Oq0MlknWF0MU2wqkubJdKB4A8uSUxNAyQETqFqWEsNwhpzfRecndRxmH327t
 NkLSJZ9pWr6YEpiOPKn5xYHA4gDaalqjsyGObTZbXWSbNq+YbR3JfvyQlNfAP6sR
 g2bZX7cZQqRNrV4QQdxHZhl2k8mpGVu18tU8xJBU5nQZT+OKx5q0jWZFBiB0DXQa
 zDu0kqznRpbj2sjl0tc4ogeCBs53NCLN2hPy6EUKbqJHAl9oo7hEPxi2+X9wHq7x
 6m+bVH9Z6so0lT//T4/+PQEhZGxBU9bYsIU21RTaYxs1

From: Roberto Sassu <roberto.sassu@huawei.com>

As the remaining two users reiserfs and ocfs2 switched to
security_inode_init_security(), security_old_inode_init_security() can be
now removed.

Out-of-tree kernel modules should switch to security_inode_init_security()
too.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 include/linux/security.h | 12 ------------
 security/security.c      | 11 -----------
 2 files changed, 23 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 5984d0d550b..cd23221ce9e 100644
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
@@ -778,15 +775,6 @@ static inline int security_inode_init_security_anon(struct inode *inode,
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
index b808e1b8655..f4170efcddd 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1655,17 +1655,6 @@ int security_inode_init_security_anon(struct inode *inode,
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
 /**
  * security_path_mknod() - Check if creating a special file is allowed
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
