Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874C7C6FD1F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Mar 2023 08:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5c4P1WDTTAgylsd7CpFi7oPLgc3rlTHvmvqfZGbB3Ws=;
 b=OtNWhyjzoybX2mcaiAmERh/phdZN7TvFux8kX6rOky6JLT9rN937QUM8kpzEG4i9txGsK4C9sZAD
   skFUqs3qXDe2FJFXpstCsrBY4OMEpG66xl7CBDTtdXxWSeuGXeYUkfvvYm9+4RRczf3yBKE6Wmfk
   +t1dV/KZvea8Fr8LMAPZ8ft57YPOtDZc3vUNeXfjpGWIr+zghr9ZD0y4IV1Ar/W06G2PtE/lkv2i
   wsUkFyE27Tz1QFQTNJTYpu4sim+QHz7ddww54LciXsFlu1WvQMckW6EzpEuvZZIvZqvDvrqbt6eP
   uqmyglSvx1rIZmzjyEdi8seZUtS04NN1ipZBKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5c4P1WDTTAgylsd7CpFi7oPLgc3rlTHvmvqfZGbB3Ws=;
 b=RQ07+sHAzW42vY9YjeMZ9xXg+ufjEwv9Pmxp9/oQ4UAeB0Ios6tfHR3p449OozBfXiXDZ29rK8SY
   M6+Ae9a34+WNE0WNyoJkbKWRQtMON7uw8cvVhXcuAYf5AZqtJLFGA88Rd+Dsb/zGJPljMaclKqva
   1RfoSXiw0BQC4nrcDJ1tzyCSfuJ0cSVXaIiVAxouw7TbOFZZirD3h9Y6FBk7+iefzmoQXZjSVvku
   VQqEusD6pVMSMP79m25JjhSiKrnDo6IMEZ4cZybrZGdi4JL1E+kRPnQw/AmBo0U94NTcWFnI/Ohg
   DeUVZb6jhNsV/YoonMqZ1+kmjV3wtehkVzdKFQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRI004Z54FKN060@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Mar 2023 08:18:56 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Tue, 14 Mar 2023 09:17:15 +0100
Message-id: <20230314081720.4158676-2-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10648
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 priorityscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=100 mlxscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140070
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v8 1/6] reiserfs: Switch to
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
X-CM-TRANSID: GxC2BwBnNl2zLRBkenSXAQ--.34127S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur45GF1DJry5Wr15JFW7twb_yoW5Xw13pF
 47K3WUKr4kJF1Igr1Fya13W3WSgrWfGw47JrsxKrWDAanrJw18trW0yw13u34rGrZ7Jr1I
 qw409wsxCws8JwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
 A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
 JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
 0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
 JVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwI
 xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
 Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
 IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
 6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jn9N3UUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4qHYQAAsI
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: MekMB3SKgiPsW50X3K92LUsnMO3nPyBU
X-Proofpoint-ORIG-GUID: MekMB3SKgiPsW50X3K92LUsnMO3nPyBU
Reporting-Meta:
 AAH5/lD5wjmhv62vYEtqGZsJvwNt8jk7w6hZmbQUZbyJtsBILorNjwjyrkrysbg4
 gWgHY2KcvT69Srxzj6bhYJYIU6F/gZwzaOfQRErUV2hsa47nVdBFZsU7Di/J5oOk
 wZl980TNTQdJzPN5/3NNQtNX278T77lO6UDcIvXmLKgRmlDxqZ08HblaXFHoR3pw
 Oi0sIhL/B+0R/4f2IHQnwr/LhlYGlxl0O7xsz+5YMCJcpfSk2Q8Wb/IhXbNzNNA+
 4rmPHj6okoiox7EwOhWkdRMojdy3ez5XoGqI7WYJRMdICtjOu+B6VY+ZqWRNidRY
 ghTTLxvRgD6XZqBIvc6y6N422XynHKPzT1bWYcu11SfqlsaHcQWXKh3G0lw8TFIf
 V12yoMy14mrhsrZRndNBmuScHk8DviAU+/JNDw5TIsBxFb5qBuXV+VWRjY+RAsBk
 /iwH+hV08W2MnsXAdFA0ctLhrMorQQ0cDH7N16HO4EplyPUxW2WTe+8ZUgTZMMuX
 NVDhzjt/+bjjHVS5Kgz3kVqAV6uuVsMdwzpY3AVWBmnH

From: Roberto Sassu <roberto.sassu@huawei.com>

In preparation for removing security_old_inode_init_security(), switch to
security_inode_init_security(). Commit 572302af1258 ("reiserfs: Add missing
calls to reiserfs_security_free()") fixed possible memory leaks and another
issue related to adding an xattr at inode creation time.

Define the initxattrs callback reiserfs_initxattrs(), to populate the
name/value/len triple in the reiserfs_security_handle() with the first
xattr provided by LSMs. Make a copy of the xattr value, as
security_inode_init_security() frees it.

After the call to security_inode_init_security(), remove the check for
returning -EOPNOTSUPP, as security_inode_init_security() changes it to
zero.

Multiple xattrs are currently not supported, as the
reiserfs_security_handle structure is exported to user space. As a
consequence, even if EVM is invoked, it will not provide an xattr (if it
is not the first to set it, its xattr will be discarded; if it is the
first, it does not have xattrs to calculate the HMAC on).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
---
 fs/reiserfs/xattr_security.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index 41c0ea84fbf..6bffdf9a4fd 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -39,6 +39,22 @@ static bool security_list(struct dentry *dentry)
 	return !IS_PRIVATE(d_inode(dentry));
 }
 
+static int
+reiserfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		    void *fs_info)
+{
+	struct reiserfs_security_handle *sec = fs_info;
+
+	sec->value = kmemdup(xattr_array->value, xattr_array->value_len,
+			     GFP_KERNEL);
+	if (!sec->value)
+		return -ENOMEM;
+
+	sec->name = xattr_array->name;
+	sec->length = xattr_array->value_len;
+	return 0;
+}
+
 /* Initializes the security context for a new inode and returns the number
  * of blocks needed for the transaction. If successful, reiserfs_security
  * must be released using reiserfs_security_free when the caller is done. */
@@ -56,12 +72,9 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
 	if (IS_PRIVATE(dir))
 		return 0;
 
-	error = security_old_inode_init_security(inode, dir, qstr, &sec->name,
-						 &sec->value, &sec->length);
+	error = security_inode_init_security(inode, dir, qstr,
+					     &reiserfs_initxattrs, sec);
 	if (error) {
-		if (error == -EOPNOTSUPP)
-			error = 0;
-
 		sec->name = NULL;
 		sec->value = NULL;
 		sec->length = 0;
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
