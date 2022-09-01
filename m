Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5907ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=djRViFw8AAZ8KgNCZf4YmPiPpRLNTezYH5/pgBkztco=;
 b=sXm5h/Jrau+KjpKowF1hpL8L1EyLNpJs75QOJyj9p7A39IN9BoRUwzi3o1FpzEzTGbR5IKTAHlDj
   7QeDOr+RhHY31BpTcKYy9oD5HQoh3M5D6g31AetD0b2/Vm6cf7n10ZD3VfCKCBjRQoxAJ/cm3UK9
   RtPIv6FoHR6AU7Mr4eQXu9LnytwS+M8FFYqtxzbKvPhxD97EqWXO9YcvvC0jy8B4jZ4tSOxVb6Gs
   1C5/GFLS8kIN3dYFn23YrOc5s1jEyI4Erl9cNRloX1HW8zMiWl69n8bywChqB+DfgEEwZqHptgZc
   FMh5QSqWMRiZpaZP/x8ligtNTxQdVLwlJaP0Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=djRViFw8AAZ8KgNCZf4YmPiPpRLNTezYH5/pgBkztco=;
 b=CrRj7y2U4SoJWW2GTnxy5OAOC5IidEG1pSIquPqeV/C6NkIuDvA8uHbjFh7F7FolLo61aRT1Dd4Q
   1abk33Os/iEpcySginVn2byBWjcAkvNGYshBiq9MWLDr99/UlUr/yyviFpvNPy860r0CAARMdW8z
   JzJ2itylJ+nJoCsAyFbMGAf7VsIEapTMGKjjfKdGwpjH/lE3zYNnaz4hAlUgQhjjXC0XZa/jaU/g
   Cv/n0xHnxbLeiXvJKOh3t2ZqKpiw5PBzGjZaMu3XbUIkZGD+ZNIUNOAnJ5da8eINVmhdw4tW75u1
   QIidcq+w3z8epoE32/tNBB6QnBZKQGiY1zL9Jg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00KSO98MOB90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:22 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:58 +0800
Message-id: <20220901133505.2510834-8-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 adultscore=0 priorityscore=207 mlxlogscore=919
 clxscore=119 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 07/14] ntfs3: replace ll_rw_block()
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
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: QyRY08evVn4TPPUTQBkTqFRROIPb4t2A
X-Proofpoint-GUID: QyRY08evVn4TPPUTQBkTqFRROIPb4t2A
Reporting-Meta:
 AAFfKULcNnd8ob+lv6Rmz0hm+4jDKQ4SjPSny5cvGolflXJrnpD5Lyc4004Eim79
 lfs3wydxjdEcRtNumiJrLKMuve7pRRZ4ZDK/dmJNkwpDTG0p3lAkzlF3Z8a/Gygo
 fALVmHEEQdlFUbYt2Rw6Ul94rLiJlCrwsB7umc8DQmcux6HP6QRfphYSUDe/h32B
 CJ/Rf3mynCiisIiR9C1o97P9o7eHX+071e2po6u1O7PC+4lSuaVoVjL9PUW/jCyA
 CPHnpkeAoEkcSndj7SKH7bdxu9aRBKGKa82hpxa3Q2FmQQniUR/q8tX3tXpTTKkZ
 nmAJFsJqeVO4eaWpLQzSFcKhQupmNu0DjdhAEYh7x0RVTnYBufvZvCFaYkNn4q/q
 Z/93SHuMrHl3WtcrH3GqXRXFUHP3AMdqiATTQXenmUI3rbDB80H/F1UcFmy+c/oU
 +ay4wEihkGicaq5LWGsW1E+SK4PsbrPA1qop2HRG71767Es/bdSThB97FyNUzgLX
 BFvmMpqP3kCFPxgm9iUG7L8wvp+Hdt0leYFUUpokmkFK

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in
ntfs_get_block_vbo().

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ntfs3/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 51363d4e8636..cadbfa111539 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -630,12 +630,9 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
 			bh->b_size = block_size;
 			off = vbo & (PAGE_SIZE - 1);
 			set_bh_page(bh, page, off);
-			ll_rw_block(REQ_OP_READ, 1, &bh);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh)) {
-				err = -EIO;
+			err = bh_read(bh, 0);
+			if (err < 0)
 				goto out;
-			}
 			zero_user_segment(page, off + voff, off + block_size);
 		}
 	}
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
