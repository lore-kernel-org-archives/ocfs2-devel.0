Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620F1C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Nov 2022 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TVtr2Dvo0mrimcEowlPHLZIz1vPLZi3sSU+MAi/eF2U=;
 b=1UEig2IxRtyIGH0ykjhD9nlzoiTuVGNOF56H4IjB0Lvg/wQa+HneYAiGO4lbubS3T0eE5I2PT1v7
   43ivbLou7hoqD92aLR1qQnHZoH8PxJaj1vWy959aJzUIFCJ3b4lNEkVrp4wNNB1+6M/k9nxZoZ2c
   OeWCB/zOqo4y4rV4et/TRy8zNPni3iVqcUCXzV8Z2z1YvOd/hMr+A2eFRtfqXIyuCtx0QHkflTc8
   M4CSXG5dp4MwcrPEhbzXCxw0N82rGIaplzxVZVFcpIpmC3HVLCwiLord3S8lTSBzr4mE46lzCuhs
   WAdu7x3WSlrX0YwyzxHqZ5VCeaq5/ZrB463Acw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TVtr2Dvo0mrimcEowlPHLZIz1vPLZi3sSU+MAi/eF2U=;
 b=m2KZ6wqOK2KHSj8YgmFgveiJEa6xdxJ9ZyrkQiNX1N1fZ3sSEV1iUuFERYCPsu4TcFK/Z7dafd0t
   egiOEVf50WCPt/7s070CHpR3gYfaj2YRWFxlae4/y+I/dzHMuzsS2k8utr5KGCOQPLMYSzfQgKOM
   Ag7+lNtNfFG8hTxWCBEq4u3ulna8vjdVBc98UcpYvGC61XdrUWMTz+uX4/AQKShh8wv4IpePCOhN
   JoA9EsNueuXG5WJZ7OWLCssfCkLLsi3ZZ/X4CkRm2Yt+NP+wC+SYYggAl0qqv1MRcvlRVOAzyDHU
   6un5Rsxa61/QbESHW00PNAz1O1K9O+8xxz/2CQ==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLT00IDD59HF7B0@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Nov 2022 15:48:53 +0000 (GMT)
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
 eparis@parisplace.org, casey@schaufler-ca.com
Date: Wed, 23 Nov 2022 16:47:07 +0100
Message-id: <20221123154712.752074-2-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
References: <20221123154712.752074-1-roberto.sassu@huaweicloud.com>
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10540
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 spamscore=0 mlxlogscore=858 phishscore=0 lowpriorityscore=0 clxscore=110
 bulkscore=0 mlxscore=0 priorityscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230116
Cc: nicolas.bouchinet@clip-os.org, keescook@chromium.org,
 selinux@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
 reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v6 1/6] reiserfs: Switch to
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
X-CM-TRANSID: LxC2BwD34W6OQH5jUE+LAA--.33660S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF15GF43Aw1UuFyUKw1DGFg_yoW5JF1rpF
 43K3W7Krs8JF1Igr1Sya13W3WfKrWfKw47JrsxK34DAanrJw1rtry0yw13u34rGrZ7Jr1I
 qw4Ivw43Cws8JwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
 A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
 w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
 W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
 Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
 Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
 Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
 vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
 jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
 x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
 8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
 0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU8-TmDUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAFBF1jj4XL2AAAsn
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8J_hfWqut9SIgdK__NaqCSmKg01SchUQ
X-Proofpoint-ORIG-GUID: 8J_hfWqut9SIgdK__NaqCSmKg01SchUQ
Reporting-Meta:
 AAHnS9eHKZipF0CfAlCuvu6PAAWNAaD4LgE45KtuuHPuwP5yMi16xEUXf9izgdfe
 s1aETvv9LqMpkxML/TwC8Ge6f00BRk3j68y72l8yZ5wCU34R6yvH2OtW2lh+sv6o
 DNU3PIFgGv1iFNirjGhQYE669hhqTofgf9MX+aOosqj8wJLNyuSNCN3zryl5Bj+I
 2Heg/hqgswTujkzoBi65p9/MGF4kwSCx+reBoGjt0J1pOgonBodX+hLvl2BoxHg8
 g5TLgp1CYEpCXYk4g//NrsbnI0TKjNs0GZ0zTIObJEroH2re9u7CNtHwJ2Cy/SpA
 TV0aDS+Dnca4dPxNkmJW9Wi4x4wmOY9XRLm48Pr/mbiLMPfW7YwQK8SK4pkMZ02s
 xvgrhY3OCSEWqlxXNauZXU1OSCRqRbJ19M7m2JR0Ua3Bp85a8uPrqgsclQdH0TIe
 MRdTIszxCeOtd1fy2vqb2CL+zud7jv4DZ+gbJwVHncjEHdza8JjxuDdZw9znx10w
 7gIM5pGm73Z0ToyzksBMpI0o2QK4W9uBPQTsGVcw0Q0n

From: Roberto Sassu <roberto.sassu@huawei.com>

In preparation for removing security_old_inode_init_security(), switch to
security_inode_init_security().

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
