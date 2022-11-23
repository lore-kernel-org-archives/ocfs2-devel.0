Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8347C43219
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jCojCFhJkowZgdK1oYboC0Xg5/GJjdljmat1wTH9qGo=;
 b=s+lctxWN1W9K9MZzbKHKgmI74TCmG4+FerlXSYGKbiXaGHIypm8Y9Hw4eNmwejjPeXDmXT7WxTzX
   IGAyCX0G7+5zxjjQhfYiOtfm281V2HK1Rn+i/xASmm1VTBnmFARe5wUbGQdBjIFJkURERj4/kmYN
   BAaGTzZ9sXflD/I7lU/SwgNc3idsCW7XRGMWwBDMXNH4rc1VPnedK19zayz3csYFUXJORc20Mp+t
   uZH1j8jkudXLiF0PkBAUHkl1jpsF1vH2DszA9b5vPLaEicxHITtoVMtM6v9ildmj55dXQFpvN7pv
   3UNb+XjsasYpswXV6G3R834noEdPIuAtIT6uoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jCojCFhJkowZgdK1oYboC0Xg5/GJjdljmat1wTH9qGo=;
 b=NS0/hQbcyA15OlVes7FWIKktTCAnIJWkQhKXi2Zh+3Ov5LG5K2WIQSkhDzwQfgSr+/3py7mkX0Gz
   p/6/IsEOK9kord2W4bafLilC76DYAE1h0wkqCPAYEWaZdgFauqyO77hgJF2G9lUFCHwFZbxZp0DE
   iaTI+uzBhD24tyESeS2DxiToccPEtQOlySkGxuEFiHgpOiWm1BT8zZ/UW1PhXFqmGS1ewiqxtE4b
   o2kjfjIMyE790tMNGWAl8xu0Au9rnihqCP3Gmp/2ntw55IzCrE0rteVlDKOc5PR2uj8oevH4YdRU
   lKE/CMaS65uul+ttlvlM2bX+RS6OI3V8RFwMyQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLS00LTXOSNKGB0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 09:53:11 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 10:51:57 +0100
Message-id: <20221123095202.599252-2-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
References: <20221123095202.599252-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10539
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=0 mlxlogscore=804 adultscore=0 clxscore=42 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230074
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v5 1/6] reiserfs: Switch to
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
X-CM-TRANSID: LxC2BwAH829J7X1jzDqKAA--.13162S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF15GF43Aw1UuFyUZr48tFb_yoW8Kr1kpF
 47K3W7Grs8JF1xWr1Sya13W3WfKrWfKa17JwsxK34DAanrJw18trW0yw13u34rJrWkJr1I
 qw4Iyw43Gwn8XwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
 A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
 6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
 WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
 bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
 AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
 F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
 ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
 0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x
 07jqYL9UUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAFBF1jj4XF3wAAsu
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: Z4nF0ex7aGWW9A2XUm4_OsmfaHsz9b-l
X-Proofpoint-ORIG-GUID: Z4nF0ex7aGWW9A2XUm4_OsmfaHsz9b-l
Reporting-Meta:
 AAEZPTpQQfWAJwuhcBzPExu8TI3SD0P0xQ4JMJRSIXbpacVwUYOUbKvNFewE+5vJ
 zWlB6lFANHpNCpJzb0n2vMbz4r7f8nSbkVmjd6FcLDzkc4WFRaWT5SJD3m66Ylnm
 Wp/sl9Kh+ZIZuHRxm8+MxfQuM1NnjKkYiIBYzhh2Omi+fF1cnjdaxm8fuThylR62
 Q+FT3XZeYU4gbAjpN4QISrBke1D5E/zNMCdAn35bU48GQY/CxNnV88XwerLeP0hF
 wa2ycIgPpsgCf7SRcJuKHpEIwIELo67VdADq7mOd2zBYeYDR41ZW/7L0+KDfWZr4
 7ZA7o4hiBGhLjOkco4+5Ldeo/TirK6hyv9ghsJZbNGYhoNdMnnBZtulstY0QconS
 aqhVzxNPVXknSs1PRfdySZgAZNzx+q7j/4hqnxetqhDxYInNBvfQ4rTJe6IemIvK
 Nh345/H2q619r2GAA5tOMACGAqTLH2+ACn/FCiJCVSpvR2mYFwVgOM3ytO785464
 gyaQZGMqImxL2m/L9+tX/5xMgP9aRJpdRbFYWivaI4VO

From: Roberto Sassu <roberto.sassu@huawei.com>

In preparation for removing security_old_inode_init_security(), switch to
security_inode_init_security().

Define the initxattrs callback reiserfs_initxattrs(), to populate the
name/value/len triple in the reiserfs_security_handle() with the first
xattr provided by LSMs. Multiple xattrs are currently not supported, as the
reiserfs_security_handle structure is exported to user space.

In reiserfs_initxattrs(), make a copy of the first xattr value, as
security_inode_init_security() frees it.

After the call to security_inode_init_security(), remove the check for
returning -EOPNOTSUPP, as security_inode_init_security() changes it to
zero.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/reiserfs/xattr_security.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index 857a65b05726..0ba96757681d 100644
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
